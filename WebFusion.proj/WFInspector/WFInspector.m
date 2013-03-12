//
//  WFInspector.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-13.
//
//

#import "WFInspector.h"
#import "WFOutgoingPacketInspector.h"
#import "WFIncomingPacketInspector.h"
#import "WFOutgoingPacketWindowController.h"

@interface WFInspector ()

@property IBOutlet WFOutgoingPacketInspector *outgoingInspector;
@property IBOutlet WFIncomingPacketInspector *incomingInspector;
@property IBOutlet NSTableView *incomingTable;
@property IBOutlet NSTableView *outgoingTable;

- (IBAction)reload:(id)sender;

@end

@implementation WFInspector

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self.sidebarItem.button setTarget:self];
    [self.sidebarItem.button setAction:@selector(reload:)];
}

- (NSString *)appName
{
    return @"Inspector";
}

- (NSString *)appCategory
{
    return @"Developer";
}

- (void)applicatinDidLoad
{
    [self view];
    [[NSNotificationCenter defaultCenter] addObserver:self.outgoingInspector
                                             selector:@selector(outgoingPacket:)
                                                 name:FKWillUploadPackageNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self.incomingInspector
                                             selector:@selector(incomingPacket:)
                                                 name:FKDidReceivePackageNotification
                                               object:nil];
}

- (void)reload:(id)sender
{
    [self.incomingTable reloadData];
    [self.outgoingTable reloadData];
}

- (void)viewWillAppear
{
    [self.sidebarItem setBadgeAsRefreshButton];
    
    [self reload:self];
}

- (void)viewWillDisappear
{
    [self.sidebarItem setBadge:nil];
}

- (void)applicationWillUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.outgoingInspector];
    [[NSNotificationCenter defaultCenter] removeObserver:self.incomingInspector];
}

@end
