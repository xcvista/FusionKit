//
//  WFNewsItemViewController.h
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-5.
//
//

#import <Cocoa/Cocoa.h>

@interface WFNewsItemViewController : NSCollectionViewItem

@property NSString *newsTitle;
@property NSString *author;
@property NSImage *avatar;
@property NSString *content;
@property NSURL *firstMedia;
@property NSImage *image;
@property BOOL hasImage;

@end
