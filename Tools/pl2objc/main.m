//
//  main.m
//  pl2objc
//
//  Created by Maxthon Chan on 13-4-1.
//
//

#import "main.h"
#import "help.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        NSArray *args = [[NSProcessInfo processInfo] arguments];
        NSMutableDictionary *inputFile = [NSMutableArray array];
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
                        outputFile = args[i];
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
                        outputHeader = args[i];
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
                NSData *inputData = [NSData dataWithContentsOfFile:arg];
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
                    eprintf("WARNING: Cannot parse file %s as property list.\n");
                }
            }
        }
        
    }
    return 0;
}

