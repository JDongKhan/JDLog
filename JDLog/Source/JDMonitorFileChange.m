//
//  JDMonitorFileChange.h
//  JDLog
//
//  Created by JD on 2018/5/30.
//  Copyright © 2018年 JD. All rights reserved.
//

#import "JDMonitorFileChange.h"
@interface JDMonitorFileChange () {
@private
  NSURL *_fileURL;
  dispatch_source_t _source;
  int _fileDescriptor;
}

@property (nonatomic,copy) void (^fileChangeBlock)(NSInteger type);

@end

@implementation JDMonitorFileChange

- (void)watcherForPath:(NSString *)filePath block:(void (^)(NSInteger type))block {
    self.fileChangeBlock = block;
    NSURL *url = [NSURL URLWithString:filePath];
    _fileURL = url;
    [self __beginMonitoringFile];
}


- (void)dealloc {
    [self __close];
}

- (void)__beginMonitoringFile {
    _fileDescriptor = open([[_fileURL path] fileSystemRepresentation],
                         O_EVTONLY);
    dispatch_queue_t defaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _source = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
                                   _fileDescriptor,
                                   DISPATCH_VNODE_ATTRIB | DISPATCH_VNODE_DELETE | DISPATCH_VNODE_EXTEND | DISPATCH_VNODE_LINK | DISPATCH_VNODE_RENAME | DISPATCH_VNODE_REVOKE | DISPATCH_VNODE_WRITE,
                                   defaultQueue);
    __weak JDMonitorFileChange *weakSelf = self;
    dispatch_source_set_event_handler(_source, ^ {
        __strong JDMonitorFileChange *strongSelf = weakSelf;
        unsigned long eventTypes = dispatch_source_get_data(strongSelf->_source);
        [strongSelf __alertDelegateOfEvents:eventTypes];
    });
    dispatch_resume(_source);
}

- (void)__close {
    close(_fileDescriptor);
    dispatch_source_cancel(_source);
    _fileDescriptor = 0;
    _source = nil;
}

- (void)__alertDelegateOfEvents:(unsigned long)eventTypes {
    dispatch_async(dispatch_get_main_queue(), ^ {
        BOOL closeDispatchSource = NO;
        NSMutableSet *eventSet = [[NSMutableSet alloc] initWithCapacity:7];
        if (eventTypes & DISPATCH_VNODE_ATTRIB) {
            [eventSet addObject:@(DISPATCH_VNODE_ATTRIB)];
        }
        if (eventTypes & DISPATCH_VNODE_DELETE) {
            [eventSet addObject:@(DISPATCH_VNODE_DELETE)];
            closeDispatchSource = YES;
        }
        if (eventTypes & DISPATCH_VNODE_EXTEND) {
            [eventSet addObject:@(DISPATCH_VNODE_EXTEND)];
        }
        if (eventTypes & DISPATCH_VNODE_LINK) {
            [eventSet addObject:@(DISPATCH_VNODE_LINK)];
        }
        if (eventTypes & DISPATCH_VNODE_RENAME){
            [eventSet addObject:@(DISPATCH_VNODE_RENAME)];
            closeDispatchSource = YES;
        }
        if (eventTypes & DISPATCH_VNODE_REVOKE) {
            [eventSet addObject:@(DISPATCH_VNODE_REVOKE)];
        }
        if (eventTypes & DISPATCH_VNODE_WRITE) {
            [eventSet addObject:@(DISPATCH_VNODE_WRITE)];
        }
        for (NSNumber *eventType in eventSet) {
            if (self.fileChangeBlock) {
                self.fileChangeBlock([eventType unsignedIntegerValue]);
            }
        }
        if (closeDispatchSource) {
            [self __close];
        }
    });
}

@end
