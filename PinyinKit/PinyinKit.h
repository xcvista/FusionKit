//
//  PinyinKit.h
//  PinyinKit
//
//  Created by Maxthon Chan on 13-3-4.
//
//

#import <Foundation/Foundation.h>

#if TARGET_OS_EMBEDDED || TARGET_OS_IPHONE

#import <MobilePinyinKit/PYPinyin.h>
#import <MobilePinyinKit/NSString+Pinyin.h>

#else

#import <PinyinKit/PYPinyin.h>
#import <PinyinKit/NSString+Pinyin.h>

#endif

