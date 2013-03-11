//
//  WFPreferenceWindowController.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-7.
//
//

#import "WFPreferenceWindowController.h"
#import "WFAppDelegate.h"
#import "NSData+Cache.h"

@interface WFPreferenceWindowController () <NSWindowDelegate>

@property (weak) IBOutlet NSUserDefaultsController *userDefaultsController;
@property (weak) IBOutlet NSTextField *cacheSize;

@property NSDictionary *bootTimePrefs;

- (IBAction)reset:(id)sender;
- (IBAction)revert:(id)sender;
- (IBAction)clearCache:(id)sender;

@end

@implementation WFPreferenceWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.bootTimePrefs = [[userDefaults persistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]] copy];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       long double size = 0;
                       NSUInteger unit = 0; // bytes;
                       NSFileManager *fileManager = [NSFileManager defaultManager];
                       NSArray *paths = [fileManager subpathsAtPath:[NSData cacheFolderLocation]];
                       for (NSString *path in paths)
                       {
                           NSDictionary *property = [fileManager attributesOfItemAtPath:[[NSData cacheFolderLocation] stringByAppendingPathComponent:path]
                                                                                  error:NULL];
                           size += [property fileSize];
                       }
                       while (size > 2048)
                       {
                           size /= 1024.0;
                           unit++;
                       }
                       NSNumber *sizeNumber = @((double)size);
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          NSArray *units = @[NSLocalizedString(@"bytes", @""), @"KiB", @"MiB", @"GiB", @"TiB", @"YiB", @"ZiB"];
                                          [self.cacheSize setStringValue:[NSString stringWithFormat:NSLocalizedString(@"Current cache size is approx. %.2lf%@.", @""), [sizeNumber doubleValue], units[unit]]];
                                      });
                   });
}

- (void)windowWillClose:(NSNotification *)notification
{
    [[NSApp delegate] releaseWindowController:self];
}

- (void)reset:(id)sender
{
    NSUserDefaults *userDefaults = [self.userDefaultsController defaults];
    NSDictionary *persistentStorage = [userDefaults persistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    for (id key in persistentStorage)
        [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
}

- (void)revert:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *currentPrefs = [[userDefaults persistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]] copy];
    for (id key in currentPrefs)
        [userDefaults removeObjectForKey:key];
    for (id key in self.bootTimePrefs)
        [userDefaults setObject:self.bootTimePrefs[key] forKey:key];
}

- (void)clearCache:(id)sender
{
    [NSData clearCache];
    [self.cacheSize setStringValue:NSLocalizedString(@"Cache cleared.", @"")];
}

@end
