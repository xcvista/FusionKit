//
//  WFAppLoader.h
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-13.
//
//

#import <Foundation/Foundation.h>
#import <FusionApps/FusionApps.h>

@interface WFAppLoader : NSObject

+ (WFAppLoader *)appLoader;

- (NSArray *)loadedApps;
- (BOOL)loadAppBundle:(NSURL *)bundleURL;
- (BOOL)loadAppBundle:(NSURL *)bundleURL replacingApp:(WFViewController *)app;
- (BOOL)unloadApp:(WFViewController *)app;
- (BOOL)unloadAllApps;

@end
