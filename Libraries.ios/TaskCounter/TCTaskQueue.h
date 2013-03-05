//
//  TCTaskQueue.h
//  FusionKit
//
//  Created by Maxthon Chan on 12-8-3.
//  Copyright (c) 2012年 myWorld Creations. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^TCTask)(id);
typedef void (^TCCompletionHandler)(id, id);

@interface TCTaskQueue : NSObject

@property (readonly) NSUInteger taskCount;
@property (readonly) BOOL running;

+ (TCTaskQueue *)taskQueue;

- (void)addTask:(TCTask)task withObject:(id)object completion:(TCCompletionHandler)completion;

- (void)start;
- (void)stop;
- (void)purge;

@end
