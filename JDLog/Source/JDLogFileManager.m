//
//  JDLogFileManager.m
//  JDLog
//
//  Created by JD on 2018/5/30.
//  Copyright © 2018年 JD. All rights reserved.
//

#import "JDLogFileManager.h"
#import "JDMonitorFileChange.h"

@interface JDLogFileManager()

@property (nonatomic, strong) NSFileHandle *fileHandle;

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, strong) JDMonitorFileChange *fileHelper;

@end

@implementation JDLogFileManager

+ (instancetype)shareInstance {
    static JDLogFileManager *logFileManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logFileManager = [[JDLogFileManager alloc] init];
        
    });
    return logFileManager;
}

- (void)start {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths firstObject];
    NSString *fileName = @"JDLog.log";
    self.filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    //改写NSLog输出目录
    [self redirectNSlogToCachesFolder];
}

// 将NSLog打印信息保存到Caches目录下的文件中
- (void)redirectNSlogToCachesFolder {
    // 将log输入到文件
    freopen([self.filePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout);
    freopen([self.filePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

- (NSString *)readLog {
    NSString *string = [NSString stringWithContentsOfFile:self.filePath encoding:NSUTF8StringEncoding error:nil];
    return string;
}

- (void)watcherLog:(void(^)(NSInteger type))block {
    self.fileHelper = [[JDMonitorFileChange alloc] init];
    [self.fileHelper watcherForPath:self.filePath block:^(NSInteger type) {
        if (block) {
            block(type);
        }
    }];
}

- (void)stopWatcher {
    self.fileHelper = nil;
}

- (void)clearLog {
    [@"" writeToFile:self.filePath atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

@end
