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
}

- (void)windowWillClose:(NSNotification *)notification
{
    [[NSApp delegate] releaseWindowController:self];
}

@end
