# JDLog
将NSLog写入文件并显示在手机控制台上，方便测试包日志调试

它不止可以显示我们自己的日志，包括异常系统、第三方日志都可以显示。
只要你控制台能看到的它都可以。

## 有这么一个场景

```
在日常开发过程中，我发现我们的开发人员解Bug占很大的比例，尤其是测试提出了你复现不了。
每次当测试吧啦吧啦一堆给你讲场景，你自己去操作还是云里雾里，心想肯定是测试SB或者机器有问题。
然后开始迈上了查找Bug的旅途。

如果你连上电脑Debug，看到了控制台的奔溃日志，你是不是很快就解决了。

那么现在有这么一个工具，当测试说闪退了，你就让他打开手机控制台，然后把异常发给你，是不是就不用你再去复现了。
```

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
