//
//  FKPost.h
//  FusionKit.C
//
//  Created by John Shi on 13-3-5.
//
//

#import <Foundation/Foundation.h>

@class FKContact, FKNews;

@interface FKPost : NSObject <NSCoding>

@property NSString *title;
@property NSString *content;
@property FKContact *author;
@property FKNews *news;
@property NSDate *publishDate;
@property NSUInteger replyCount;
@property NSDate *lastReplyDate;
@property FKContact *lastReplyContact;

@end
