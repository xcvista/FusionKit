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
    NSString *localRoot = [[NSBundle mainBundle] bundlePath];
    NSString *integratedRoot = [localRoot stringByAppendingPathComponent:@"Contents/PlugIns"];
    NSURL *dest = [NSURL URLWithString:[NSString stringWithFormat:@"file://localhost%@", integratedRoot]];
    // TODO: Install at somewhere else: [[fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask][0] URLByAppendingPathComponent:[NSString stringWithFormat:@"PlugIns/%@", [[NSBundle mainBundle] bundleIdentifier]]];
    dest = [dest URLByAppendingPathComponent:[url lastPathComponent]];
    NSAlert *alert = [NSAlert alertWithMessageText:[NSString stringWithFormat:NSLocalizedString(@"Installing %@", @""), [url lastPathComponent]]
                                     defaultButton:NSLocalizedString(@"Yes", @"")
                                   alternateButton:NSLocalizedString(@"No", @"")
                                       otherButton:nil
                         informativeTextWithFormat:NSLocalizedString(@"Apps from untrusted sources may compromise your security and privacy. Are you sure?", @"")];
    if ([alert runModal] == NSAlertDefaultReturn)
    {
        [fileManager createDirectoryAtURL:dest
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:NULL];
        [fileManager copyItemAtURL:url toURL:dest error:nil];
        NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"Install succeed.", @"")
                                defaultButton:NSLocalizedString(@"OK", @"")
                              alternateButton:nil
                                  otherButton:nil
                    informativeTextWithFormat:@""];
        [alert runModal];
        [[WFAppLoader appLoader] loadAppBundle:dest];
    }
    [[NSDocumentController sharedDocumentController] clearRecentDocuments:self];
    return YES;
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
