//
//  NSDictionary+pl2objc.m
//  Tools
//
//  Created by Maxthon Chan on 13-4-1.
//
//

#import "NSDictionary+pl2objc.h"

@implementation NSDictionary (pl2objc)

- (NSString *)sourceRepresentation
{
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[self count]];
    for (id object in self)
    {
        [objects addObject:[NSString stringWithFormat:@"%@: %@", [object sourceRepresentation], [self[object] sourceRepresentation]]];
    }
    return [NSString stringWithFormat:@"@{%@}", [objects componentsJoinedByString:@", "]];
}

@end
