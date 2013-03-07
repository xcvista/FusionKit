//
//  WFAppDelegate.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-4.
//
//

#import "WFAppDelegate.h"
#import "WFMainWindowController.h"
#import "WFPacketInspectorWindowController.h"
#import "WFAboutBoxWindowController.h"
#import "WFPreferenceWindowController.h"

@interface WFAppDelegate ()

@property (weak) IBOutlet NSMenuItem *mainWindowItem;
@property (weak) IBOutlet NSMenuItem *dockMainWindowItem;
@property (weak) IBOutlet NSMenuItem *packetInspectorItem;

@end

@implementation WFAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSDictionary *defaults = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"defaults" withExtension:@"plist"]];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:defaults];
    [userDefaults synchronize];
    
    // Show the initial window.
    self.windowControllers = [NSMutableArray array];
    [self showWindowController:[[WFLoginWindowController alloc] init]];
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
    }
    else
    {
        [[mainWindowController window] orderFront:sender];
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

- (void)showPacketInspector:(id)sender
{
    [self callUpWindowController:[WFPacketInspectorWindowController class]
                          sender:sender];
}

- (void)startPacketInspector
{
    [self.packetInspectorItem setState:NSOnState];
}

- (void)stopPacketInspector
{
    [self.packetInspectorItem setState:NSOffState];
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
