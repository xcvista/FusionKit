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
#import "FKSvrNews.h"

@implementation FKPost

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.ID = [aDecoder decodeObjectForKey:@"id"]; //FIXED: This property should be ID in CAPS.
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
        self.aid = [aDecoder decodeObjectForKey:@"aid"];
        self.tags = [aDecoder decodeObjectForKey:@"tags"]; // Array of NSString can be directly decoded.
<<<<<<< HEAD
                                                           // FIXME: I guessed the key.
=======
                                                           
>>>>>>> master
        self.base = [aDecoder decodeObjectForKey:@"base"];
        self.root = [aDecoder decodeObjectForKey:@"root"];
        self.friendly = [[aDecoder decodeObjectForKey:@"isfriendly"] boolValue];
        self.private = [[aDecoder decodeObjectForKey:@"isprivate"] boolValue];
        self.viewedCount = [[aDecoder decodeObjectForKey:@"viewed"] unsignedIntegerValue];
        self.contacts = [aDecoder decodeObjectOfClass:[FKContact class]
                                               forKey:@"contacts"]; // NOTE: Then decoding array of user-defined
                                                                    // objects, use the class of its members as
                                                                    // the class parameter. The decoder can detect
                                                                    // if the objects are enclosed in an array.
<<<<<<< HEAD
                                                                    // FIXME: I guessed the key.
=======
        self.svrNews = [aDecoder decodeObjectOfClass:[FKSvrNews class]
                                               forKey:@"svrNews"];
>>>>>>> master
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self doesNotRecognizeSelector:_cmd];
}

@end
