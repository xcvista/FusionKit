//
//  FKConnection.h
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-4.
//
//

#import <Foundation/Foundation.h>

@protocol FKConnectionObject <NSCoding, NSObject>

- (NSString *)method;

@end

@interface FKConnection : NSObject

@property NSURL *serverRoot;

- (id)initWithServerRoot:(NSURL *)serverRoot;

- (NSData *)dataWithPostData:(NSData *)data
                    toMethod:(NSString *)method
                       error:(NSError **)error;
- (NSData *)dataWithGetFromMethod:(NSString *)method
                            error:(NSError **)error;

- (NSString *)userAgent;

- (BOOL)loginWithUsername:(NSString *)username
                 password:(NSString *)password
                    error:(NSError **)error;

- (BOOL)keepAliveWithError:(NSError **)error;

- (NSArray *)newsBeforeEpoch:(NSDate *)epoch
                       count:(NSUInteger)count
                        type:(NSString *)type
                       error:(NSError **)error;

- (NSArray *)searchContact:(NSString *)query
                   inGroup:(NSString *)group
                      page:(NSUInteger)page
                     error:(NSError *__autoreleasing *)error;

@end
