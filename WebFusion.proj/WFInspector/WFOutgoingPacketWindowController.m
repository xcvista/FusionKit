//
//  WFOutgoingPacketWindowController.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-6.
//
//

#import "WFOutgoingPacketWindowController.h"
#import <FusionApps/FusionApps.h>
#import "NSString+JSONSanitizer.h"

@interface WFOutgoingPacketWindowController () <NSWindowDelegate>

@property (weak) IBOutlet NSTextField *targetField;
@property (weak) IBOutlet NSTextField *methodField;
@property (weak) IBOutlet NSTextField *dateField;
@property IBOutlet NSTextView *dataField;

@end

@implementation WFOutgoingPacketWindowController

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
    
    NSURLRequest *request = self.userInfo[@"packet"];
    
    
    NSDate *date = self.userInfo[@"date"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    
    [self.dateField setStringValue:[formatter stringFromDate:date]];
    [self.methodField setStringValue:[request HTTPMethod]];
    [self.targetField setStringValue:[[request URL] absoluteString]];
    NSString *dataString = [[NSString alloc] initWithData:[request HTTPBody]
                                                 encoding:NSUTF8StringEncoding];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [self.dataField setString:[userDefaults boolForKey:WFPrettyPrintJSON] ? [dataString sanitizedString] : dataString];
}

- (void)windowWillClose:(NSNotification *)notification
{
    [[WFApplicationServices applicationServices] releaseWindowController:self];
}

@end
