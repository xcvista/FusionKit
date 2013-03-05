//
//  FKNewsController.h
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-5.
//
//

#import <Cocoa/Cocoa.h>
#import <FusionKit/FusionKit.h>

@interface FKNewsController : NSObjectController

@property FKNews *news;

@property (readonly) NSString *title;
@property (readonly) NSString *author;
@property (readonly) NSURL *avatar;
@property (readonly) NSString *contentHTML;
@property (readonly) NSAttributedString *content;
@property (readonly) NSURL *firstMedia;

+ (instancetype)controllerWithNews:(FKNews *)news;

@end
