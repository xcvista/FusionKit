//
//  NSImage+Rounding.h
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-18.
//
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Rounding)

+ (NSImage *)makeRoundCornerImage:(NSImage*)img cornerWidth:(CGFloat)cornerWidth cornerHeight:(CGFloat)cornerHeight;
- (NSImage*)imageByScalingProportionallyToSize:(NSSize)targetSize;

@end
