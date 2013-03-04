//
//  WFAppDelegate.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-4.
//
//

#import "WFAppDelegate.h"

@implementation WFAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    // Show the initial window.
    self.rootWindowController = [[WFLoginWindowController alloc] init];
    [self.rootWindowController showWindow:self];
}

@end
