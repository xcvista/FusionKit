//
//  WFDeveloper.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-12.
//
//

#import "WFDeveloper.h"

@implementation WFDeveloper

- (NSString *)appName
{
    return @"Dev Portal";
}

- (NSString *)appCategory
{
    return @"Developer";
}

- (NSImage *)appIcon
{
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"Developer" withExtension:@"pdf"]];
    [image setTemplate:YES];
    return image;
}

- (NSInteger)sortOrder
{
    return -1;
}

@end
