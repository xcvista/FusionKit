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

@property id ID;
@property NSString *title;
@property NSString *content;
@property FKContact *author;
@property FKNews *news;
@property NSDate *publishDate;
@property NSUInteger replyCount;
@property NSDate *lastReplyDate;
@property FKContact *lastReplyContact;
@property NSString *aid;
@property NSArray *tags;
@property id base;
@property id root;
@property BOOL friendly; // NOTE: Objective-C use BOOL in all CAPS.
@property BOOL private;  // NOTE: It is okay to use C++ keywords as names in Objective-C.
@property NSUInteger viewedCount;
@property NSArray *contacts;
@property NSArray *svrNews;

@end
