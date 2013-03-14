//
//  WFAsyncImageTableCellView.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-14.
//
//

#import "WFAsyncImageTableCellView.h"
#import "NSData+Cache.h"

@implementation WFAsyncImageTableCellView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (void)asyncLoad
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSData *data = [NSData cachedDataAtURL:self.imageURL];
                       if (data)
                       {
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              [self.imageView setImage:[[NSImage alloc] initWithData:data]];
                                              [self setNeedsDisplay:YES];
                                          });
                       }
                   });
}

@end
