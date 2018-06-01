# JDLog
将NSLog写入文件并显示在手机控制台上，方便测试包日志调试

效果图如下

![](https://github.com/JDongKhan/JDLog/blob/master/demo.gif)




# CocoaPods

1、在 Podfile 中添加 `pod 'JDLog'`。

2、执行 `pod install` 或 `pod update`。

3、导入 \<JDLog/JDLogFileManager.h\>。

4、开始监控： [[JDLogFileManager shareInstance] start];

5、你直接push到JDLogViewController界面即可！其他不用你管。
