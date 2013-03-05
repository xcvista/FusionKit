//
//  FKDecls.h
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-4.
//
//

#ifndef FusionKit_C_FKDecls_h
#define FusionKit_C_FKDecls_h

#if defined(__cplusplus)
#define FKBeginDecls extern "C" {
#define FKEndDecls }
#define FKExtern extern "C"
#else
#define FKBeginDecls
#define FKEndDecls
#define FKExtern extern
#endif

#define FKAssignError(param, error) \
do {\
if (param)\
*param = error; \
} while (0)

#if defined(__OBJC__)

#import <Foundation/Foundation.h>

static NSString *const FKErrorDoamin = @"tk.maxius.fusionkit.error";

static NSString *const FKTrueValue = @"+";
static NSString *const FKFalseValue = @"-";

#endif

typedef long long FKTimestamp;

NSTimeInterval NSTimeIntervalFromFKTimestamp(FKTimestamp);
FKTimestamp FKTimestampFromNSTimeInterval(NSTimeInterval);

#endif
