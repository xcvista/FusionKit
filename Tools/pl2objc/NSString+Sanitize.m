//
//  NSString+Sanitize.m
//  Tools
//
//  Created by Maxthon Chan on 13-4-1.
//
//

#import "NSString+Sanitize.h"

@implementation NSString (Sanitize)

- (NSString *)symbolizedString
{
    NSMutableString *mutableString = [NSMutableString stringWithCapacity:[self length] + 1];
    
    NSCharacterSet *validInitial = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_"];
    NSCharacterSet *numerical = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSUInteger i = 0; i < [self length]; i++)
    {
        unichar ch = [self characterAtIndex:i];
        if ([whiteSpace characterIsMember:ch])
            continue;
        else if ([validInitial characterIsMember:ch])
            [mutableString appendFormat:@"%C", ch];
        else if ([numerical characterIsMember:ch])
            [mutableString appendFormat:([mutableString length]) ? @"%C" : @"_%C", ch];
        else
            [mutableString appendString:([mutableString length]) ? @"_" : @""];
    }
    return [mutableString copy];
}

@end
