//
//  FKJSONKeyedUnarchiver.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-4.
//
//

#import "FKJSONKeyedUnarchiver.h"

@interface FKJSONKeyedUnarchiver ()

@property NSDictionary *plist;

@end

@implementation FKJSONKeyedUnarchiver

+ (id)unarchiveObjectWithData:(NSData *)data
{
    id plist = [NSJSONSerialization JSONObjectWithData:data
                                               options:0
                                                 error:NULL];
    return [self objectFromPlist:plist];
}

+ (id)unarchiveObjectWithData:(NSData *)data class:(Class)class
{
    id plist = [NSJSONSerialization JSONObjectWithData:data
                                               options:0
                                                 error:NULL];
    return [self objectFromPlist:plist class:class];
}

+ (id)objectFromPlist:(id)plist
{
    if ([plist isKindOfClass:[NSArray class]])
    {
        NSArray *source = plist;
        NSMutableArray *output = [NSMutableArray arrayWithCapacity:[source count]];
        for (id object in source)
            [output addObject:[self objectFromPlist:object]];
        return output;
    }
    else if ([plist isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *source = plist;
        Class class = NSClassFromString(source[@"class"]);
        if (class)
        {
            FKJSONKeyedUnarchiver *unarchiver = [[FKJSONKeyedUnarchiver alloc] initWithPlist:source];
            id object = [[class alloc] initWithCoder:unarchiver];
            return object;
        }
        else
        {
            NSMutableDictionary *output = [NSMutableDictionary dictionaryWithCapacity:[source count]];
            for (id key in source)
            {
                id okey = [self objectFromPlist:key];
                id oval = [self objectFromPlist:source[key]];
                output[okey] = oval;
                return output;
            }
        }
    }
    return plist;
}

+ (id)objectFromPlist:(id)plist class:(Class)class
{
    if ([plist isKindOfClass:[NSDictionary class]])
    {
        FKJSONKeyedUnarchiver *unarchiver = (__bridge FKJSONKeyedUnarchiver *)(CFRetain((__bridge CFTypeRef)([[FKJSONKeyedUnarchiver alloc] initWithPlist:plist])));
        id object = [[class alloc] initWithCoder:unarchiver];
        return object;
    }
    else if ([plist isKindOfClass:[NSArray class]])
    {
        NSArray *source = plist;
        NSMutableArray *output = [NSMutableArray arrayWithCapacity:[source count]];
        for (id object in source)
            [output addObject:[self objectFromPlist:object class:class]];
        return output;
    }
    else
        return plist;
}

- (id)initWithPlist:(NSDictionary *)plist
{
    if (self = [super init])
    {
        self.plist = plist;
    }
    return self;
}

- (id)decodeObjectForKey:(NSString *)key
{
    return [[self class] objectFromPlist:self.plist[key]];
}

- (id)decodeObjectOfClass:(Class)class forKey:(NSString *)key
{
    return [[self class] objectFromPlist:self.plist[key]
                                   class:class];
}

@end
