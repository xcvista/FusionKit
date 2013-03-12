//
//  WFAppCatalog.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-13.
//
//

#import "WFAppCatalog.h"

@interface WFAppCatalog ()

@end

@implementation WFAppCatalog

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
    return @"App Catalog";
}

- (NSString *)appCategory
{
    return @"WebFusion";
}

- (NSImage *)appIcon
{
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"Store" withExtension:@"pdf"]];
    [image setTemplate:YES];
    return image;
}

- (NSInteger)sortOrder
{
    return 5;
}

@end
