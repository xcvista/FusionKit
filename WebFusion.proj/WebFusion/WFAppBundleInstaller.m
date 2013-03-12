//
//  WFAppBundleInstaller.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-12.
//
//

#import "WFAppBundleInstaller.h"
#import "WFAppLoader.h"

@interface WFAppBundleInstaller ()

@end

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
    NSURL *dest = [localRoot URLByAppendingPathComponent:@"Contents/PlugIns"];
    dest = [dest URLByAppendingPathComponent:[url lastPathComponent]];
    NSAlert *alert = [NSAlert alertWithMessageText:[NSString stringWithFormat:NSLocalizedString(@"Installing %@", @""), [url lastPathComponent]]
                                     defaultButton:NSLocalizedString(@"Yes", @"")
                                   alternateButton:NSLocalizedString(@"No", @"")
                                       otherButton:nil
                         informativeTextWithFormat:NSLocalizedString(@"Apps from untrusted sources may compromise your security and privacy. Are you sure?", @"")];
    if ([alert runModal] == NSAlertDefaultReturn)
    {
        [fileManager copyItemAtURL:url toURL:dest error:nil];
        NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"Install succeed.", @"")
                                defaultButton:NSLocalizedString(@"OK", @"")
                              alternateButton:nil
                                  otherButton:nil
                    informativeTextWithFormat:@""];
        [alert runModal];
        [[WFAppLoader appLoader] loadAppBundle:dest];
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)presentError:(NSError *)error modalForWindow:(NSWindow *)window delegate:(id)delegate didPresentSelector:(SEL)didPresentSelector contextInfo:(void *)contextInfo
{
    NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"Install failed.", @"")
                                     defaultButton:NSLocalizedString(@"OK", @"")
                                   alternateButton:nil
                                       otherButton:nil
                         informativeTextWithFormat:@""];
    [alert runModal];
}

@end
