//
//  WFNewsListView.h
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-15.
//
//

#import <Cocoa/Cocoa.h>

@interface WFNewsListView : NSTableCellView

@property (weak) IBOutlet NSTextField *authorField;
@property (weak) IBOutlet NSTextField *timeField;
@property NSURL *imageURL;

- (void)asyncLoad;

@end
