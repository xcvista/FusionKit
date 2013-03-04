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

- (NSData *)dataWithPostData:(NSData *)data toMethod:(NSString *)method error:(NSError **)error;
- (NSData *)dataWithObject:(id<FKConnectionObject>)object error:(NSError **)error;
- (id)objectWithObject:(id<FKConnectionObject>)object class:(Class)class error:(NSError **)error;

- (BOOL)loginWithUsername:(NSString *)username password:(NSString *)password error:(NSError **)error;
- (void)keepAlive;

@end
