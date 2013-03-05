//
//  FKNewsController.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-5.
//
//

#import "FKNewsController.h"

@implementation FKNewsController

+ (instancetype)controllerWithNews:(FKNews *)news
{
    FKNewsController *controller = [[FKNewsController alloc] init];
    controller.news = news;
    return controller;
}

- (NSString *)author
{
    return [NSString stringWithFormat:@"%@ (%@) - %@", self.news.author.displayName, self.news.author.handle, self.news.service];
}

- (NSString *)title
{
    return self.news.title;
}

- (NSString *)contentHTML
{
    NSString *htmlString = [NSString stringWithFormat:@"<html><head><meta charset=\"utf-8\" /><style type=\"text/css\">body { font-family: Lucida Grande; size: 13pt; }</style></head><body><div>%@</div>", self.news.content];
    for (FKMedia *media in self.news.media)
        htmlString = [htmlString stringByAppendingFormat:@"<div style=\"text-align: center;\"><img src=\"%@\" /></div>", [media.thumbnail absoluteString]];
    htmlString = [htmlString stringByAppendingFormat:@"</body></html>"];
    return htmlString;
}

- (NSAttributedString *)content
{
    NSString *htmlString = [self contentHTML];
    return [[NSAttributedString alloc] initWithHTML:[htmlString dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:NULL];
}

- (NSURL *)avatar
{
    return self.news.author.avatar;
}

- (NSURL *)firstMedia
{
    if ([self.news.media count] == 0)
        return nil;
    else
        return [self.news.media[0] link];
}

@end
