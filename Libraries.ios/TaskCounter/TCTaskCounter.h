//
//  TCTaskCounter.h
//  FusionKit
//
//  Created by Maxthon Chan on 12-8-3.
//  Copyright (c) 2012年 myWorld Creations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCTaskCounter : NSObject

+ (TCTaskCounter *)taskCounter;

- (void)start;
- (void)stop;

@end
