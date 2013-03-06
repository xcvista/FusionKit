//
//  WFOutgoingPacketInspector.h
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-6.
//
//

#import <Foundation/Foundation.h>

@interface WFOutgoingPacketInspector : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *tableView;

- (IBAction)openJSONView:(id)sender;
- (void)outgoingPacket:(NSNotification *)aNotification;

@end
