//
//  FKJSONKeyedUnarchiver.h
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-4.
//
//

#import <Foundation/Foundation.h>

@interface FKJSONKeyedUnarchiver :
#if (TARGET_OS_EMBEDDED || TARGET_OS_IPHONE)
NSCoder
#else
NSUnarchiver
#endif

#if (TARGET_OS_EMBEDDED || TARGET_OS_IPHONE)
+ (id)unarchiveObjectWithData:(NSData *)data;
#endif

- (id)decodeObjectForKey:(NSString *)key class:(Class)class;
+ (id)unarchiveObjectWithData:(NSData *)data class:(Class)class;

@end
