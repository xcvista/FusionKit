//
//  WFApplicationServices.h
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-13.
//
//

#import <Foundation/Foundation.h>
#import <FusionKit/FusionKit.h>

@protocol WFApplicationServicesDelegate <NSObject>

- (void)showWindowController:(NSWindowController *)windowController;
- (void)releaseWindowController:(NSWindowController *)windowController;

- (FKConnection *)connection;
- (void)setDefaults:(NSDictionary *)defaults;

@end

@interface WFApplicationServices : NSObject

@property (weak) id<WFApplicationServicesDelegate> delegate;

+ (WFApplicationServices *)applicationServices;

- (void)showWindowController:(NSWindowController *)windowController;
- (void)releaseWindowController:(NSWindowController *)windowController;
- (FKConnection *)connection;
- (void)setDefaults:(NSDictionary *)defaults;

@end
