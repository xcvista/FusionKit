//
//  NSData+Cache.m
//  Pearl
//
//  Created by Maxthon Chan on 13-2-17.
//  Copyright (c) 2013年 Maxthon Chan. All rights reserved.
//

#import "NSData+Cache.h"
#import "WFPreferenceKeys.h"

NSString *UIImageCacheFolderName;

@implementation NSData (Cache)

+ (NSString *)cacheFolderName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:WFCacheRoot];
}

+ (void)setCacheFolderName:(NSString *)folderName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:folderName forKey:WFCacheRoot];
    [defaults synchronize];
}

+ (void)clearCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *folders = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheFolder = [NSString stringWithFormat:@"%@/%@/%@", [folders lastObject], [[NSBundle mainBundle] bundleIdentifier], [[self class] cacheFolderName]];
    [fileManager removeItemAtPath:cacheFolder error:NULL];
}

+ (NSData *)cachedDataAtURL:(NSURL *)location
{
    return [[self alloc] initWithCachedDataAtURL:location];
}

+ (NSURL *)cachedURLForURL:(NSURL *)location buildCache:(BOOL)buildCache
{
    // mkdir -p ~/Library/Caches/UIImageCache
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *folders = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheFolder = [NSString stringWithFormat:@"%@/%@/%@", [folders lastObject], [[NSBundle mainBundle] bundleIdentifier], [[self class] cacheFolderName]];
    [fileManager createDirectoryAtPath:cacheFolder
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    
    if ([[location scheme] compare:@"file" options:NSCaseInsensitiveSearch] != NSOrderedSame)
    {
        NSString *storageLocation = [NSString stringWithFormat:@"%@/%@/%@/%@",
                                     cacheFolder,
                                     [location scheme],
                                     [location host],
                                     [[location path] substringFromIndex:1]];
        NSData *imageData = nil;
        NSURL *locationURL = [NSURL URLWithString:[NSString stringWithFormat:@"file://localhost%@", storageLocation]];
        if (!(imageData = [NSData dataWithContentsOfFile:storageLocation]))
        {
            if (buildCache)
            {
                [fileManager createDirectoryAtPath:[storageLocation stringByDeletingLastPathComponent]
                       withIntermediateDirectories:YES
                                        attributes:nil
                                             error:NULL];
                imageData = [NSData dataWithContentsOfURL:location];
                [imageData writeToFile:storageLocation
                            atomically:YES];
                return locationURL;
            }
            else
                return nil;
        }
        else
            return locationURL;
    }
    else
        return location;
    return nil;
}

- (id)initWithCachedDataAtURL:(NSURL *)location
{
    // mkdir -p ~/Library/Caches/UIImageCache
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *folders = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheFolder = [NSString stringWithFormat:@"%@/%@/%@", [folders lastObject], [[NSBundle mainBundle] bundleIdentifier], [[self class] cacheFolderName]];
    [fileManager createDirectoryAtPath:cacheFolder
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:NULL];
    
    NSData *imageData;
    if ([[location scheme] compare:@"file" options:NSCaseInsensitiveSearch] != NSOrderedSame)
    {
        NSString *storageLocation = [NSString stringWithFormat:@"%@/%@/%@/%@",
                                     cacheFolder,
                                     [location scheme],
                                     [location host],
                                     [[location path] substringFromIndex:1]];
        if (!(imageData = [NSData dataWithContentsOfFile:storageLocation]))
        {
            [fileManager createDirectoryAtPath:[storageLocation stringByDeletingLastPathComponent]
                   withIntermediateDirectories:YES
                                    attributes:nil
                                         error:NULL];
            imageData = [NSData dataWithContentsOfURL:location];
            [imageData writeToFile:storageLocation
                        atomically:YES];
        }
    }
    else
        imageData = [NSData dataWithContentsOfURL:location];
    
    return [self initWithData:imageData];
}

@end
