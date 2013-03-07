//
//  WFPreferenceWindowController.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-7.
//
//

#import "WFPreferenceWindowController.h"
#import "WFAppDelegate.h"

@interface WFPreferenceWindowController () <NSWindowDelegate>

@property (weak) IBOutlet NSUserDefaultsController *userDefaultsController;

@property NSDictionary *bootTimePrefs;

- (IBAction)reset:(id)sender;
- (IBAction)revert:(id)sender;

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

@end
