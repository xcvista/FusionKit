//
//  FKWrapper.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-4.
//
//

#import "FKWrapper.h"

@implementation FKWrapper

- (id)initWithObject:(id)object
{
    if (self = [super init])
    {
        self.object = object;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    CFRetain((__bridge CFTypeRef)(aDecoder));
    return (__bridge id)(CFRetain((__bridge CFTypeRef)([aDecoder decodeObjectForKey:@"d"])));
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.object forKey:@"d"];
}

@end
