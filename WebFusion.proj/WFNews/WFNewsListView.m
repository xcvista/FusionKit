//
//  WFNewsListView.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-15.
//
//

#import "WFNewsListView.h"
#import "NSData+Cache.h"

@implementation WFNewsListView

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
    [self.imageView setImage:nil];
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
