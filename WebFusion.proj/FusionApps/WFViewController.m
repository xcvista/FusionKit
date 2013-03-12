//
//  WFViewController.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-12.
//
//

#import "WFViewController.h"

@interface WFViewController () <NSCopying>

@end

@implementation WFViewController

- (id)init
{
    return [self initWithNibName:NSStringFromClass([self class]) bundle:[NSBundle bundleForClass:[self class]]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSString *)appName
{
    return nil;
}

- (NSString *)appCategory
{
    return @"Misc";
}

- (NSImage *)appIcon
{
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[[NSBundle bundleForClass:[WFViewController class]] URLForResource:@"Apps" withExtension:@"pdf"]];
    [image setTemplate:YES];
    return image;
}

- (NSInteger)sortOrder
{
    return 0;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (NSComparisonResult)compare:(WFViewController *)other
{
    NSComparisonResult catergoryCmp = [self.appCategory compare:other.appCategory options:NSNumericSearch | NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch];
    if (catergoryCmp == NSOrderedSame)
    {
        NSInteger order1 = [self sortOrder];
        NSInteger order2 = [other sortOrder];
        if (order1 < order2)
            return NSOrderedAscending;
        else if (order1 > order2)
            return NSOrderedDescending;
        else
            return [self.appName compare:other.appName options:NSNumericSearch | NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch];
    }
    else
    {
        if ([self.appCategory isEqualToString:@"WebFusion"])
            return NSOrderedAscending;
        else if ([other.appCategory isEqualToString:@"WebFusion"])
            return NSOrderedDescending;
        else
            return catergoryCmp;
    }
}

- (void)applicatinDidLoad
{
    // eh
}

- (void)applicationWillUnload
{
    // eh
}

- (void)viewWillAppear
{
    // eh
}

- (void)viewWillDisappear
{
    // eh
}

- (void)pull
{
    // eh
}

@end
