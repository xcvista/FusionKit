//
//  FKContact.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-5.
//
//

#import "FKContact.h"

@implementation FKContact

- initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.displayName = [aDecoder decodeObjectForKey:@"dispName"];
        self.handle = [aDecoder decodeObjectForKey:@"scrName"];
        self.avatar = [NSURL URLWithString:[aDecoder decodeObjectForKey:@"avatar"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
