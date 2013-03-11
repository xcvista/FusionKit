//
//  WFPacketInspectorWindowController.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-6.
//
//

#import "WFPacketInspectorWindowController.h"
#import "WFAppDelegate.h"
#import "WFOutgoingPacketInspector.h"
#import "WFIncomingPacketInspector.h"
#import "WFOutgoingPacketWindowController.h"
#import <FusionKit/FusionKit.h>

@interface WFPacketInspectorWindowController () <NSWindowDelegate>

@property IBOutlet WFOutgoingPacketInspector *outgoingInspector;
@property IBOutlet WFIncomingPacketInspector *incomingInspector;

@end

@implementation WFPacketInspectorWindowController

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
    [[NSApp delegate] startPacketInspector];
    [self.window setExcludedFromWindowsMenu:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self.outgoingInspector
                                             selector:@selector(outgoingPacket:)
                                                 name:FKWillUploadPackageNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self.incomingInspector
                                             selector:@selector(incomingPacket:)
                                                 name:FKDidReceivePackageNotification
                                               object:nil];
}

- (void)windowWillClose:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.outgoingInspector];
    [[NSNotificationCenter defaultCenter] removeObserver:self.incomingInspector];
    [[NSApp delegate] closeAllWindowControllerWithClass:[WFOutgoingPacketWindowController class]];
    [[NSApp delegate] stopPacketInspector];
    [[NSApp delegate] releaseWindowController:self];
}

@end
