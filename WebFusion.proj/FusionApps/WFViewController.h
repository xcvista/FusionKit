//
//  WFViewController.h
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-12.
//
//

#import <Cocoa/Cocoa.h>

extern NSString *const WFPollNotification;

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
- (NSDictionary *)registerPoll;
- (void)pollDidFinish:(NSNotification *)aNotification;
- (BOOL)showInSidebar;
- (BOOL)isActive;
- (BOOL)hasPreferences;
- (void)showPreferences;
- (id)executeMethod:(NSString *)method withArguments:(NSArray *)arguments;

- (NSComparisonResult)compare:(WFViewController *)other;

- (void)applicationDidLoad;
- (void)userDidLogin;
- (void)viewWillAppear;
- (void)viewWillDisappear;
- (void)applicationWillUnload;

- (void)pull;

@end
