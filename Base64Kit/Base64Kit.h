//
//  Base64Kit.h
//  Base64Kit
//
//  Created by Maxthon Chan on 13-3-4.
//
//

#import <Foundation/Foundation.h>

#if TARGET_OS_EMBEDDED || TARGET_OS_IPHONE

#import <MobileBase64Kit/NSBase64DataEncoder.h>
#import <MobileBase64Kit/base64.h>

#else

#import <Base64Kit/NSBase64DataEncoder.h>
#import <Base64Kit/base64.h>

#endif
