//
//  NSData+Cache.h
//  Pearl
//
//  Created by Maxthon Chan on 13-2-17.
//  Copyright (c) 2013年 Maxthon Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const NSDataCacheDefaultFolderName = @"NSDataCache";

@interface NSData (Cache)

+ (void)clearCache;
+ (NSString *)cacheFolderName;
+ (void)setCacheFolderName:(NSString *)folderName;
+ (NSString *)cacheFolderLocation;

+ (NSData *)cachedDataAtURL:(NSURL *)location;
+ (NSURL *)cachedURLForURL:(NSURL *)location buildCache:(BOOL)buildCache;
- (id)initWithCachedDataAtURL:(NSURL *)location;

@end
