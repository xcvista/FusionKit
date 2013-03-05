//
//  WFNewsInfoWindowController.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-5.
//
//

#import "WFNewsInfoWindowController.h"
#import "WFAppDelegate.h"

@interface WFNewsInfoWindowController () <NSWindowDelegate>

@end

@implementation WFNewsInfoWindowController

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
}

- (void)windowWillClose:(NSNotification *)notification
{
    WFAppDelegate *delegate = [NSApp delegate];
    [delegate releaseWindowController:self];
}

@end
