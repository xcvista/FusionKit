//
//  FKSvrNews.m
//  FusionKit.C
//
//  Created by John Shi on 13-3-5.
//
//

#import "FKSvrNews.h"

@implementation FKUserService;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.svr = [aDecoder decodeObjectForKey:@"svr"];
        self.svrId = [aDecoder decodeObjectForKey:@"svrId"];
        self.us = [aDecoder decodeObjectOfClass:[FKUserService class]
                                           forKey:@"us"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
