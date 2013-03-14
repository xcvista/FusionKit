//
//  WFViewController.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-12.
//
//

#import "WFViewController.h"
#import "WFApplicationServices.h"

NSString *const WFPollNotification = @"tk.maxius.webfusion.poll";

@interface WFViewController () <NSCopying>

@property (getter = isActive) BOOL active;

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
    NSString *string = [[self appBundle] infoDictionary][@"WFAppName"];
    return string ? string : [[NSBundle bundleForClass:[self class]] infoDictionary][(NSString *)kCFBundleNameKey];
}

- (NSString *)longAppName
{
    NSString *string = [[self appBundle] infoDictionary][@"WFLongAppName"];
    return string ? string : [self appName];
}

- (NSBundle *)appBundle
{
    return [NSBundle bundleForClass:[self class]];
}

- (NSString *)appCategory
{
    NSString *string = [[self appBundle] infoDictionary][@"WFAppCategory"];
    return string ? string : @"Misc";
}

- (NSImage *)appIcon
{
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[[self appBundle] URLForResource:[[self appBundle] infoDictionary][@"WFAppIcon"] withExtension:@""]];
    if (image)
    {
        NSNumber *number = [[self appBundle] infoDictionary][@"WFAppIconTemplate"];
        [image setTemplate:number ? [number boolValue] : YES];
    }
    else
    {
        image = [[NSImage alloc] initWithContentsOfURL:[[NSBundle bundleForClass:[WFViewController class]] URLForResource:@"Apps" withExtension:@"pdf"]];
        [image setTemplate:YES];
    }
    return image;
}

- (NSDictionary *)appVersion
{
    NSDictionary *dictionsry = [NSDictionary dictionaryWithContentsOfURL:[[self appBundle] URLForResource:@"version"
                                                                                            withExtension:@"plist"]];
    return dictionsry ? dictionsry : [[[self appBundle] infoDictionary] dictionaryWithValuesForKeys:@[(NSString *)kCFBundleVersionKey]];
}

- (NSInteger)sortOrder
{
    return 0;
}

- (BOOL)canUnload
{
    return YES;
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

- (BOOL)showInSidebar
{
    return YES;
}

- (void)applicationDidLoad
{
    [[WFApplicationServices applicationServices] setDefaults:[NSDictionary dictionaryWithContentsOfURL:[[self appBundle] URLForResource:@"defaults" withExtension:@"plist"]]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pollDidFinish:)
                                                 name:WFPollNotification
                                               object:nil];
}

- (void)applicationWillUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear
{
    self.active = YES;
}

- (void)viewWillDisappear
{
    self.active = NO;
}

#pragma mark - Compiler pacifiers

- (NSDictionary *)registerPoll
{
    // eh
    return nil;
}

- (void)pollDidFinish:(NSNotification *)aNotification
{
    // eh
}

- (void)pull
{
    // eh
}

- (void)userDidLogin
{
    // eh
}

- (BOOL)hasPreferences
{
    return NO; // eh
}

- (void)showPreferences
{
    // eh
}

- (id)executeMethod:(NSString *)method withArguments:(NSArray *)arguments
{
    return nil; // eh
}

@end
