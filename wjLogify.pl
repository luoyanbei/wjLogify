#!/usr/bin/env perl
# logify.pl
############
# Converts an Objective-C header file (or anything containing a @interface and method definitions)
#+into a Logos input file which causes all function calls to be logged.
#
# Accepts input on stdin or via filename specified on the commandline.

# Lines are only processed if we were in an @interface, so you can run this on a file containing
# an @implementation, as well.
use strict;

use FindBin;
use lib "$FindBin::Bin/lib";

use Logos::Method;
use Logos::Util;
$Logos::Util::errorhandler = sub {
	die "$ARGV:$.: error: missing closing parenthesis$/"
};

my $interface = 0;
while(my $line = <>) {
	if($line =~ m/^[+-]\s*\((.*?)\).*?(?=;)/ && $interface == 1) {
		print logLineForDeclaration($&);
	} elsif($line =~ m/^\s*\@property\s*\((.*?)\)\s*(.*?)\b([\$a-zA-Z_][\$_a-zA-Z0-9]*)(?=;)/ && $interface == 1) {
		my @attributes = smartSplit(qr/\s*,\s*/, $1);
		my $propertyName = $3;
		my $type = $2;
		my $readonly = scalar(grep(/readonly/, @attributes));
		my %methods = ("setter" => "set".ucfirst($propertyName).":", "getter" => $propertyName);
		foreach my $attribute (@attributes) {
			next if($attribute !~ /=/);
			my @x = smartSplit(qr/\s*=\s*/, $attribute);
			$methods{$x[0]} = $x[1];
		}
		if($readonly == 0) {
			print logLineForDeclaration("- (void)".$methods{"setter"}."($type)$propertyName");
		}
		print logLineForDeclaration("- ($type)".$methods{"getter"});
	} elsif($line =~ m/^\@interface\s+(.*?)\s*[:(]/ && $interface == 0) {
		print "%hook $1\n";
		$interface = 1;
	} elsif($line =~ m/^\@end/ && $interface == 1) {
		print "%end\n";
		$interface = 0;
	}
}

sub logLineForDeclaration {
	#定义变量
	my $declaration = shift;
	$declaration =~ m/^[+-]\s*\((.*?)\).*?/;
	my $rtype = $1;
	my $innards = "%log; ";
	$innards .= "NSLog(@\"开始执行 $declaration\"); ";#添加此句，当该方法开始时打印“开始执行 + 方法名”

	if($rtype ne "void") {
		#有返回值时
		#'.='表示append,附加
		$innards .= "$rtype r = %orig; ";
		#修改此句，当有返回值时，打印“方法名 + 的返回值 = 真实的返回值”
		$innards .= "NSLog(@\"$declaration 的返回值 = ".Logos::Method::formatCharForArgType($rtype)."\", ".Logos::Method::printArgForArgType($rtype, "r")."); " if defined Logos::Method::printArgForArgType($rtype, "r");
		$innards .= "NSLog(@\"结束执行 $declaration\"); ";#添加此句，当该方法结束时打印“结束执行 + 方法名”
		$innards .= "return r; ";
	} else {
		#无返回值时
		$innards .= "%orig; ";
		$innards .= "NSLog(@\"结束执行 $declaration\"); ";#添加此句，当该方法结束时打印“结束执行 + 方法名”

	}

	#$declaration是方法名和参数，$innards是方法内部的内容
	return "$declaration { $innards}\n";
}
