//
//  NSWindowController+Autoload.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-6.
//
//

#import "NSWindowController+Autoload.h"

@implementation NSWindowController (Autoload)

- (id)init
{
    return [self initWithWindowNibName:NSStringFromClass([self class])];
}

- (void)close:(id)sender
{
    [self close];
}

@end
