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
#import "FKNews.h"
#import "FKUserContact.h"

NSString *const FKWillUploadPackageNotification = @"tk.maxius.fusionkit.packageup";
NSString *const FKDidReceivePackageNotification = @"tk.maxius.fusionkit.packagedown";

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
    NSDate *sendDate = [NSDate date];
    [[NSNotificationCenter defaultCenter] postNotificationName:FKWillUploadPackageNotification
                                                        object:self
                                                      userInfo:@{@"packet": request, @"date": sendDate}];
    NSError *err = nil;
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&err];
    [[NSNotificationCenter defaultCenter] postNotificationName:FKDidReceivePackageNotification
                                                        object:self
                                                      userInfo:@{@"request": request, @"response": response ? response : [NSNull null], @"packet": responseData ? responseData : [NSNull null], @"error": (err) ? err : [NSNull null], @"date": [NSDate date], @"requestDate": sendDate}];
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
    NSDate *sendDate = [NSDate date];
    [[NSNotificationCenter defaultCenter] postNotificationName:FKWillUploadPackageNotification
                                                        object:self
                                                      userInfo:@{@"packet": request, @"date": sendDate}];
    NSError *err = nil;
    NSHTTPURLResponse *response = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&err];
    [[NSNotificationCenter defaultCenter] postNotificationName:FKDidReceivePackageNotification
                                                        object:self
                                                      userInfo:@{@"request": request, @"response": response, @"packet": responseData, @"error": (err) ? err : [NSNull null], @"date": [NSDate date], @"requestDate": sendDate}];
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
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:
                                       NSLocalizedStringFromTableInBundle(@"User authentication failed.", @"error", [NSBundle bundleForClass:[self class]], @""),
                                   @"response":
                                       (result) ? result : [NSNull null],
                                   NSLocalizedRecoverySuggestionErrorKey:
                                       NSLocalizedStringFromTableInBundle(@"Check your handle and password.", @"error", [NSBundle bundleForClass:[self class]], @"")};
        FKAssignError(error, [NSError errorWithDomain:FKErrorDoamin
                                                 code:403
                                             userInfo:userInfo]);
        return NO;
    }
}

- (BOOL)keepAliveWithError:(NSError *__autoreleasing *)error
{
    return YES;
}

- (NSArray *)newsBeforeEpoch:(NSDate *)epoch count:(NSUInteger)count type:(NSString *)type error:(NSError *__autoreleasing *)error
{
    if ([epoch isEqualToDate:[NSDate distantFuture]])
        epoch = [NSDate dateWithTimeIntervalSince1970:-1.0];
    
    NSMutableDictionary *uplinkObject = [@{@"count": @(count),
                                           @"lastT": @(FKTimestampFromNSTimeInterval([epoch timeIntervalSince1970]))} mutableCopy];
    if (type)
        uplinkObject[@"type"] = type;
    NSData *uplinkData = [FKJSONKeyedArchiver archivedDataWithRootObject:uplinkObject];
    
    NSError *err = nil;
    NSData *downlinkData = [self dataWithPostData:uplinkData
                                         toMethod:@"GetWhatzNew"
                                            error:&err];
    
    if (!downlinkData)
    {
        FKAssignError(error, err);
        return nil;
    }
    
    NSArray *result = [FKJSONKeyedUnarchiver unarchiveObjectWithData:downlinkData
                                                                class:[FKNews class]];
    
    if (!result)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:
                                       NSLocalizedStringFromTableInBundle(@"No data returned from news request.", @"error", [NSBundle bundleForClass:[self class]], @""),
                                   NSLocalizedRecoverySuggestionErrorKey:
                                       NSLocalizedStringFromTableInBundle(@"Retry later, or maybe you have depleted all your old messages.", @"error", [NSBundle bundleForClass:[self class]], @"")};
        FKAssignError(error, [NSError errorWithDomain:FKErrorDoamin
                                                 code:404
                                             userInfo:userInfo]);
        return nil;
    }
    return result;
}

- (BOOL)logoutWithError:(NSError *__autoreleasing *)error
{
    NSError *err = nil;
    if ([self dataWithGetFromMethod:@"../logout" error:&err])
    {
        return YES;
    }
    else
    {
        FKAssignError(error, err);
        return NO;
    }
}

