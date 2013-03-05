//
//  PYPinyin.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-4.
//
//

#import "PYPinyin.h"
#import "NSString+Pinyin.h"

@implementation PYPinyin

+ (NSString *)pinyinForString:(NSString *)string
{
    return [string pinyinTransliteration];
}

@end
