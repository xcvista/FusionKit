//
//  main.h
//  Tools
//
//  Created by Maxthon Chan on 13-4-1.
//
//

#ifndef Tools_main_h
#define Tools_main_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, plType)
{
    plFunction,
    plClassMethod,
    plCategoryMethod,
    plSymbolizedConsants
};

#define eprintf(format, ...) fprintf(stderr, format, ##__VA_ARGS__)
#define eprintfc(return, format, ...) do { eprintf(format, ##__VA_ARGS__); exit(return); } while(0)

int main(int argc, const char * argv[]);

#endif
