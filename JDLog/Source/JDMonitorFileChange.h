//
//  JDMonitorFileChange.h
//  JDLog
//
//  Created by JD on 2018/5/30.
//  Copyright © 2018年 JD. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 文件监听器
 */
@interface JDMonitorFileChange : NSObject

/**
 监听文件变化

 @param filePath 文件路径
 @param block 变化类型，可以是删除、写入、更改等操作
 */
- (void)watcherForPath:(NSString *)filePath block:(void (^)(NSInteger type))block;

@end
