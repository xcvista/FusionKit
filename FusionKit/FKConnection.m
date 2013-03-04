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

@implementation FKConnection

- (id)initWithServerRoot:(NSURL *)serverRoot
{
    if (self = [super init])
    {
        self.serverRoot = serverRoot;
    }
    return self;
}

- (NSData *)dataWithObject:(id<FKConnectionObject>)object
{
    return [self dataWithPostData:[FKJSONKeyedArchiver archivedDataWithRootObject:object]
                         toMethod:[object method]];
}

- (id)objectWithObject:(id<FKConnectionObject>)object class:(Class)class
{
    return [FKJSONKeyedUnarchiver unarchiveObjectWithData:[self dataWithObject:object]
                                                    class:class];
}

- (NSData *)dataWithPostData:(NSData *)data toMethod:(NSString *)method
{
    NSURL *methodURL = [NSURL URLWithString:method relativeToURL:self.serverRoot];
    
}

@end
