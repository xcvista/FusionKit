//
//  FKNewsController.h
//  FusionKit
//
//  Created by Maxthon Chan on 13-3-6.
//
//

#import <FusionKit/FusionKit.h>

@interface FKNewsController : NSObject

@property IBOutlet FKNews *news;

@property (readonly) NSString *title;
@property (readonly) NSAttributedString *content;
@property (readonly) NSString *HTMLContent;
@property (readonly) NSString *author;
@property (readonly) NSString *publishTime;
@property (readonly) NSString *service;
@property (readonly) NSString *subnote;
@property (readonly) NSURL *link;

- (IBAction)reply:(id)sender;
- (IBAction)share:(id)sender;
- (IBAction)link:(id)sender;
- (IBAction)star:(id)sender;

@end
