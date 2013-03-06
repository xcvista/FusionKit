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
                          // I assumed the code was not intended to be moved thinking
                          // the properties that existed matches.
                          // However I think you need to rename the classes to a better
                          // name - In Objective-C we don't use abbrevisions since
                          // Xcode have strong code completion with clang powering it.
                          // Uncomment the following line (and the one in the header
                          // header file) to accept this change.


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
