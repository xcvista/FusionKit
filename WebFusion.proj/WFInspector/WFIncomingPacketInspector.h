//
//  WFIncomingPacketInspector.h
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-6.
//
//

#import <Foundation/Foundation.h>

@interface WFIncomingPacketInspector : NSObject <NSTableViewDelegate, NSTableViewDataSource>

@property (weak) IBOutlet NSTableView *tableView;

- (void)incomingPacket:(NSNotification *)aNotification;

@end
