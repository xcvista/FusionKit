//
//  FKJSONKeyedArchiver.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-2-22.
//
//

#import "FKJSONKeyedArchiver.h"

@interface FKJSONKeyedArchiver ()

@property NSMutableDictionary *data;

+ (id)JSONObjectForObject:(id)object;

@end

@implementation FKJSONKeyedArchiver

+ (NSData *)archivedDataWithRootObject:(id)rootObject
{
    id JSONObject = [self JSONObjectForObject:rootObject];
    return [NSJSONSerialization dataWithJSONObject:JSONObject
                                           options:0
                                             error:NULL];
}

+ (id)JSONObjectForObject:(id)object
{
    if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]])
    {
        return object;
    }
    else if ([object isKindOfClass:[NSArray class]])
    {
        NSArray *arr = object;
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[arr count]];
        for (id obj in arr)
        {
            [array addObject:[self JSONObjectForObject:obj]];
        }
        return array;
    }
    else if ([object isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = object;
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[dict count]];
        for (id obj in dict)
        {
            dictionary[[self JSONObjectForObject:obj]] = [self JSONObjectForObject:dict[obj]];
        }
        return dictionary;
    }
    else
    {
        id<NSCoding> obj = object;
        FKJSONKeyedArchiver *archiver = [[FKJSONKeyedArchiver alloc] init];
        [obj encodeWithCoder:archiver];
        archiver.data[@"class"] = NSStringFromClass([object class]);
        return archiver.data;
    }
}

- (id)init
{
    if (self = [super init])
    {
        self.data = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL)allowsKeyedCoding
{
    return YES;
}

- (void)encodeObject:(id)objv forKey:(NSString *)key
{
    if ([key compare:@"class"] == NSOrderedSame)
        return;

    if ([objv isKindOfClass:[NSString class]] || [objv isKindOfClass:[NSNumber class]])
    {
        self.data[key] = objv;
    }
    else
    {
        self.data[key] = [[self class] JSONObjectForObject:objv];
    }
}

@end
