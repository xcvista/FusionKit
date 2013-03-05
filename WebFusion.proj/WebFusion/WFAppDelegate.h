//
//  WFAppDelegate.h
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-4.
//
//

#import <Cocoa/Cocoa.h>
#import <FusionKit/FusionKit.h>
#import "WFLoginWindowController.h"

@interface WFAppDelegate : NSObject <NSApplicationDelegate>

@property NSMutableArray *windowControllers;
@property FKConnection *connection;

- (void)showWindowController:(NSWindowController *)windowController;
- (void)releaseWindowController:(NSWindowController *)windowController;

- (NSWindowController *)rootWindowController;

@end
