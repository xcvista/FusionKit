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
- (NSString *)longAppName;
- (NSBundle *)appBundle;
- (NSImage *)appIcon;
- (NSString *)appCategory;
- (NSDictionary *)appVersion;

- (NSComparisonResult)compare:(WFViewController *)other;

- (void)applicationDidLoad;
- (void)viewWillAppear;
- (void)viewWillDisappear;
- (void)applicationWillUnload;

- (void)pull;

@end
