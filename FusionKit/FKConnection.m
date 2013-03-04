//
//  FKConnection.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-4.
//
//

#import "FKConnection.h"
#import "FKJSONKeyedArchiver.h"
#import "FKJSONKeyedUnarchiver.h"
#import "FKDecls.h"
#import "FKWrapper.h"

@implementation FKConnection

- (id)initWithServerRoot:(NSURL *)serverRoot
{
    if (self = [super init])
    {
        self.serverRoot = serverRoot;
    }
    return self;
}

- (NSString *)userAgent
{
    NSString *appName = @"FusionKit/3.0";
    NSString *platform = nil;
#if (TARGET_OS_IPHONE || TARGET_OS_EMBEDDED)
    platform = @"iOS";
#elif TARGET_OS_MAC
    platform = @"OSX";
#elif GNUSTEP
    platform = @"GNUstep";
#else
    platform = @"Unknown";
#endif
    return [NSString stringWithFormat:@"%@ (%@, Objective-C serialization)", appName, platform];
}

- (NSData *)dataWithPostData:(NSData *)data toMethod:(NSString *)method error:(NSError *__autoreleasing *)error
{
    NSURL *methodURL = [NSURL URLWithString:method relativeToURL:self.serverRoot];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:methodURL];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:data];
    [request setHTTPShouldHandleCookies:YES];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];
    NSError *err = nil;
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&err];
    if (!responseData)
    {
        FKAssignError(error, err);
        return nil;
    }
    if ([response statusCode] >= 400)
    {
        FKAssignError(error, [NSError errorWithDomain:@"tk.maxius.httpError"
                                                 code:[response statusCode]
                                             userInfo:nil]);
        return nil;
    }
    return responseData;
}

- (NSData *)dataWithGetFromMethod:(NSString *)method error:(NSError *__autoreleasing *)error
{
    NSURL *methodURL = [NSURL URLWithString:method relativeToURL:self.serverRoot];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:methodURL];
    [request setHTTPShouldHandleCookies:YES];
    [request setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];
    NSError *err = nil;
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&err];
    if (!responseData)
    {
        FKAssignError(error, err);
        return nil;
    }
    if ([response statusCode] >= 400)
    {
        FKAssignError(error, [NSError errorWithDomain:@"tk.maxius.httpError"
                                                 code:[response statusCode]
                                             userInfo:nil]);
        return nil;
    }
    return responseData;
}

- (BOOL)loginWithUsername:(NSString *)username password:(NSString *)password error:(NSError *__autoreleasing *)error
{
    NSDictionary *uplink = @{
                             @"user": username,
                             @"pass": password
                             };
    NSData *uplinkData = [FKJSONKeyedArchiver archivedDataWithRootObject:uplink];
    NSError *err;
    NSData *downlinkData = [self dataWithPostData:uplinkData
                                         toMethod:@"Login"
                                            error:&err];
    
    if (!downlinkData)
    {
        FKAssignError(error, err);
        return NO;
    }
    
    NSString *result = [FKJSONKeyedUnarchiver unarchiveObjectWithData:downlinkData
                                                                class:[FKWrapper class]];
    
    if ([result isEqualToString:FKTrueValue])
    {
        return YES;
    }
    else
    {
        FKAssignError(error, [NSError errorWithDomain:FKErrorDoamin
                                                 code:403
                                             userInfo:@{@"response": result}]);
        return NO;
    }
}

@end
