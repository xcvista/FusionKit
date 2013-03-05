//
//  TCTaskCounter.m
//  FusionKit
//
//  Created by Maxthon Chan on 12-8-3.
//  Copyright (c) 2012年 myWorld Creations. All rights reserved.
//

#import "TCTaskCounter.h"

TCTaskCounter *taskCounter;

@interface TCTaskCounter ()

@property (atomic) NSUInteger count;

@end

@implementation TCTaskCounter

@synthesize count;

- (void)update
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = (count) ? YES : NO;
    });
}

- (void)start
{
    self.count++;
    [self update];
}

- (void)stop
{
    if (self.count)
        self.count--;
    [self update];
}

+ (TCTaskCounter *)taskCounter
{
    if (!taskCounter)
        taskCounter = [[TCTaskCounter alloc] init];
    return taskCounter;
}

@end
