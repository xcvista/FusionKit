//
//  WFNewsListView.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-15.
//
//

#import "WFNewsListView.h"
#import "NSData+Cache.h"
#import "NSImage+Rounding.h"

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
    NSURL *imageURL = self.imageURL;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSData *data = [NSData cachedDataAtURL:imageURL];
                       if (data)
                       {
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              if ([imageURL isEqual:self.imageURL])
                                              {
                                                  NSImage *avatar = [[[NSImage alloc] initWithData:data] imageByScalingProportionallyToSize:[self.imageView bounds].size];
                                                  NSImage *roundedAvatar = [NSImage makeRoundCornerImage:avatar
                                                                                             cornerWidth:5
                                                                                            cornerHeight:5];
                                                  [self.imageView setImage:roundedAvatar];
                                                  [self setNeedsDisplay:YES];
                                              }
                                              else
                                                  [self asyncLoad];
                                          });
                       }
                   });
}

@end
