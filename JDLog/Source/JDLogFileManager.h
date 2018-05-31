//
//  JDLogFileManager.h
//  JDLog
//
//  Created by JD on 2018/5/30.
//  Copyright © 2018年 JD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDLogFileManager : NSObject

+ (instancetype)shareInstance;

/**
 读取日志文件内容
 */
- (NSString *)readLog;

/**
 监听日志文件变化
 */
- (void)watcherLog:(void(^)(NSInteger type))block;

/**
 停止监听
 */
- (void)stopWatcher;

/**
 清理日志
 */
- (void)clearLog;

@end
