//
//  NSString+JSONSanitizer.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-6.
//
//

#import "NSString+JSONSanitizer.h"

@implementation NSString (JSONSanitizer)

- (NSString *)sanitizedString
{
    NSData *this = [self dataUsingEncoding:NSUTF8StringEncoding];
    id object = [NSJSONSerialization JSONObjectWithData:this
                                                options:0
                                                  error:NULL];
    if (object)
    {
        NSData *sanitized = [NSJSONSerialization dataWithJSONObject:object
                                                            options:NSJSONWritingPrettyPrinted
                                                              error:NULL];
        return [[NSString alloc] initWithData:sanitized
                                     encoding:NSUTF8StringEncoding];
    }
    else
    {
        return self;
    }
}

@end
