# JDLog
将NSLog写入文件并显示在手机控制台上，方便测试包日志调试

它不止可以显示我们自己的日志，包括异常系统、第三方日志都可以显示。
只要你控制台能看到的它都可以。



## 原理
更改了NSLog的输出源，将日志写入文件并监控文件变化。

效果图如下

![](https://github.com/JDongKhan/JDLog/blob/master/demo.gif)




# CocoaPods

1、在 Podfile 中添加 `pod 'JDLog'`。

2、执行 `pod install` 或 `pod update`。

3、导入 \<JDLog/JDLogFileManager.h\>。

4、开始监控： [[JDLogFileManager shareInstance] start];

5、你直接push到JDLogViewController界面即可！其他不用你管。
