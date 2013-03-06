//
//  FKNews.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-5.
//
//

#import "FKNews.h"
#import "FKContact.h"
#import "FKMedia.h"
#import "FKJSONKeyedUnarchiver.h"
#import "FKDecls.h"

@implementation FKNews

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.link = [NSURL URLWithString:[aDecoder decodeObjectForKey:@"href"]];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.author = [aDecoder decodeObjectOfClass:[FKContact class] forKey:@"authorUC"];
        self.media = [aDecoder decodeObjectOfClass:[FKMedia class] forKey:@"medias"];
        self.publishDate = [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalFromFKTimestamp([[aDecoder decodeObjectForKey:@"publishTime"] longLongValue])];
        self.ID = [aDecoder decodeObjectForKey:@"id"];
        self.service = [aDecoder decodeObjectForKey:@"svr"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.refer = [aDecoder decodeObjectOfClass:[FKNews class] forKey:@"refer"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self doesNotRecognizeSelector:_cmd];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", [super description], self.title];
}

@end
