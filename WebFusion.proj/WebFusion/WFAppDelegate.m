//
//  WFAppDelegate.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-4.
//
//

#import "WFAppDelegate.h"
#import "WFMainWindowController.h"
#import "WFAboutBoxWindowController.h"
#import "WFPreferenceWindowController.h"
#import "WFPreferenceKeys.h"

@interface WFAppDelegate ()

@property (weak) IBOutlet NSMenuItem *mainWindowItem;
@property (weak) IBOutlet NSMenuItem *dockMainWindowItem;

@property NSMutableDictionary *bootTimePrefs;

@end

@implementation WFAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [WFApplicationServices applicationServices].delegate = self;
    
    [[NSDocumentController sharedDocumentController] clearRecentDocuments:self];
    
    self.bootTimePrefs = [NSMutableDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"defaults" withExtension:@"plist"]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [WFAppLoader appLoader];
    [userDefaults registerDefaults:self.bootTimePrefs];
    NSUserDefaultsController *userDefaultsController = [NSUserDefaultsController sharedUserDefaultsController];
    [userDefaultsController setInitialValues:self.bootTimePrefs];
    self.bootTimePrefs = (NSMutableDictionary *)[[userDefaults persistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]] copy];
    [userDefaults synchronize];
    
    if ([userDefaults boolForKey:WFOverrideMode])
    {
        NSLog(@"App started in Override mode, behavior will drastically change.");
        [userDefaults setBool:NO forKey:WFDeveloperMode];
        self.override = YES;
    }
    
    if ([userDefaults boolForKey:WFShowPacketInspectorAtLaunch])
    {
        [userDefaults setBool:YES forKey:WFDeveloperMode];
    }
    
    // Show the initial window.
    self.windowControllers = [NSMutableArray array];
    [self showWindowController:[[WFLoginWindowController alloc] init]]; 
}

- (void)setDefaults:(NSDictionary *)defaults
{
    if (defaults)
        [self.bootTimePrefs addEntriesFromDictionary:defaults];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    for (WFViewController *app in [[WFAppLoader appLoader] loadedApps])
    {
        [app applicationWillUnload];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (self.override)
    {
        // Nuke all preferences and reload boot-time copy.
        
        NSDictionary *currentPrefs = [[userDefaults persistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]] copy];
        for (id key in currentPrefs)
            [userDefaults removeObjectForKey:key];
        for (id key in self.bootTimePrefs)
            [userDefaults setObject:self.bootTimePrefs[key] forKey:key];
    }
    else
    {
        [userDefaults synchronize];
    }
}

- (BOOL)application:(id)sender openFileWithoutUI:(NSString *)filename
{
    return YES;
}

- (void)showWindowController:(NSWindowController *)windowController
{
    if (![self.windowControllers containsObject:windowController])
        [self.windowControllers addObject:windowController];
    [windowController showWindow:self];
}

- (void)releaseWindowController:(NSWindowController *)windowController
{
    [self.windowControllers removeObject:windowController];
}

- (void)closeAllWindowControllerWithClass:(Class)class
{
    NSArray *currentVC = [self.windowControllers copy];
    for (NSWindowController *object in currentVC)
        if ([object isKindOfClass:class])
            [object.window close];
}

- (void)finishLoginWithConnection:(FKConnection *)connection
{
    self.connection = connection;
    [self showMainWindow:self];
    [self.mainWindowItem setTarget:self];
    [self.dockMainWindowItem setTarget:self];
    [self.mainWindowItem setAction:@selector(showMainWindow:)];
    [self.dockMainWindowItem setAction:@selector(showMainWindow:)];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return !self.connection;
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender hasVisibleWindows:(BOOL)flag
{
    if (!flag)
        [self showMainWindow:self];
    return YES;
}

- (void)callUpWindowController:(Class)class sender:(id)sender
{
    NSWindowController *mainWindowController = nil;
    
    for (id object in self.windowControllers)
        if ([object isKindOfClass:class])
        {
            mainWindowController = object;
            break;
        }
    
    if (!mainWindowController)
    {
        mainWindowController = [[class alloc] init];
        [self showWindowController:mainWindowController];
        if ([mainWindowController respondsToSelector:@selector(windowDidBecomeKey:)])
            [mainWindowController performSelector:@selector(windowDidBecomeKey:) withObject:nil];
    }
    else
    {
        [[mainWindowController window] orderFront:sender];
        if ([mainWindowController respondsToSelector:@selector(windowDidBecomeKey:)])
            [mainWindowController performSelector:@selector(windowDidBecomeKey:) withObject:nil];
    }
}

- (void)showMainWindow:(id)sender
{
    [self callUpWindowController:[WFMainWindowController class]
                          sender:sender];
}

- (void)startMainWindow
{
    [self.mainWindowItem setState:NSOnState];
    [self.dockMainWindowItem setState:NSOnState];
}

- (void)stopMainWindow
{
    [self.mainWindowItem setState:NSOffState];
    [self.dockMainWindowItem setState:NSOffState];
}

- (void)delegateSignOut:(id)sender
{
    [self.connection logoutWithError:nil];
    self.connection = nil;
    [self showWindowController:[[WFLoginWindowController alloc] init]];
}

- (void)delegateClearSession:(id)sender
{
    self.connection = nil;
    [self showWindowController:[[WFLoginWindowController alloc] init]];
}

- (void)showAbout:(id)sender
{
    [self callUpWindowController:[WFAboutBoxWindowController class]
                          sender:sender];
}

- (void)showPreferences:(id)sender
{
    [self callUpWindowController:[WFPreferenceWindowController class]
                          sender:self];
}

@end
