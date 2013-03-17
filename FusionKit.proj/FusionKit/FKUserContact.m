//
//  FKUserContact.m
//  FusionKit
//
//  Created by John Shi on 13-3-6.
//
//

#import "FKUserContact.h"
#import "FKUserContactLink.h"
#import "FKContact.h"

@implementation FKUserContact

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.ID = [aDecoder decodeObjectForKey:@"id"];
        self.user = [aDecoder decodeObjectForKey:@"user"];
        self.ucs = [aDecoder decodeObjectOfClass:[FKUserContactLink class]
                                          forKey:@"ucs"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.avatar = [aDecoder decodeObjectOfClass:[FKContact class]           forKey:@"avatar"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
