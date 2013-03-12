//
//  WFApplicationServices.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-13.
//
//

#import "WFApplicationServices.h"

WFApplicationServices *applicationServices;

@implementation WFApplicationServices

+ (WFApplicationServices *)applicationServices
{
    if (!applicationServices)
        applicationServices = [[WFApplicationServices alloc] init];
    return applicationServices;
}

- (void)showWindowController:(NSWindowController *)windowController
{
    [self.delegate showWindowController:windowController];
}

- (void)releaseWindowController:(NSWindowController *)windowController
{
    [self.delegate releaseWindowController:windowController];
}

- (FKConnection *)connection
{
    return [self.delegate connection];
}

@end
