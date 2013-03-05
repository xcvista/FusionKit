//
//  NSBase64DataEncoder.h
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-4.
//
//

#import <Foundation/Foundation.h>

@interface NSBase64DataEncoder : NSObject

+ (NSString *)base64StringOfData:(NSData *)data;
+ (NSData *)dataOfBase64String:(NSString *)string;

@end
