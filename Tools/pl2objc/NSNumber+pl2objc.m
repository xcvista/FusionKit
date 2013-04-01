//
//  NSNumber+pl2objc.m
//  Tools
//
//  Created by Maxthon Chan on 13-4-1.
//
//

#import "NSNumber+pl2objc.h"

@implementation NSNumber (pl2objc)

- (NSString *)sourceRepresentation
{
    return [NSString stringWithFormat:@"@(%g)", [self.doubleValue]];
}

@end
