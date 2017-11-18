# wjLogify

在iOS的逆向开发中，常用Logify.pl 来跟踪函数的调用，以及获取调用的参数。

wjLogify对Logify的代码做了简单修改，更好的展示一个方法的开始与结束，并清晰的标明方法的返回值。

#如何使用

1.下载wjLogify.pl文件，把wjLogify.pl移动到theos下的bin文件夹中。

2.在终端中，为wjLogify.pl添加执行权限：
    chmod +x /path/to/wjLogify.pl
如果上一句无效，可添加sudo，如下：
    sudo chmod +x /path/to/wjLogify.pl
