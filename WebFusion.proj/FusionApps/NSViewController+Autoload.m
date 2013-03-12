//
//  NSViewController+Autoload.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-6.
//
//

#import "NSViewController+Autoload.h"

@implementation NSViewController (Autoload)

- (id)init
{
    return [self initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle bundleForClass:[self class]]];
}

@end
