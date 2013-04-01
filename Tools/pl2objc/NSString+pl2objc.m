//
//  NSString+pl2objc.m
//  Tools
//
//  Created by Maxthon Chan on 13-4-1.
//
//

#import "NSString+pl2objc.h"

@implementation NSString (pl2objc)

- (NSString *)sourceRepresentation
{
    return [NSString stringWithFormat:@"@\"%@\"", self];
}

@end
