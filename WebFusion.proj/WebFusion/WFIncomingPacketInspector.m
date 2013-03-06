//
//  WFIncomingPacketInspector.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-6.
//
//

#import "WFIncomingPacketInspector.h"
#import "WFAppDelegate.h"
#import "WFIncomingPacketWindowController.h"

@interface WFIncomingPacketInspector ()

@property NSMutableArray *incomingPackets;

@end

@implementation WFIncomingPacketInspector 

- (void)incomingPacket:(NSNotification *)aNotification
{
    if (!self.incomingPackets)
        self.incomingPackets = [NSMutableArray array];
    [self.incomingPackets addObject:[aNotification userInfo]];
    [self.tableView reloadData];
    [self.tableView scrollToEndOfDocument:self];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.incomingPackets count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return self.incomingPackets[row];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSUInteger colNumber = [[tableView tableColumns] indexOfObject:tableColumn];
    NSHTTPURLResponse *response = self.incomingPackets[row][@"response"];
    
    switch (colNumber)
    {
        case 0:
        {
            NSTableCellView *tableCell = [tableView makeViewWithIdentifier:@"Date"
                                                                     owner:self];
            NSDate *date = self.incomingPackets[row][@"date"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterNoStyle];
            [formatter setTimeStyle:NSDateFormatterMediumStyle];
            
            [[tableCell textField] setStringValue:[formatter stringFromDate:date]];
            
            return tableCell;
        }
        case 1:
        {
            NSTableCellView *tableCell = [tableView makeViewWithIdentifier:@"Status"
                                                                     owner:self];
            [[tableCell textField] setIntegerValue:[response statusCode]];
            return tableCell;
        }
        case 2:
        {
            NSTableCellView *tableCell = [tableView makeViewWithIdentifier:@"Target"
                                                                     owner:self];
            [[tableCell textField] setStringValue:[[response URL] lastPathComponent]];
            return tableCell;
        }
        case 3:
        {
            NSButton *button = [tableView makeViewWithIdentifier:@"Data"
                                                           owner:self];
            [button setTag:row];
            return button;
        }
        default:
            return nil;
    }
}

- (IBAction)openJSONView:(id)sender
{
    NSDictionary *userData = self.incomingPackets[[sender tag]];
    WFIncomingPacketWindowController *outWC = [[WFIncomingPacketWindowController alloc] init];
    outWC.userInfo = userData;
    [[NSApp delegate] showWindowController:outWC];
}

@end
