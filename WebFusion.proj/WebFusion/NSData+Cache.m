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
    UIImageCacheFolderName = [defaults objectForKey:WFCacheRoot];
    if (!UIImageCacheFolderName)
        [self setCacheFolderName:NSDataCacheDefaultFolderName];
    return UIImageCacheFolderName;
}

+ (void)setCacheFolderName:(NSString *)folderName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UIImageCacheFolderName = folderName;
    [defaults setValue:UIImageCacheFolderName forKey:WFCacheRoot];
    [defaults synchronize];
}

+ (void)clearCache
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cacheFolder = [NSString stringWithFormat:@"%@/Library/Caches/%@", NSHomeDirectory(), [self cacheFolderName]];
    [fileManager removeItemAtPath:cacheFolder error:NULL];
}

+ (NSData *)cachedDataAtURL:(NSURL *)location
{
    return [[self alloc] initWithCachedDataAtURL:location];
}

- (id)initWithCachedDataAtURL:(NSURL *)location
{
    // mkdir -p ~/Library/Caches/UIImageCache
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cacheFolder = [NSString stringWithFormat:@"%@/Library/Caches/%@", NSHomeDirectory(), [[self class] cacheFolderName]];
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
