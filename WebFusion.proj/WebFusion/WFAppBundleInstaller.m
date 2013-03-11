//
//  WFAppBundleInstaller.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-12.
//
//

#import "WFAppBundleInstaller.h"

@implementation WFAppBundleInstaller

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    NSBundle *bundle = [NSBundle bundleWithURL:url];
    if (!bundle)
        return NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *localRoot = [[NSBundle mainBundle] bundleURL];
    NSURL *dest = [localRoot URLByAppendingPathComponent:@"Contents/Bundles"];
    dest = [dest URLByAppendingPathComponent:[url lastPathComponent]];
    [fileManager copyItemAtURL:url toURL:dest error:nil];
    return YES;
}

@end
