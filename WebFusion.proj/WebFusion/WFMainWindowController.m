//
//  WFMainWindowController.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-5.
//
//

#import "WFMainWindowController.h"
#import "WFAppPaneController.h"

@interface WFMainWindowController () <NSWindowDelegate, NSSplitViewDelegate>

@property IBOutlet WFAppPaneController *appPaneController;
@property IBOutlet NSViewController *detailViewController;
@property IBOutlet NSView *rightSplitView;
@property (weak) IBOutlet NSOutlineView *outlineView;
@property NSString *currentApp;

@property NSDictionary *apps;

@end

@implementation WFMainWindowController

- (id)init
{
    return [self initWithWindowNibName:NSStringFromClass([self class])];
}

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
}

- (void)loadAppWithName:(NSString *)name
{
    if (!self.apps)
    {
        self.apps = @{@"News": @"WFNewsViewController"};
    }
    NSString *className = self.apps[name];
    if (className)
    {
        if ([self.currentApp isEqualToString:className])
            return;
        self.currentApp = className;
        self.detailViewController = [[NSClassFromString(className) alloc] initWithNibName:className bundle:[NSBundle mainBundle]];
        [[self.detailViewController view] setFrame:self.rightSplitView.bounds];
        [[self.detailViewController view] setAutoresizingMask:18];
        [self.rightSplitView setSubviews:@[[self.detailViewController view]]];
    }
    else
    {
        NSLog(@"Unrecognized class name %@ requested.", name);
    }
}

- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)view
{
    if ([[splitView subviews] indexOfObject:view] == 0)
        return NO;
    return YES;
}

@end
