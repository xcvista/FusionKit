//
//  FKUserContactLink.m
//  FusionKit
//
//  Created by John Shi on 13-3-6.
//
//

#import "FKUserContactLink.h"

@implementation FKUserContactLink

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.ID = [aDecoder decodeObjectForKey:@"id"];
        self.svr = [aDecoder decodeObjectForKey:@"svr"];
        self.uc = [aDecoder decodeObjectForKey:@"uc"];
        self.user = [aDecoder decodeObjectForKey:@"user"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