- (NSDictionary *)poll:(NSDictionary *)request interval:(NSTimeInterval)interval wait:(NSTimeInterval)wait error:(NSError *__autoreleasing *)error
{
    NSMutableArray *pollData = [NSMutableArray arrayWithCapacity:[request count]];
    for (id key in request)
    {
        NSDictionary *requestItem = request[key];
        NSMutableDictionary *pollItem = [NSMutableDictionary dictionaryWithCapacity:[requestItem count] + 1];
        [pollItem addEntriesFromDictionary:requestItem];
        pollItem[@"t"] = key;
        [pollData addObject:pollItem];
    }
    NSDictionary *uplinkObject = @{@"d": pollData,
                                   @"i": @(FKTimestampFromNSTimeInterval(interval)),
                                   @"w": @(FKTimestampFromNSTimeInterval(wait))};
    NSData *uplinkData = [FKJSONKeyedArchiver archivedDataWithRootObject:uplinkObject];
    
    NSError *err = nil;
    NSData *downlinkData = [self dataWithPostData:uplinkData
                                         toMethod:@"Poll"
                                            error:&err];
    
    if (!downlinkData)
    {
        FKAssignError(error, err);
        return nil;
    }
    
    NSDictionary *result = [FKJSONKeyedUnarchiver unarchiveObjectWithData:downlinkData
                                                                    class:[FKWrapper class]];
    
    if (!result)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:
                                       NSLocalizedStringFromTableInBundle(@"Polling failed.", @"error", [NSBundle bundleForClass:[self class]], @"")};
        FKAssignError(error, [NSError errorWithDomain:FKErrorDoamin
                                                 code:404
                                             userInfo:userInfo]);
        return nil;
    }
    return result;
}

- (NSArray *)searchContact:(NSString *)query inGroup:(NSString *)group page:(NSUInteger)page error:(NSError *__autoreleasing *)error
{
    if (!query)
        query = @"";
    if (!group)
        group = @"";
    NSDictionary *uplinkObject = @{@"query": query,
                                   @"group": group,
                                   @"page": @(page)};
    NSData *uplinkData = [FKJSONKeyedArchiver archivedDataWithRootObject:uplinkObject];
    
    NSError *err = nil;
    NSData *downlinkData = [self dataWithPostData:uplinkData
                                         toMethod:@"GetContactNames"
                                            error:&err];
    
    if (!downlinkData)
    {
        FKAssignError(error, err);
        return nil;
    }
    
    NSArray *result = [FKJSONKeyedUnarchiver unarchiveObjectWithData:downlinkData
                                                               class:[FKUserContact class]];
    
    if (!result)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:
                                       NSLocalizedStringFromTableInBundle(@"No data returned from contact request.", @"error", [NSBundle bundleForClass:[self class]], @""),
                                   NSLocalizedRecoverySuggestionErrorKey:
                                       NSLocalizedStringFromTableInBundle(@"Retry later, or maybe you really need some more friends. Get up and socialize.", @"error", [NSBundle bundleForClass:[self class]], @"")};
        FKAssignError(error, [NSError errorWithDomain:FKErrorDoamin
                                                 code:404
                                             userInfo:userInfo]);
        return nil;
    }
    return result;

}

- (id)bookmark:(id)object readLater:(BOOL)readLater onService:(BOOL)onService inGroup:(id)group withNote:(NSString *)note error:(NSError *__autoreleasing *)error
{
    if ([object isKindOfClass:[FKNews class]])
    {
        FKNews *news = object;
        NSDictionary *uplinkObject = @{@"group": [group length] ? group : @"",
                                       @"id": news.ID,
                                       @"later": readLater ? @"+" : @"-",
                                       @"note": [note length] ? note : @"",
                                       @"svrMark": onService ? @"+" : @"-",
                                       @"type": @"0"};
        NSData *uplinkData = [FKJSONKeyedArchiver archivedDataWithRootObject:uplinkObject];
        
        NSError *err = nil;
        NSData *downlinkData = [self dataWithPostData:uplinkData
                                             toMethod:@"GetContactNames"
                                                error:&err];
        
        if (!downlinkData)
        {
            FKAssignError(error, err);
            return nil;
        }
        
        NSArray *result = [FKJSONKeyedUnarchiver unarchiveObjectWithData:downlinkData];
        
        if (!result)
        {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:
                                           NSLocalizedStringFromTableInBundle(@"No data returned from bookmarking.", @"error", [NSBundle bundleForClass:[self class]], @""),
                                       NSLocalizedRecoverySuggestionErrorKey:
                                           NSLocalizedStringFromTableInBundle(@"Retry later", @"error", [NSBundle bundleForClass:[self class]], @"")};
            FKAssignError(error, [NSError errorWithDomain:FKErrorDoamin
                                                     code:404
                                                 userInfo:userInfo]);
            return nil;
        }
        return result;
    }
    else
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey:
                                       NSLocalizedStringFromTableInBundle(@"Invalid request object.", @"error", [NSBundle bundleForClass:[self class]], @""),
                                   NSLocalizedRecoverySuggestionErrorKey:
                                       NSLocalizedStringFromTableInBundle(@"Check your code implementation.", @"error", [NSBundle bundleForClass:[self class]], @"")};
        FKAssignError(error, [NSError errorWithDomain:FKErrorDoamin
                                                 code:500
                                             userInfo:userInfo]);
        return nil;
    }
}

@end

NSTimeInterval NSTimeIntervalFromFKTimestamp(FKTimestamp timestamp)
{
    return ((NSTimeInterval)timestamp) / 1000.0;
}

FKTimestamp FKTimestampFromNSTimeInterval(NSTimeInterval timeInterval)
{
    return (FKTimestamp)(timeInterval * 1000.0);
}
