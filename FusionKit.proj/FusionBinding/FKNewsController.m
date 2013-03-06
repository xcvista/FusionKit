//
//  FKNewsController.m
//  FusionKit
//
//  Created by Maxthon Chan on 13-3-6.
//
//

#import "FKNewsController.h"

@implementation FKNewsController

- (NSString *)title
{
    return self.news.title;
}

- (NSString *)HTMLContent
{
    NSString *content = ([self.news.content length]) ? self.news.content : self.news.title;
    return [NSString stringWithFormat:@"<html><head><meta charset=\"utf-8\" /><style>body{font-family:\"Lucida Grande\";size:13px;}</style></head><body><div>%@</div></body></html>", content];
}

- (NSAttributedString *)content
{
    return [[NSAttributedString alloc] initWithHTML:[self.HTMLContent dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:NULL];
}

- (NSString *)fullHTMLContentNoSurronding
{
    NSString *content = ([self.news.content length]) ? self.news.content : self.news.title;
    NSString *images = @"";
    for (FKMedia *media in self.news.media)
        images = [images stringByAppendingFormat:@"<div style=\"text-align: center;\"><img src=\"%@\" /></div>", media.link];
    return [NSString stringWithFormat:@"<div>%@</div>%@", content, images];
}

- (NSString *)fullHTMLContent
{
    NSString *content = [self fullHTMLContentNoSurronding];
    if (self.news.refer)
    {
        content = [content stringByAppendingString:@"<hr /><div>In reply to:</div>"];
        FKNews *refer = self.news.refer;
        do
        {
            FKNewsController *newsController = [[FKNewsController alloc] init];
            newsController.news = refer;
            content = [content stringByAppendingFormat:@"<div><img src=\"%@\" style=\"max-height: 60px;float: left; margin: 4px;\"><div style=\"font-weight: bold; size:20px;\">%@</div><blockquote><div>%@</div><div>%@</div><div>%@</div></blockquote>%@</div>", refer.author.avatar, newsController.title, newsController.author, newsController.service, newsController.publishTime, [newsController fullHTMLContentNoSurronding]];
        }
        while ((refer = refer.refer));
    }
    return [NSString stringWithFormat:@"<html><head><meta charset=\"utf-8\" /><style>body{font-family:\"Lucida Grande\";size:13px;}img{max-width: 60%% !important}</style></head><body>%@</body></html>", content];
}

- (NSAttributedString *)fullContent
{
    return [[NSAttributedString alloc] initWithHTML:[self.fullHTMLContent dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:NULL];
}

- (NSString *)author
{
    return
    ([self.news.author.handle isEqualToString:self.news.author.displayName]) ? self.news.author.handle :
    ([self.news.author.handle length] == 0) ? self.news.author.displayName :
    ([self.news.author.displayName length] == 0) ? self.news.author.handle :
    [NSString stringWithFormat:@"%@ (%@)", self.news.author.displayName, self.news.author.handle];
}

- (NSString *)publishTime
{
    NSTimeInterval timeDifference = fabs([self.news.publishDate timeIntervalSinceNow]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:(timeDifference > 43200) ? NSDateFormatterLongStyle : NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    return
    (timeDifference < 60) ? [NSString stringWithFormat:NSLocalizedString(@"%.0lf seconds ago", @""), timeDifference] :
    (timeDifference < 3600) ? [NSString stringWithFormat:NSLocalizedString(@"%.1lf minutes ago", @""), timeDifference / 60] :
    (timeDifference < 10800) ? [NSString stringWithFormat:NSLocalizedString(@"%.1lf hours ago", @""), timeDifference / 3600] :
    [dateFormatter stringFromDate:self.news.publishDate];
}

- (NSString *)service
{
    return NSLocalizedStringFromTableInBundle(self.news.service, @"services", [NSBundle bundleForClass:[self class]], @"");
}

- (NSString *)subnote
{
    return [NSString stringWithFormat:@"%@\n%@\n%@", self.author, self.service, self.publishTime];
}

- (void)share:(id)sender
{
    
}

- (void)reply:(id)sender
{
    
}

- (void)star:(id)sender
{
    
}

- (void)link:(id)sender
{
    if (![[self.news.link absoluteString] length])
        return;
    
    [[NSWorkspace sharedWorkspace] openURL:self.news.link];
}

@end
