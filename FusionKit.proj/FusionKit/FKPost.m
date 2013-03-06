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
        self.id = [aDecoder decodeObjectForKey:@"id"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        
        self.author = [aDecoder decodeObjectOfClass:[FKContact class]
                                             forKey:@"authorUC"];
        self.news = [aDecoder decodeObjectOfClass:[FKNews class]
                                           forKey:@"news"];
        self.publishDate = [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalFromFKTimestamp([[aDecoder decodeObjectForKey:@"posttime"] longLongValue])];
        self.replyCount = [[aDecoder decodeObjectForKey:@"reply"] unsignedIntegerValue];
        self.lastReplyDate =  [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalFromFKTimestamp([[aDecoder decodeObjectForKey:@"datereply"] longLongValue])];
        self.lastReplyContact =  [aDecoder decodeObjectOfClass:[FKContact class]
                                                        forKey:@"replyAuthorUC"];
        self.aid = [aDecoder decodeObject:@"aid"];
        self.tags = [aDecoder de];
        self.base = [aDecoder decodeObjectForKey:@"base"];
        self.root = [aDecoder decodeObjectForKey:@"root"];
        self.friendly = [aDecoder decodeObjectForKey:@"isfriendly"];
        self.isprivate = [aDecoder decodeObjectForKey:@"isprivate"];
        self.viewedCount = [aDecoder decodeObjectForKey:@"viewed"];
        //self.contacts =
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
