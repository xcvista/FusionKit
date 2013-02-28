//
//  FKJSONKeyedArchiver.h
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-2-22.
//
//

#import <Cocoa/Cocoa.h>

@interface FKJSONKeyedArchiver : NSCoder

+ (NSData *)JSONDataForObject:(id<NSCoding>)object;

@end
