//
//  FKNews.h
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-5.
//
//

#import <Foundation/Foundation.h>

@class FKContact, FKService;

@interface FKNews : NSObject <NSCoding>

@property (nonatomic, readonly) NSURL *link;
@property (nonatomic, readonly) NSString *locationName;
@property (nonatomic, readonly) NSArray *actions;
@property (nonatomic, readonly) FKContact *author;
@property (nonatomic, readonly) NSArray *mediaList;
@property (nonatomic, readonly) NSDate *publishDate;
@property (nonatomic, readonly) FKNews *referrer;
@property (nonatomic, readonly) FKService *service;
@property (nonatomic, readonly) id ID;
@property (nonatomic, readonly) BOOL canReply;

@end
