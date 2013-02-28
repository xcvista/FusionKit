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

@end

@implementation FKJSONKeyedArchiver

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
    
    NSString *class = NSStringFromClass([objv class]);
    if ([(NSArray *)@[@"NSString", @"NSNumber"] indexOfObject:class] != NSNotFound)
    {
        // Basic JSON objects
        self.data[key] = objv;
    }
}



@end
