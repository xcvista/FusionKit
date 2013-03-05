//
//  FKNewsController.h
//  FusionKit
//
//  Created by Maxthon Chan on 13-3-6.
//
//

#import <FusionKit/FusionKit.h>

@interface FKNewsController : NSObject

@property FKNews *news;

@property (readonly) NSString *title;
@property (readonly) NSAttributedString *content;
@property (readonly) NSString *author;
@property (readonly) NSString *publishTime;
@property (readonly) NSString *service;
@property (readonly) NSURL *link;

@end
