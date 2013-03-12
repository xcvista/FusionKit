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
#import <FusionApps/FusionApps.h>

@interface WFMainWindowController () <NSWindowDelegate, NSSplitViewDelegate>

@property IBOutlet WFAppPaneController *appPaneController;
@property IBOutlet WFViewController *detailViewController;
@property IBOutlet NSView *rightSplitView;
@property (weak) IBOutlet NSOutlineView *outlineView;

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
    [self.outlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:1]
                  byExtendingSelection:NO];
    [self.window setExcludedFromWindowsMenu:YES];
    [[NSApp delegate] startMainWindow];
}

- (void)windowWillClose:(NSNotification *)notification
{
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
    [self.detailViewController setWindow:self.window];
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
