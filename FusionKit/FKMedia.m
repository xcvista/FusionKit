//
//  FKMedia.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-5.
//
//

#import "FKMedia.h"

@implementation FKMedia

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.link = [NSURL URLWithString:[aDecoder decodeObjectForKey:@"href"]];
        self.thumbnail = [NSURL URLWithString:[aDecoder decodeObjectForKey:@"picThumbnail"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
