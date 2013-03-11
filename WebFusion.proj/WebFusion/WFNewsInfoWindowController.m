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
#import "NSData+Cache.h"
#import <FusionKit/FusionKit.h>

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

- (void)buildCacheBackground:(NSURL *)url;
{
    static NSMutableArray *URLs;
    if (!URLs)
        URLs = [NSMutableArray array];
    
    if (url)
    {
        if (![URLs containsObject:url])
            [URLs addObject:url];
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           for (NSURL *link in URLs)
                           {
                               [NSData cachedDataAtURL:link];
                           }
                       });
    }
}

- (NSString *)fullHTMLContentNoSurronding:(FKNews *)news;
{
    NSString *content = ([news.content length]) ? news.content : news.title;
    NSString *images = @"";
    for (FKMedia *media in news.media)
    {
        NSURL *cacheURL = nil;
        NSURL *link = media.link;
        if (!(cacheURL = [NSData cachedURLForURL:link buildCache:NO]))
        {
            cacheURL = link;
            [self buildCacheBackground:link];
        }
        images = [images stringByAppendingFormat:@"<div style=\"text-align: center;\"><img src=\"%@\" /></div>", [cacheURL absoluteString]];
    }
    return [NSString stringWithFormat:@"<div>%@</div>%@", content, images];
}

- (NSString *)fullHTMLContent:(FKNews *)news;
{
    NSString *content = [self fullHTMLContentNoSurronding:news];
    if (news.refer)
    {
        content = [content stringByAppendingString:@"<hr /><div>In reply to:</div>"];
        FKNews *refer = news.refer;
        do
        {
            FKNewsController *newsController = [[FKNewsController alloc] init];
            newsController.news = refer;
            NSURL *link = refer.author.avatar;
            NSURL *cacheURL = nil;
            if (!(cacheURL = [NSData cachedURLForURL:link buildCache:NO]))
            {
                cacheURL = link;
                [self buildCacheBackground:link];
            }

            content = [content stringByAppendingFormat:@"<div><img src=\"%@\" style=\"max-height: 60px;float: left; margin: 4px;\"><div style=\"font-weight: bold; size:20px;\">%@</div><blockquote><div>%@</div><div>%@</div><div>%@</div></blockquote>%@</div>", [cacheURL absoluteString], newsController.title, newsController.author, newsController.service, newsController.publishTime, [self fullHTMLContentNoSurronding:refer]];
        }
        while ((refer = refer.refer));
    }
    return [NSString stringWithFormat:@"<html><head><meta charset=\"utf-8\" /><style>body{font-family:\"Lucida Grande\";size:13px;}img{max-width: 60%% !important}</style></head><body>%@</body></html>", content];
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
    
    [[self.webView mainFrame] loadHTMLString:[self fullHTMLContent:self.news]
                                     baseURL:nil];
    [self buildCacheBackground:nil];
    // Load images with a subthread - speed issue.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       
                       NSData *avatar = [NSData cachedDataAtURL:self.news.author.avatar];

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
