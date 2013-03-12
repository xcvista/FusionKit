//
//  WFOutgoingPacketInspector.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-6.
//
//

#import "WFOutgoingPacketInspector.h"
#import <FusionApps/FusionApps.h>
#import "WFOutgoingPacketWindowController.h"

@interface WFOutgoingPacketInspector ()

@property NSMutableArray *outgoingPackets;

@end

@implementation WFOutgoingPacketInspector

- (void)outgoingPacket:(NSNotification *)aNotification
{
    if (!self.outgoingPackets)
        self.outgoingPackets = [NSMutableArray array];
    [self.outgoingPackets addObject:[aNotification userInfo]];
    [self.tableView reloadData];
    [self.tableView scrollToEndOfDocument:self];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [self.outgoingPackets count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return self.outgoingPackets[row];
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSUInteger colNumber = [[tableView tableColumns] indexOfObject:tableColumn];
    NSURLRequest *request = self.outgoingPackets[row][@"packet"];
    
    switch (colNumber)
    {
        case 0:
        {
            NSTableCellView *tableCell = [tableView makeViewWithIdentifier:@"Date"
                                                                     owner:self];
            NSDate *date = self.outgoingPackets[row][@"date"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterNoStyle];
            [formatter setTimeStyle:NSDateFormatterMediumStyle];
            
            [[tableCell textField] setStringValue:[formatter stringFromDate:date]];
            
            return tableCell;
        }
        case 1:
        {
            NSTableCellView *tableCell = [tableView makeViewWithIdentifier:@"Method"
                                                                     owner:self];
            [[tableCell textField] setStringValue:[request HTTPMethod]];
            return tableCell;
        }
        case 2:
        {
            NSTableCellView *tableCell = [tableView makeViewWithIdentifier:@"Target"
                                                                     owner:self];
            [[tableCell textField] setStringValue:[[request URL] lastPathComponent]];
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
    NSDictionary *userData = self.outgoingPackets[[sender tag]];
    WFOutgoingPacketWindowController *outWC = [[WFOutgoingPacketWindowController alloc] init];
    outWC.userInfo = userData;
    [[WFApplicationServices applicationServices] showWindowController:outWC];
}

@end
