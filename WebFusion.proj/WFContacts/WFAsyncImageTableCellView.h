//
//  WFAsyncImageTableCellView.h
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-14.
//
//

#import <Cocoa/Cocoa.h>

@interface WFAsyncImageTableCellView : NSTableCellView

@property NSURL *imageURL;

- (void)asyncLoad;

@end
