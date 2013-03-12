//
//  WFNewsViewController.h
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-5.
//
//

#import <Cocoa/Cocoa.h>
#import <FusionApps/FusionApps.h>

@interface WFNewsViewController : WFViewController

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet SidebarTableCellView *sidebarItem;

- (void)viewWillAppear;
- (void)viewWillDisappear;

@end
