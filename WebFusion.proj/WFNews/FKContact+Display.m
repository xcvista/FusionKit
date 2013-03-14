//
//  FKContact+Display.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-15.
//
//

#import "FKContact+Display.h"

@implementation FKContact (Display)

- (NSString *)description
{
    return
    ([self.handle isEqualToString:self.displayName]) ? self.handle :
    ([self.handle length] == 0) ? self.displayName :
    ([self.displayName length] == 0) ? self.handle :
    [NSString stringWithFormat:@"%@ (%@)", self.displayName, self.handle];
}

@end
