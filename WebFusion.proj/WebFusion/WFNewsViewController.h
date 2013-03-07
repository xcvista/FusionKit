//
//  WFNewsViewController.h
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-5.
//
//

#import <Cocoa/Cocoa.h>
#import "SidebarTableCellView.h"

@interface WFNewsViewController : NSViewController

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet SidebarTableCellView *sidebarItem;

- (void)viewWillAppear;
- (void)viewWillDisappear;

@end
