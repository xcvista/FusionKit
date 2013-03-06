//
//  FKUserService.m
//  FusionKit.C
//
//  Created by John Shi on 13-3-5.
//
//

#import "FKUserService.h"
#import "FKDecls.h"

@implementation FKUserService

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.ID = [aDecoder decodeObjectForKey:@"id"];
        self.user = [aDecoder decodeObjectForKey:@"user"];
        self.gate = [aDecoder decodeObjectForKey:@"gate"];
        self.time = [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalFromFKTimestamp([[aDecoder decodeObjectForKey:@"update"] longLongValue])];
        self.update = [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalFromFKTimestamp([[aDecoder decodeObjectForKey:@"update"] longLongValue])];
        self.account = [aDecoder decodeObjectForKey:@"account"];
        if([aDecoder containsValueForKey:@"key"]){ // Use for debug Only
            NSLog(@"WARNING: UserService key leaked.");
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
