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
#import "SidebarTableCellView.h"
#import "WFNewsViewController.h"

@interface WFMainWindowController () <NSWindowDelegate, NSSplitViewDelegate>

@property IBOutlet WFAppPaneController *appPaneController;
@property IBOutlet NSViewController *detailViewController;
@property IBOutlet NSView *rightSplitView;
@property (weak) IBOutlet NSOutlineView *outlineView;
@property NSString *currentApp;

@property NSDictionary *apps;

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
    if ([[NSApp delegate] override])
    {
        [self.window setTitle:NSLocalizedString(@"WebFusion (Override)", @"")];
    }
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

- (void)loadAppWithName:(NSString *)name
{
    if (!self.apps)
    {
        self.apps = @{@"News": @"WFNewsViewController"};
    }
    NSString *className = self.apps[name];
    if ([self.detailViewController respondsToSelector:@selector(viewWillDisappear)])
        [self.detailViewController performSelector:@selector(viewWillDisappear)];
    if (![self.currentApp isEqualToString:className])
    {
        self.currentApp = className;
        if (className)
        {
            if (![self.detailViewController isKindOfClass:NSClassFromString(className)])
            {
                self.detailViewController = [[NSClassFromString(className) alloc] initWithNibName:className
                                                                                           bundle:[NSBundle mainBundle]];
                if ([self.detailViewController respondsToSelector:@selector(setWindow:)])
                    [self.detailViewController performSelector:@selector(setWindow:)
                                                    withObject:self.window];
                if ([self.detailViewController respondsToSelector:@selector(setSidebarItem:)])
                    [self.detailViewController performSelector:@selector(setSidebarItem:)
                                                    withObject:[self.outlineView viewAtColumn:0
                                                                                          row:[self.outlineView rowForItem:name]
                                                                              makeIfNecessary:NO]];
                [[self.detailViewController view] setFrame:self.rightSplitView.bounds];
                [[self.detailViewController view] setAutoresizingMask:18];
                [self.rightSplitView setSubviews:@[[self.detailViewController view]]];
            }
            if ([self.detailViewController respondsToSelector:@selector(viewWillAppear)])
                [self.detailViewController performSelector:@selector(viewWillAppear)];
        }
        else
        {
            NSLog(@"Unrecognized class name %@ requested.", name);
        }
    }
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
