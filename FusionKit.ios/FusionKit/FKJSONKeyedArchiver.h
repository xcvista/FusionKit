//
//  FKJSONKeyedArchiver.h
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-2-22.
//
//

#import <Foundation/Foundation.h>

@interface FKJSONKeyedArchiver : 
#if (TARGET_OS_EMBEDDED || TARGET_OS_IPHONE)
NSCoder
#else
NSArchiver
#endif

#if (TARGET_OS_EMBEDDED || TARGET_OS_IPHONE)
+ (NSData *)archivedDataWithRootObject:(id)rootObject;
#endif

@end
