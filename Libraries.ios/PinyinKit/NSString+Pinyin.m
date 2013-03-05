//
//  NSString+Pinyin.m
//  FusionKit
//
//  Created by Maxthon Chan on 12-8-13.
//  Copyright (c) 2012年 myWorld Creations. All rights reserved.
//

#import "NSString+Pinyin.h"
#import <Foundation/Foundation.h>

static NSDictionary *dict;

@implementation NSString (Pinyin)

+ (NSDictionary *)dict
{
    if (!dict)
    {
        NSURL *dictURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"dict" withExtension:@"txt"];
        NSString *_dict = [NSString stringWithContentsOfURL:dictURL encoding:NSUTF8StringEncoding error:nil];
        NSArray *items = [_dict componentsSeparatedByString:@"\n"];
        NSMutableDictionary *dictObj = [NSMutableDictionary dictionaryWithCapacity:20000];
        for (NSString *item in items)
        {
            if (!item.length)
                continue;
            NSArray *parts = [item componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[,]"]];
            NSString *chars = [parts objectAtIndex:0];
            NSString *pinyin = [parts objectAtIndex:1];
            for (NSRange r = NSMakeRange(0, 1); r.location < chars.length; r.location++)
            {
                [dictObj setObject:pinyin forKey:[chars substringWithRange:r]];
            }
        }
        dict = [dictObj copy];
    }
    return dict;
}

- (NSString *)pinyinTransliteration
{
    NSMutableString *string = [NSMutableString stringWithCapacity:self.length];
    for (NSRange r = NSMakeRange(0, 1); r.location < self.length; r.location++)
    {
        NSString *character = [self substringWithRange:r];
        NSString *pinyin = [[NSString dict] objectForKey:character];
        [string appendString:(pinyin) ? pinyin : character];
    }
    return [string copy];
}

@end
