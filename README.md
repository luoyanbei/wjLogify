# wjLogify

在iOS的逆向开发中，常用Logify.pl 来跟踪函数的调用，以及获取调用的参数。

wjLogify对Logify的代码做了简单修改，更好的展示一个方法的开始与结束，并清晰的标明方法的返回值。

#如何使用

1.下载wjLogify.pl文件，把wjLogify.pl移动到theos下的bin文件夹中。

2.在终端中，为wjLogify.pl添加执行权限：

    chmod +x /path/to/wjLogify.pl

如果上一句无效，可添加sudo，如下：

    sudo chmod +x /path/to/wjLogify.pl

#打印范例：

-[<RsaCGIWrapLogic: 0x17063be60> stopLogic]

 -- 开始执行 - (void)stopLogic

-[<RsaCGIWrapLogic: 0x17063be60> m_uiEventID]

 -- 开始执行 - (unsigned long )m_uiEventID

 -- - (unsigned long )m_uiEventID 的返回值 = 20

 -- 结束执行 - (unsigned long )m_uiEventID

-[<RsaCertMgr: 0x1712431e0> removeRSAProtobufEvent:20]

 -- 开始执行 - (void)removeRSAProtobufEvent:(unsigned long)arg1

+[<RsaCertMgr: 0x103bd0000> getExtKeyFromEventID:20]

 -- 开始执行 + (id)getExtKeyFromEventID:(unsigned long)arg1

 -- + (id)getExtKeyFromEventID:(unsigned long)arg1 的返回值 = 20

 -- 结束执行 + (id)getExtKeyFromEventID:(unsigned long)arg1

-[<RsaCertMgr: 0x1712431e0> safeRemoveRsaCGIWrapForKey:20]

 -- 开始执行 - (void)safeRemoveRsaCGIWrapForKey:(id)arg1

 -- 结束执行 - (void)safeRemoveRsaCGIWrapForKey:(id)arg1

 -- 结束执行 - (void)removeRSAProtobufEvent:(unsigned long)arg1

 -- 结束执行 - (void)stopLogic
