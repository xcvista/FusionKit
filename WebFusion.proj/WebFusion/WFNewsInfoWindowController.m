//
//  WFNewsInfoWindowController.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-5.
//
//

#import "WFNewsInfoWindowController.h"
#import "WFAppDelegate.h"
#import <FusionBinding/FusionBinding.h>

@interface WFNewsInfoWindowController () <NSWindowDelegate>

@property (weak) IBOutlet NSTextField *titleField;
@property (weak) IBOutlet NSTextField *authorField;
@property (weak) IBOutlet NSButton *linkButton;
@property (weak) IBOutlet NSButton *starButton;
@property (weak) IBOutlet NSImageView *avatarWell;
@property (weak) IBOutlet WebView *webView;

@property IBOutlet FKNewsController *newsController;

@end

@implementation WFNewsInfoWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    if (!self.news)
    {
        [self.window orderOut:self];
        return;
    }
    
    self.newsController.news = self.news;
    
    if (![[self.news.link absoluteString] length])
    {
        [self.starButton setFrame:NSMakeRect([self.linkButton frame].origin.x, [self.linkButton frame].origin.y, 84, [self.linkButton frame].size.height)];
        [self.linkButton setHidden:YES];
    }
    
    [self.window setTitle:self.newsController.title];
    [self.titleField setStringValue:self.newsController.title];
    
    [self.authorField setStringValue:self.newsController.subnote];
    
    [[self.webView mainFrame] loadHTMLString:self.newsController.fullHTMLContent
                                     baseURL:nil];
    // Load images with a subthread - speed issue.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       
                       NSData *avatar = [NSData dataWithContentsOfURL:self.news.author.avatar];

                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          self.avatarWell.image = [[NSImage alloc] initWithData:avatar];
                                      });
                   });

}

- (void)windowWillClose:(NSNotification *)notification
{
    WFAppDelegate *delegate = [NSApp delegate];
    [delegate releaseWindowController:self];
}

@end
