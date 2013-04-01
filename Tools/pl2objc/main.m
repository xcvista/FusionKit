//
//  main.m
//  pl2objc
//
//  Created by Maxthon Chan on 13-4-1.
//
//

#import "main.h"
#import "help.h"
#import "NSString+pl2objc.h"
#import "NSString+Sanitize.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        NSArray *args = [[NSProcessInfo processInfo] arguments];
        NSMutableDictionary *inputFile = [NSMutableDictionary dictionary];
        NSMutableArray *includes = [NSMutableArray array];
        NSString *outputFile = nil;
        NSString *outputHeader = nil;
        NSString *prefix = nil;
        NSString *className = nil;
        plType type = plFunction;
        
        for (NSUInteger i = 1; i < [args count]; i++)
        {
            NSString *arg = [args[i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if ([arg hasPrefix:@"-"]) // Switch
            {
                if ([@[@"-o", @"--output"] containsObject:arg]) // Output File
                {
                    if (++i < [args count])
                    {
                        outputFile = [args[i] stringByExpandingTildeInPath];
                        continue;
                    }
                    else
                    {
                        eprintfc(1, "Too few arguments.\n");
                    }
                }
                else if ([@[@"-h", @"--header"] containsObject:arg])
                {
                    if (++i < [args count])
                    {
                        outputHeader = [args[i] stringByExpandingTildeInPath];
                        continue;
                    }
                    else
                    {
                        eprintfc(1, "Too few arguments.\n");
                    }
                }
                else if ([@[@"-p", @"--prefix"] containsObject:arg])
                {
                    if (++i < [args count])
                    {
                        prefix = args[i];
                        continue;
                    }
                    else
                    {
                        eprintfc(1, "Too few arguments.\n");
                    }
                }
                else if ([@[@"-c", @"--class"] containsObject:arg])
                {
                    if (++i < [args count])
                    {
                        className = args[i];
                        continue;
                    }
                    else
                    {
                        eprintfc(1, "Too few arguments.\n");
                    }
                }
                else if ([@[@"-i", @"--include"] containsObject:arg])
                {
                    if (++i < [args count])
                    {
                        [includes addObject:args[i]];
                        continue;
                    }
                    else
                    {
                        eprintfc(1, "Too few arguments.\n");
                    }
                }
                else if ([@[@"-t", @"--type"] containsObject:arg])
                {
                    if (++i < [args count])
                    {
                        NSString *typeString = args[i];
                        NSArray *validypes = @[@"function", @"class", @"category", @"const"];
                        if ((type = [validypes indexOfObject:typeString]) == NSNotFound)
                        {
                            eprintfc(1, "Invalid object type: %s\n", [typeString cStringUsingEncoding:[NSString defaultCStringEncoding]]);
                        }
                        continue;
                    }
                    else
                    {
                        eprintfc(1, "Too few arguments.\n");
                    }
                }
                else if ([arg isEqualToString:@"--help"])
                {
                    showHelp(YES);
                }
                else if ([arg isEqualToString:@"--version"])
                {
                    showAbout(YES);
                }
                else
                {
                    eprintf("WARNING: Unrecognized switch: %s\n", [arg cStringUsingEncoding:[NSString defaultCStringEncoding]]);
                }
            } // Switches
            else // Inputs
            {
                NSString *name = [arg hasSuffix:@".plist"] ? [arg stringByDeletingPathExtension] : arg;
                name = [name lastPathComponent];
                NSData *inputData = [NSData dataWithContentsOfFile:[arg stringByExpandingTildeInPath]];
                if (!inputData)
                {
                    eprintf("WARNING: Cannot open file: %s\n", [arg cStringUsingEncoding:[NSString defaultCStringEncoding]]);
                    continue;
                }
                NSError *error;
                id plist = [NSPropertyListSerialization propertyListWithData:inputData
                                                                     options:0
                                                                      format:NULL
                                                                       error:&error];
                if (!plist)
                {
                    eprintf("WARNING: Cannot parse file %s as property list.\n", [arg cStringUsingEncoding:[NSString defaultCStringEncoding]]);
                    continue;
                }
                inputFile[name] = plist;
            }
        }
        
        if (![inputFile count] || ![outputFile length])
        {
            eprintf("ERROR: No input or output file indicated.\n\n");
            showHelp(YES);
        }
        
        if (![outputHeader length])
            outputHeader = [[outputFile stringByDeletingPathExtension] stringByAppendingPathExtension:@"h"];
        if (![prefix length])
            prefix = @"";
        
        NSMutableString *header = [NSMutableString stringWithString:@"#import <Foundation/Foundation.h>\n"];
        NSMutableString *content = [NSMutableString stringWithFormat:@"#import \"%@\"\n\n", outputHeader];
        
        for (NSString *string in includes)
        {
            [header appendFormat:@"#import \"%@\"\n", string];
        }
        
        [header appendString:@"\n#if defined(__cplusplus)\n"
         "extern \"C\" {\n"
         "#endif\n\n"];
        
        switch (type)
        {
            case plFunction:
            {
                for (NSString *key in inputFile)
                {
                    NSString *symbol = [key symbolizedString];
                    NSString *symbolType = @"id";
                    id object = inputFile[key];
                    if ([object isKindOfClass:[NSArray class]])
                        symbolType = @"NSArray *";
                    else if ([object isKindOfClass:[NSDictionary class]])
                        symbolType = @"NSDictionary *";
                    else if ([object isKindOfClass:[NSString class]])
                        symbolType = @"NSString *";
                    
                    [header appendFormat:@"%@ %@%@(void);\n", symbolType, prefix, symbol];
                    [content appendFormat:@"%@ %@%@(void) { return %@; }\n", symbolType, prefix, symbol, [object sourceRepresentation]];
                }
                break;
            }
            case plClassMethod:
            {
                if (![className length])
                    className = [outputHeader symbolizedString];
                else
                    className = [className symbolizedString];
                
                [header appendFormat:@"@interface %@%@ : NSObject\n\n", prefix, className];
                [content appendFormat:@"@implementation %@%@\n\n", prefix, className];
                
                for (NSString *key in inputFile)
                {
                    NSString *symbol = [key symbolizedString];
                    NSString *symbolType = @"id";
                    id object = inputFile[key];
                    if ([object isKindOfClass:[NSArray class]])
                        symbolType = @"NSArray *";
                    else if ([object isKindOfClass:[NSDictionary class]])
                        symbolType = @"NSDictionary *";
                    else if ([object isKindOfClass:[NSString class]])
                        symbolType = @"NSString *";
                    
                    [header appendFormat:@"+ (%@)%@;\n", symbolType, symbol];
                    [content appendFormat:@"+ (%@)%@ { return %@; }\n", symbolType, symbol, [object sourceRepresentation]];
                }
                
                [header appendString:@"\n@end\n"];
                [content appendString:@"\n@end\n"];
                break;
            }
            case plCategoryMethod:
            {
                eprintf("WARNING: You must modify the category header file to make it work.\n");
                
                if (![className length])
                    className = @"NSObject";
                else
                    className = [className symbolizedString];
                
                [header appendFormat:@"@interface %@ (%@)\n\n", className, [outputHeader symbolizedString]];
                [content appendFormat:@"@implementation %@ (%@)\n\n", className, [outputHeader symbolizedString]];
                
                for (NSString *key in inputFile)
                {
                    NSString *symbol = [key symbolizedString];
                    NSString *symbolType = @"id";
                    id object = inputFile[key];
                    if ([object isKindOfClass:[NSArray class]])
                        symbolType = @"NSArray *";
                    else if ([object isKindOfClass:[NSDictionary class]])
                        symbolType = @"NSDictionary *";
                    else if ([object isKindOfClass:[NSString class]])
                        symbolType = @"NSString *";
                    
                    [header appendFormat:@"+ (%@)%@;\n", symbolType, symbol];
                    [content appendFormat:@"+ (%@)%@ { return %@; }\n", symbolType, symbol, [object sourceRepresentation]];
                }
                
                [header appendString:@"\n@end\n"];
                [content appendString:@"\n@end\n"];
                break;
            }
            case plSymbolizedConsants:
            {
                for (NSString *key in inputFile)
                {
                    NSDictionary *object = inputFile[key];
                    if (![object isKindOfClass:[NSDictionary class]])
                    {
                        eprintf("ERROR: File %s connot be processed.", [key cStringUsingEncoding:[NSString defaultCStringEncoding]]);
                        continue;
                    }
                    
                    for (NSString *key in object)
                    {
                        if (![key isKindOfClass:[NSString class]])
                        {
                            eprintf("ERROR: Key %s connot be processed.", [[key description] cStringUsingEncoding:[NSString defaultCStringEncoding]]);
                            continue;
                        }
                        NSString *symbol = [key symbolizedString];
                        NSString *symbolType = @"id";
                        id object2 = object[key];
                        
                        if ([object2 isKindOfClass:[NSArray class]])
                            symbolType = @"NSArray *";
                        else if ([object2 isKindOfClass:[NSDictionary class]])
                            symbolType = @"NSDictionary *";
                        else if ([object2 isKindOfClass:[NSString class]])
                            symbolType = @"NSString *";
                        
                        [header appendFormat:@"%@ __%@%@(void);\n", symbolType, prefix, symbol];
                        [header appendFormat:@"#define %@%@ __%@%@()\n", prefix, symbol, prefix, symbol];
                        [content appendFormat:@"%@ __%@%@(void) { return %@; }\n", symbolType, prefix, symbol, [object2 sourceRepresentation]];
                    }
                }
                break;
            }
        }
        
        [header appendString:@"\n#if defined(__cplusplus)\n"
         "}\n"
         "#endif\n"];
        
        [content writeToFile:outputFile
                  atomically:YES
                    encoding:NSUTF8StringEncoding
                       error:NULL];
        [header writeToFile:outputHeader
                 atomically:YES
                   encoding:NSUTF8StringEncoding
                      error:NULL];
    }
    return 0;
}

