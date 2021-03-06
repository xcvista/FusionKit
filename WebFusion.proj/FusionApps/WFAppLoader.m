//
//  WFAppLoader.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-13.
//
//

#import "WFAppLoader.h"

WFAppLoader *appLoader;

NSString *const WFAppLoaderDeadBundle = @"deadBundles";
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
    if (![bundle load])
    {
        return NO;
    }
    if ([[bundle principalClass] isSubclassOfClass:[WFViewController class]])
    {
        WFViewController *object = [[[bundle principalClass] alloc] init];
        [object applicationDidLoad];
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
        NSString *integratedRoot = [localRoot stringByAppendingPathComponent:@"Contents/PlugIns"];
        //NSString *installedRoot = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"PlugIns/%@", [[NSBundle mainBundle] bundleIdentifier]]];
        NSArray *paths = @[integratedRoot]; //, installedRoot];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *deadBundles = [defaults arrayForKey:WFAppLoaderDeadBundle];
        for (NSString *path in deadBundles)
        {
            [fileManager removeItemAtPath:path
                                    error:NULL];
        }
        [defaults removeObjectForKey:WFAppLoaderDeadBundle];
        for (NSString *dest in paths)
        {
            NSArray *paths = [fileManager contentsOfDirectoryAtPath:dest
                                                              error:NULL];
            self.loadedBundles = [NSMutableDictionary dictionaryWithCapacity:[paths count]];
            for (NSString *path in paths)
            {
                NSString *bundleLocation = [dest stringByAppendingPathComponent:path];
                NSBundle *bundle = [NSBundle bundleWithPath:bundleLocation];
                if (bundle)
                {
                    [self loadBundle:bundle];
                }
            }
        }
    }
    return self;
}

- (BOOL)unloadApp:(WFViewController *)app removing:(BOOL)remove
{
    [app applicationWillUnload];
    NSBundle *deadBundle = self.loadedBundles[app];
    [self.loadedBundles removeObjectForKey:app];
    [[NSNotificationCenter defaultCenter] postNotificationName:WFAppLoaderLoadedBundleNotification
                                                        object:self];
    if (remove)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *deadBundles = nil;
        if (!(deadBundles = [defaults arrayForKey:WFAppLoaderDeadBundle]))
        {
            deadBundles = [deadBundles arrayByAddingObject:[deadBundle bundlePath]];
        }
        else
        {
            deadBundles = @[[deadBundle bundlePath]];
        }
        [defaults setObject:deadBundles forKey:WFAppLoaderDeadBundle];
    }
    return YES;
}

- (id)invokeMethod:(NSString *)method onAppWithIdentifier:(NSString *)identifier withArgs:(NSArray *)args
{
    return [[self appWithIdentifier:identifier] executeMethod:method
                                                withArguments:args];
}

- (WFViewController *)appWithIdentifier:(NSString *)identifier
{
    for (WFViewController *vc in [self loadedApps])
    {
        if ([[[vc appBundle] bundleIdentifier] isEqualToString:identifier])
            return vc;
    }
    return nil;
}

@end
