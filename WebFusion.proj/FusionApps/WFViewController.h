//
//  WFViewController.h
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-12.
//
//

#import <Cocoa/Cocoa.h>

@class SidebarTableCellView;

@interface WFViewController : NSViewController

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet SidebarTableCellView *sidebarItem;

- (NSString *)appName;
- (NSImage *)appIcon;
- (NSString *)appCategory;

- (NSComparisonResult)compare:(WFViewController *)other;

- (void)applicatinDidLoad;
- (void)viewWillAppear;
- (void)viewWillDisappear;
- (void)applicationWillUnload;

- (void)pull;

@end
