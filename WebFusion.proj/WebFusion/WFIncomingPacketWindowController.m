//
//  WFIncomingPacketWindowController.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-6.
//
//

#import "WFIncomingPacketWindowController.h"
#import "WFOutgoingPacketWindowController.h"
#import "WFAppDelegate.h"
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
    
    NSHTTPURLResponse *response = self.userInfo[@"response"];
    NSDate *date = self.userInfo[@"date"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    
    [self.dateField setStringValue:[formatter stringFromDate:date]];
    [self.methodField setIntegerValue:[response statusCode]];
    [self.targetField setStringValue:[[response URL] absoluteString]];
    [self.durationField setStringValue:[NSString stringWithFormat:NSLocalizedString(@"%.1f seconds", @""), [date timeIntervalSinceDate:self.userInfo[@"requestDate"]]]];
    [self.dataField setString:[[[NSString alloc] initWithData:self.userInfo[@"packet"]
                                                     encoding:NSUTF8StringEncoding] sanitizedString]];
}

- (void)revealRequest:(id)sender
{
    WFOutgoingPacketWindowController *outVC = [[WFOutgoingPacketWindowController alloc] init];
    outVC.userInfo = @{@"packet": self.userInfo[@"request"], @"date": self.userInfo[@"requestDate"]};
    [[NSApp delegate] showWindowController:outVC];
}

@end
