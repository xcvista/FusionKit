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
#import "WFNewsInfoWindowController.h"
#import "WFAppDelegate.h"

@interface WFNewsItemViewController ()

@property IBOutlet FKNewsController *newsController;

@property (weak) IBOutlet NSTextField *contentField;
@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet NSTextField *authorField;
@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSImageView *avatarView;
@property (weak) IBOutlet NSButton *replyButton;
@property (weak) IBOutlet NSButton *shareButton;
@property (weak) IBOutlet NSButton *infoButton;
@property (weak) IBOutlet NSButton *starButton;
@property (weak) IBOutlet NSButton *linkButton;

@property (weak) IBOutlet NSProgressIndicator *loadingIndicator;

@property BOOL spin;

- (IBAction)share:(id)sender;
- (IBAction)reply:(id)sender;
- (IBAction)info:(id)sender;
- (IBAction)star:(id)sender;
- (IBAction)link:(id)sender;

@end

@implementation WFNewsItemViewController

- (id)init
{
    return [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
    [self view];
    FKNews *news = [self representedObject];
    if (!news)
        return;
    if ([news.media count] > 0)
    {
        [self.imageView setHidden:NO];
        [self.contentField setFrameSize:NSMakeSize(207, [self.contentField frame].size.height)];
    }
    else
    {
        [self.imageView setHidden:YES];
        [self.contentField setFrameSize:NSMakeSize(381, [self.contentField frame].size.height)];
    }
    
    if ([[news.link absoluteString] length])
    {
        [self.titleField setFrameSize:NSMakeSize(315, 24)];
        [self.linkButton setHidden:NO];
    }
    else
    {
        [self.titleField setFrameSize:NSMakeSize(347, 24)];
        [self.linkButton setHidden:YES];
    }
    
    [self.loadingIndicator startAnimation:self];
    
    if (self.newsController)
        self.newsController.news = news;
    else
        return;
    
    [self.titleField setStringValue:news.title];
    
    [self.authorField setStringValue:self.newsController.subnote];
    
    NSAttributedString *attributedString = self.newsController.content;
    [self.contentField setAttributedStringValue:attributedString];
    
    CGFloat height = MAX(166, [attributedString heightForWidth:[self.contentField bounds].size.width]);
    CGFloat width = [news.title heightForWidth:[self.titleField frame].size.width font:[self.titleField font]];
    
    BOOL longTitle = width > 24;
    BOOL longContent = height > [self.contentField frame].size.height;
    
    if (longContent || longTitle || [news.media count] > 0)
    {
        [self.infoButton setHidden:NO];
    }
    else
    {
        [self.infoButton setHidden:YES];
    }
    // Load images with a subthread - speed issue.
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
                                          self.avatarView.image = [[NSImage alloc] initWithData:avatar];
                                          if (image)
                                          {
                                              self.imageView.image = [[NSImage alloc] initWithData:image];
                                          }
                                          [self.loadingIndicator stopAnimation:self];
                                      });
                   });

}

- (void)info:(id)sender
{
    WFNewsInfoWindowController *newsInfo = [[WFNewsInfoWindowController alloc] init];
    WFAppDelegate *delegate = [NSApp delegate];
    newsInfo.news = [self representedObject];
    [delegate showWindowController:newsInfo];
}

@end
