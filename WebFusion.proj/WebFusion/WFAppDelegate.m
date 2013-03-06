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

@interface WFAppDelegate ()

@property (weak) IBOutlet NSMenuItem *mainWindowItem;
@property (weak) IBOutlet NSMenuItem *packetInspectorItem;

@end

@implementation WFAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![[defaults objectForKey:@"server"] length])
        [defaults setObject:@"https://www.shisoft.net/ajax" forKey:@"server"];
    [defaults synchronize];
    
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

- (NSWindowController *)rootWindowController
{
    return self.windowControllers[0];
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
    [self.mainWindowItem setAction:@selector(showMainWindow:)];
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

- (void)showMainWindow:(id)sender
{
    NSWindowController *mainWindowController = nil;
    
    for (id object in self.windowControllers)
        if ([object isKindOfClass:[WFMainWindowController class]])
        {
            mainWindowController = object;
            break;
        }
    
    if (!mainWindowController)
    {
        mainWindowController = [[WFMainWindowController alloc] init];
        [self showWindowController:mainWindowController];
    }
    else
    {
        [[mainWindowController window] orderFront:sender];
    }
}

- (void)startMainWindow
{
    [self.mainWindowItem setState:NSOnState];
}

- (void)stopMainWindow
{
    [self.mainWindowItem setState:NSOffState];
}

- (void)showPacketInspector:(id)sender
{
    NSWindowController *mainWindowController = nil;
    
    for (id object in self.windowControllers)
        if ([object isKindOfClass:[WFPacketInspectorWindowController class]])
        {
            mainWindowController = object;
            break;
        }
    
    if (!mainWindowController)
    {
        mainWindowController = [[WFPacketInspectorWindowController alloc] init];
        [self showWindowController:mainWindowController];
    }
    else
    {
        [[mainWindowController window] orderFront:sender];
    }
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

- (void)showAbout:(id)sender
{
    NSWindowController *mainWindowController = nil;
    
    for (id object in self.windowControllers)
        if ([object isKindOfClass:[WFAboutBoxWindowController class]])
        {
            mainWindowController = object;
            break;
        }
    
    if (!mainWindowController)
    {
        mainWindowController = [[WFAboutBoxWindowController alloc] init];
        [self showWindowController:mainWindowController];
    }
    else
    {
        [[mainWindowController window] orderFront:sender];
    }
}

@end
