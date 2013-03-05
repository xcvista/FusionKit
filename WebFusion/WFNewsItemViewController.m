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
    FKNews *news = [self representedObject];
    [self.titleField setStringValue:news.title];
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
    NSString *content = ([news.content length]) ? news.content : news.title;
    NSString *html = [NSString stringWithFormat:@"<html><head><meta charset=\"utf-8\" /><style>body{font-family:\"Lucida Grande\";</style></head><body><div>%@</div></body></html>", content];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithHTML:[html dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:NULL];
    [self.contentField setAttributedStringValue:attributedString];
    CGFloat height = MAX(166, [attributedString heightForWidth:[self.contentField bounds].size.width]/*[content heightForWidth:[self.contentField bounds].size.width font:self.contentField.font]*/);
    [self.contentField setFrameSize:NSMakeSize([self.contentField frame].size.width, height)];
    [self.view setFrameSize:NSMakeSize([self.view frame].size.width, height + 191)];
    [self.loadingIndicator startAnimation:self];
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

- (void)loadView
{
    [super loadView];
    NSLog(@"Loading view for %@", [self representedObject]);
}

- (void)share:(id)sender
{
    
}

- (void)reply:(id)sender
{
    
}

- (void)info:(id)sender
{
    
}

@end
