//
//  WFNewsItemViewController.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-5.
//
//

#import "WFNewsItemViewController.h"
#import <FusionBinding/FusionBinding.h>
#import "NSString+Geometrics.h"

@interface WFNewsItemViewController ()

@property (weak) IBOutlet NSTextField *contentField;

- (IBAction)share:(id)sender;
- (IBAction)reply:(id)sender;

@end

@implementation WFNewsItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)setRepresentedObject:(id)object;
{
    [super setRepresentedObject:object];
    FKNews *news = object;
    self.newsTitle = news.title;
    self.author = [NSString stringWithFormat:@"%@ (%@)\n%@", news.author.displayName, news.author.handle, [news.service capitalizedString]];
    self.content = news.content;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSData *avatar = [NSData dataWithContentsOfURL:news.author.avatar];
                       NSData *image = nil;
                       if ([news.media count] > 0)
                       {
                           image = [NSData dataWithContentsOfURL:[news.media[0] thumbnail]];
                       }
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          self.avatar = [[NSImage alloc] initWithData:avatar];
                                          if (image)
                                          {
                                              self.hasImage = YES;
                                              self.image = [[NSImage alloc] initWithData:image];
                                          }
                                      });
                   });
}

- (void)share:(id)sender
{
    
}

- (void)reply:(id)sender
{
    
}

@end
