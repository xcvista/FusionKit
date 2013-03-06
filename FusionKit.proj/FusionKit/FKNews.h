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

@property NSString *title;
@property NSString *content;
@property NSURL *link;
@property FKContact *author;
@property NSArray *media;
@property NSDate *publishDate;
@property id service;
@property id ID;
@property NSString *type;
@property FKNews *refer;


@end
