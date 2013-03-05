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

+ (id)unarchiveObjectWithData:(NSData *)data;

- (id)decodeObjectForKey:(NSString *)key;
- (id)decodeObjectOfClass:(Class)aClass forKey:(NSString *)key;
+ (id)unarchiveObjectWithData:(NSData *)data class:(Class)class;

@end
