//
//  FKNews+NwsDisplay.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-15.
//
//

#import "FKNews+NwsDisplay.h"
#import "NSData+Cache.h"
#import <FusionApps/FusionApps.h>

@interface FKNews ()

- (FKNews *)refer; // I do have that, but the compiler is *still* complaining.

@end

@implementation FKNews (NwsDisplay)

- (NSString *)time
{
    NSTimeInterval timeDifference = fabs([self.publishDate timeIntervalSinceNow]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:(timeDifference > 43200) ? NSDateFormatterLongStyle : NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:(timeDifference > 43200) ? NSDateFormatterNoStyle : NSDateFormatterShortStyle];
    
    return
    (timeDifference < 60) ? [NSString stringWithFormat:NSLocalizedString(@"%.0lf sec", @""), timeDifference] :
    (timeDifference < 3600) ? [NSString stringWithFormat:NSLocalizedString(@"%.1lf min", @""), timeDifference / 60] :
    (timeDifference < 10800) ? [NSString stringWithFormat:NSLocalizedString(@"%.1lf hr", @""), timeDifference / 3600] :
    [dateFormatter stringFromDate:self.publishDate];
}

- (NSString *)htmlString
{
    NSString *template =
    @"<html><head><meta charset=\"utf-8\" />"
     "<style typr=\"text/css\">body{font-family:Helvetica;size:17px;}"
     ".hover{float:right;margin:3px;height:60px;}img{max-width:80%}"
     "hr{border-style:none;background-color:grey;height:1px;width:100%}"
     ".center{text-align:center}p{margin-top:3px;margin-bottom:3px;}"
     ".mediaImg{margin:20px}"
     ".roundCorners{border-radius: 4px;}"
     "</style></head>"
     "<body>TEMP</body></html>";
    NSString *postTemplate =
    @"<div style=\"min-height:65px;padding-left:10px;padding-right:10px;"
     "padding-top:10px;\">"
     "<img class=\"hover roundCorners\" src=\"AVATAR\" />"
     "<p style=\"font-weight:bold;\">AUTHOR</p>"
     "<p style=\"color:grey\">SERVICE - TIME</p>"
     "<p>TITLE</p></div>"
     "<div style=\"padding-left:10px;padding-right:10px;padding-bottom:10px;\">CONTENT</div>";
    NSString *splitter =
    @"<div class=\"center\"><hr style=\"background-color:black;\" /></div>";
    
    NSMutableString *body = [NSMutableString string];
    
    FKNews *news = self;
    
    do
    {
        NSMutableString *current = [NSMutableString stringWithString:postTemplate];
        
        // Check cache
        NSMutableArray *missingCache = [NSMutableArray array];
        NSMutableArray *mediaURL = [NSMutableArray arrayWithCapacity:[self.media count]];
        
        NSURL *avatarURL = [NSData cachedURLForURL:news.author.avatar
                                        buildCache:NO];
        if (!avatarURL)
        {
            avatarURL = news.author.avatar;
            [missingCache addObject:news.author.avatar];
        }
        
        for (FKMedia *media in news.media)
        {
            NSURL *avatarURL = [NSData cachedURLForURL:media.link
                                            buildCache:NO];
            if (!avatarURL)
            {
                avatarURL = media.link;
                [missingCache addObject:media.link];
            }
            [mediaURL addObject:avatarURL];
        }
        
        NSMutableString *content = [NSMutableString string];
        
        if ([news.content length])
        {
            [content appendString:
             @"<div class=\"center\" style=\"padding-left:10px;"
              "padding-right:10px;padding-top:20px\"><hr /></div>"];
            [content appendFormat:@"<div>%@</div>", news.content];
        }
        
        for (NSURL *url in mediaURL)
        {
            [content appendFormat:@"<div class=\"center mediaImg\"><img src=\"%@\" /></div>", [url absoluteString]];
        }
        
        NSArray *keys = @[@"CONTENT",
                          @"TITLE",
                          @"TIME",
                          @"SERVICE",
                          @"AUTHOR",
                          @"AVATAR"];
        
        NSArray *values = @[content,
                            news.title,
                            news.time,
                            [[WFAppLoader appLoader] invokeMethod:@"WFLocalizedGateway"
                                              onAppWithIdentifier:@"tk.maxius.webfusion.infrastructure"
                                                         withArgs:@[news.service]],
                            news.author.description,
                            [avatarURL absoluteString]];
        
        for (NSUInteger i = 0; i < MIN([keys count], [values count]); i++)
        {
            NSRange range = [current rangeOfString:keys[i]];
            [current replaceCharactersInRange:range
                                   withString:values[i]];
        }
        
        [current appendString:splitter];
        
        [body appendString:current];
    }
    while ((news = news.refer));
    
    NSRange rTemplate = [template rangeOfString:@"TEMP"];
    return [template stringByReplacingCharactersInRange:rTemplate
                                             withString:body];
}

@end
