//
//  WFInfrastructure.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-13.
//
//

#import "WFInfrastructure.h"

@interface WFInfrastructure ()

@end

@implementation WFInfrastructure

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (BOOL)showInSidebar
{
    return NO;
}

- (BOOL)canUnload
{
    return NO;
}

- (void)pollDidFinish:(NSNotification *)aNotification
{
    NSNumber *noService = [aNotification userInfo][@"svrEmpty"];
    if ([noService boolValue])
    {
        NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedStringFromTableInBundle(@"Nowhere to go.", @"error", [self appBundle], @"")
                                         defaultButton:NSLocalizedStringFromTableInBundle(@"OK", @"ui", [self appBundle], @"")
                                       alternateButton:nil
                                           otherButton:nil
                             informativeTextWithFormat:NSLocalizedStringFromTableInBundle(@"You can associate services in Preferences.", @"error", [self appBundle], @"")];
        [alert setAlertStyle:NSCriticalAlertStyle];
        [alert beginSheetModalForWindow:self.window
                          modalDelegate:nil
                         didEndSelector:nil
                            contextInfo:nil];
    }
}

- (id)executeMethod:(NSString *)method withArguments:(NSArray *)arguments
{
    if ([method isEqualToString:@"WFLocalizedGateway"])
    {
        return NSLocalizedStringFromTableInBundle(arguments[0], @"services", [self appBundle], @"");
    }
    return nil;
}

@end
