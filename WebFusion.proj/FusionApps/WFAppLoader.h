//
//  WFAppLoader.h
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-13.
//
//

#import <Foundation/Foundation.h>
#import <FusionApps/FusionApps.h>

extern NSString *const WFAppLoaderLoadedBundleNotification;

@interface WFAppLoader : NSObject

+ (WFAppLoader *)appLoader;

- (NSArray *)loadedApps;
- (BOOL)loadAppBundle:(NSURL *)bundleURL;
- (BOOL)loadAppBundle:(NSURL *)bundleURL replacingApp:(WFViewController *)app;
- (BOOL)unloadApp:(WFViewController *)app removing:(BOOL)remove;
- (BOOL)unloadAllApps;
- (id)invokeMethod:(NSString *)method onAppWithIdentifier:(NSString *)identifier withArgs:(NSArray *)args;
- (WFViewController *)appWithIdentifier:(NSString *)identifier;

@end
