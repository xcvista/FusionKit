//
//  NSDate+pl2objc.m
//  Tools
//
//  Created by Maxthon Chan on 13-4-1.
//
//

#import "NSDate+pl2objc.h"

@implementation NSDate (pl2objc)

- (NSString *)sourceRepresentation
{
    return [NSString stringWithFormat:@"[NSDate dateWithTimeIntervalSince1970:%g]", [self timeIntervalSince1970]];
}

@end
