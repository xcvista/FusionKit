//
//  NSArray+pl2objc.m
//  Tools
//
//  Created by Maxthon Chan on 13-4-1.
//
//

#import "NSArray+pl2objc.h"

@implementation NSArray (pl2objc)

- (NSString *)sourceRepresentation
{
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:[self count]];
    for (id object in self)
    {
        [objects addObject:[object sourceRepresentation]];
    }
    return [NSString stringWithFormat:@"@[%@]", [objects componentsJoinedByString:@", \n"]];
}

@end
