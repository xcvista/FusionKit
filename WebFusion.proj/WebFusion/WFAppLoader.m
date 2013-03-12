//
//  WFAppLoader.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-13.
//
//

#import "WFAppLoader.h"

WFAppLoader *appLoader;

NSString *const WFAppLoaderLoadedBundleNotification = @"tk.maxius.webfusion.loadbundle";

@interface WFAppLoader ()

@property NSMutableDictionary *loadedBundles;

@end

@implementation WFAppLoader

+ (WFAppLoader *)appLoader
{
    if (!appLoader)
        appLoader = [[WFAppLoader alloc] init];
    return appLoader;
}

- (BOOL)loadBundle:(NSBundle *)bundle
{
    if (!bundle)
        return NO;
    [bundle load];
    if ([[bundle principalClass] isSubclassOfClass:[WFViewController class]])
    {
        WFViewController *object = [[[bundle principalClass] alloc] init];
        [object applicatinDidLoad];
        self.loadedBundles[(id<NSCopying>)object] = bundle;
        return YES;
    }
    else
    {
        //[bundle unload]; // Bad bundles are not used.
        return NO;
    }
}

- (BOOL)loadAppBundle:(NSURL *)bundleURL
{
    if ([self loadBundle:[NSBundle bundleWithURL:bundleURL]])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:WFAppLoaderLoadedBundleNotification
                                                            object:self];
        return YES;
    }
    return NO;
}

- (BOOL)unloadAllApps
{
    NSArray *apps = [self.loadedApps copy];
    for (WFViewController *app in apps)
    {
        [app applicationWillUnload];
        [self.loadedBundles removeObjectForKey:app];
    }
    return YES;
}

- (NSArray *)loadedApps
{
    return [self.loadedBundles allKeys];
}

- (id)init
{
    if (self = [super init])
    {
        NSString *localRoot = [[NSBundle mainBundle] bundlePath];
        NSString *dest = [localRoot stringByAppendingPathComponent:@"Contents/PlugIns"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = [fileManager contentsOfDirectoryAtPath:dest
                                                          error:NULL];
        self.loadedBundles = [NSMutableDictionary dictionaryWithCapacity:[paths count]];
        for (NSString *path in paths)
        {
            NSString *bundleLocation = [dest stringByAppendingPathComponent:path];
            NSBundle *bundle = [NSBundle bundleWithPath:bundleLocation];
            if (bundle)
            {
                NSLog(@"Loading bundle %@", bundle);
                [self loadBundle:bundle];
            }
        }
    }
    return self;
}

@end
