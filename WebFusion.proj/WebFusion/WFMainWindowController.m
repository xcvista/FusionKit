//
//  WFMainWindowController.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-5.
//
//

#import "WFMainWindowController.h"
#import "WFAppPaneController.h"
#import "WFAppDelegate.h"
#import <FusionApps/FusionApps.h>
#import "WFNewsViewController.h"

@interface WFMainWindowController () <NSWindowDelegate, NSSplitViewDelegate>

@property IBOutlet WFAppPaneController *appPaneController;
@property IBOutlet WFViewController *detailViewController;
@property IBOutlet NSView *rightSplitView;
@property (weak) IBOutlet NSOutlineView *outlineView;
@property BOOL polling;

- (IBAction)signOut:(id)sender;
- (IBAction)clearSession:(id)sender;

- (IBAction)tweet:(id)sender;
- (IBAction)blog:(id)sender;
- (IBAction)image:(id)sender;
- (IBAction)link:(id)sender;

@end

@implementation WFMainWindowController

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
    [self.appPaneController configureView];
    [self.window setExcludedFromWindowsMenu:YES];
    [[NSApp delegate] startMainWindow];
    for (WFViewController *app in [[WFAppLoader appLoader] loadedApps])
    {
        app.window = self.window;
    }
}

- (void)windowDidBecomeKey:(NSNotification *)notification
{
    if (!self.polling)
    {
        self.polling = YES;
        [self performSelectorInBackground:@selector(poll:) withObject:nil];
    }
}

- (void)poll:(id)object
{
    @autoreleasepool
    {
        while (self.polling)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSTimeInterval pollTime = [defaults doubleForKey:WFPullFrequency];
            WFAppLoader *appLoader = [WFAppLoader appLoader];
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[[appLoader loadedApps] count]];
            for (WFViewController *app in [appLoader loadedApps])
            {
                NSDictionary *pollItems = [app registerPoll];
                if (pollItems)
                    [dictionary addEntriesFromDictionary:pollItems];
            }
            FKConnection *connection = [(WFAppDelegate *)[NSApp delegate] connection];
            NSDictionary *pollResult = [connection poll:dictionary
                                               interval:0.5
                                                   wait:pollTime
                                                  error:NULL];
            if (pollResult)
            {
                NSMutableDictionary *rdictionary = [NSMutableDictionary dictionary];
                [rdictionary addEntriesFromDictionary:pollResult];
                rdictionary[@"request"] = dictionary;
                [[NSNotificationCenter defaultCenter] postNotificationName:WFPollNotification
                                                                    object:self
                                                                  userInfo:rdictionary];
            }
        }
    }
}

- (void)windowWillClose:(NSNotification *)notification
{
    self.polling = NO;
    [[NSApp delegate] stopMainWindow];
}

- (void)reload:(id)sender
{
    if ([self.detailViewController respondsToSelector:@selector(reload:)])
        [self.detailViewController performSelector:@selector(reload:) withObject:sender];
}

- (void)loadAppWithName:(WFViewController *)viewController
{
    if (self.detailViewController == viewController)
        return;
    [self.detailViewController viewWillDisappear];
    self.detailViewController = viewController;
    [[self.detailViewController view] setFrame:self.rightSplitView.bounds];
    [[self.detailViewController view] setAutoresizingMask:18];
    [self.rightSplitView setSubviews:@[[self.detailViewController view]]];
    [self.detailViewController viewWillAppear];
    [self.window setTitle:[NSString stringWithFormat:NSLocalizedString(@"WebFusion - %@%@", @""), [viewController longAppName], [[NSApp delegate] override] ? NSLocalizedString(@" (Override)", @"") : @""]];
}

- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)view
{
    if ([[splitView subviews] indexOfObject:view] == 0)
        return NO;
    return YES;
}

- (void)signOut:(id)sender
{
    [self.window close];
    [[NSApp delegate] delegateSignOut:sender];
}

- (void)clearSession:(id)sender
{
    [self.window close];
    [[NSApp delegate] delegateClearSession:sender];
}

- (void)blog:(id)sender
{
    
}

- (void)tweet:(id)sender
{
    
}

- (void)link:(id)sender
{
    
}

- (void)image:(id)sender
{
    
}

@end
