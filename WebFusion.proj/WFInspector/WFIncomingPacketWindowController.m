//
//  WFIncomingPacketWindowController.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-6.
//
//

#import "WFIncomingPacketWindowController.h"
#import "WFOutgoingPacketWindowController.h"
#import <FusionApps/FusionApps.h>
#import "NSString+JSONSanitizer.h"

@interface WFIncomingPacketWindowController ()

@property (weak) IBOutlet NSTextField *targetField;
@property (weak) IBOutlet NSTextField *methodField;
@property (weak) IBOutlet NSTextField *dateField;
@property (weak) IBOutlet NSTextField *durationField;
@property IBOutlet NSTextView *dataField;

- (IBAction)revealRequest:(id)sender;

@end

@implementation WFIncomingPacketWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSHTTPURLResponse *response = self.userInfo[@"response"];
    NSDate *date = self.userInfo[@"date"];
    NSTimeInterval timeout = [date timeIntervalSinceDate:self.userInfo[@"requestDate"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    
    [self.dateField setStringValue:[formatter stringFromDate:date]];
    [self.methodField setIntegerValue:[response statusCode]];
    [self.targetField setStringValue:[[response URL] absoluteString]];
    [self.durationField setStringValue:[NSString stringWithFormat:NSLocalizedString(@"%.1f seconds%@", @""), timeout, (timeout > [userDefaults doubleForKey:WFStallTimeout]) ? NSLocalizedString(@", Stalled", @"") : @""]];
    NSString *dataString = [[NSString alloc] initWithData:self.userInfo[@"packet"]
                                                 encoding:NSUTF8StringEncoding];
    [self.dataField setString:[userDefaults boolForKey:@"prettyPrintJSON"] ? [dataString sanitizedString] : dataString];
}

- (void)revealRequest:(id)sender
{
    WFOutgoingPacketWindowController *outVC = [[WFOutgoingPacketWindowController alloc] init];
    outVC.userInfo = @{@"packet": self.userInfo[@"request"], @"date": self.userInfo[@"requestDate"]};
    [[WFApplicationServices applicationServices] showWindowController:outVC];
}

@end
