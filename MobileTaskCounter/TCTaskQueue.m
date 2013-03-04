//
//  TCTaskQueue.m
//  FusionKit
//
//  Created by Maxthon Chan on 12-8-3.
//  Copyright (c) 2012年 myWorld Creations. All rights reserved.
//

#import "TCTaskQueue.h"
#import "TCTaskCounter.h"

TCTaskQueue *taskQueue;

@interface TCTaskInternal : NSObject

@property (nonatomic, strong) TCTask task;
@property (nonatomic, strong) id object;
@property (nonatomic, strong) TCCompletionHandler completion;

- (void)execute;

@end

@interface TCTaskQueue ()

@property (atomic, strong) NSMutableArray *taskPool;
@property (atomic) BOOL _running;

@property (nonatomic) dispatch_queue_t queue;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation TCTaskQueue

- (NSUInteger)taskCount
{
    return self.taskPool.count;
}

- (BOOL)running
{
    return self.timer.isValid;
}

- (id)init
{
    if (self = [super init])
    {
        self.taskPool = [NSMutableArray array];
        self.queue = dispatch_queue_create("tk.technix.task-queue", 0);
    }
    return self;
}

- (void)dealloc
{
    dispatch_release(self.queue);
    self.queue = nil;
}

- (void)addTask:(TCTask)task withObject:(id)object completion:(TCCompletionHandler)completion
{
    TCTaskInternal *taskObject = [[TCTaskInternal alloc] init];
    taskObject.task = task;
    taskObject.object = object;
    taskObject.completion = completion;
    [self.taskPool addObject:taskObject];
    if (!self.running)
        [self start];
}

- (void)start
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(_timerFired:) userInfo:nil repeats:YES];
}

- (void)stop
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)_timerFired:(id)sender
{
    if (self._running || !(self.taskPool.count))
        return;
    self._running = YES;
    
    [[TCTaskCounter taskCounter] start];
    dispatch_async(self.queue, ^{
        while (self.taskPool.count)
        {
            TCTaskInternal *task = [self.taskPool objectAtIndex:0];
            [task execute];
            [self.taskPool removeObjectAtIndex:0];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[TCTaskCounter taskCounter] stop];
            self._running = NO;
        });
    });
}

+ (TCTaskQueue *)taskQueue
{
    if (!taskQueue)
        taskQueue = [[TCTaskQueue alloc] init];
    return taskQueue;
}

- (void)purge
{
    [self.timer fire];
}

@end

@implementation TCTaskInternal

- (void)execute
{
    id value = (self.task) ? (self.task)(self.object) : nil;
    if (self.completion)
        dispatch_async(dispatch_get_main_queue(), ^{
            (self.completion)(self.object, value);
        });
}

@end