//
//  NSBase64DataEncoder.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-4.
//
//

#import "NSBase64DataEncoder.h"
#import "base64.h"

@implementation NSBase64DataEncoder

+ (NSString *)base64StringOfData:(NSData *)data
{
    return [data base64EncodedString];
}

+ (NSData *)dataOfBase64String:(NSString *)string
{
    return [NSData dataFromBase64String:string];
}

@end
