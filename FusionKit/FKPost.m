//
//  FKPost.m
//  FusionKit.C
//
//  Created by John Shi on 13-3-5.
//
//

#import "FKPost.h"
#import "FKContact.h"
#import "FKNews.h"
#import "FKDecls.h"

@implementation FKPost

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.title = [aDecoder decodeObjectForKey:@"title"];
        //self.content
        self.author = [aDecoder decodeObjectOfClass:[FKContact class]
                                             forKey:@"authorUC"];
        self.news = [aDecoder decodeObjectOfClass:[FKNews class]
                                           forKey:@"news"];
        self.publishDate = [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalFromFKTimestamp([[aDecoder decodeObjectForKey:@"posttime"] longLongValue])];
        self.replyCount = [[aDecoder decodeObjectForKey:@"reply"] unsignedIntegerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
