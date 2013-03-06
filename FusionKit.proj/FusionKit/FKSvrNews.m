//
//  FKSvrNews.m
//  FusionKit.C
//
//  Created by John Shi on 13-3-5.
//
//

#import "FKSvrNews.h"
#import "FKUserService.h" // NOTE: You always need to #import the used headers here.
                          // This is C, not Java. (Although Objective-C have features
                          // that looks a lot like Java.)

@implementation FKSvrNews

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
