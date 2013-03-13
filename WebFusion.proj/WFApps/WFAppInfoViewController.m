//
//  WFAppInfoViewController.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-14.
//
//

#import "WFAppInfoViewController.h"
#import <FusionApps/FusionApps.h>

@interface WFAppInfoViewController ()

@property (weak) IBOutlet NSTextField *categoryField;
@property (weak) IBOutlet NSButton *preferenceButton;
@property (weak) IBOutlet NSButton *unloadButton;
@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSImageView *imageView;

- (IBAction)preferenceButtonPressed:(id)sender;
- (IBAction)unloadButtonPressed:(id)sender;

@end

@interface WFViewController ()

- (BOOL)canUnload;

@end

@implementation WFAppInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
    [self view];
    
    if ([representedObject isKindOfClass:[WFViewController class]])
    {
        WFViewController *controller = representedObject;
        [self.textField setStringValue:[controller appName]];
        [self.categoryField setStringValue:[controller appCategory]];
        [self.imageView setImage:[controller appIcon]];
        [self.unloadButton setHidden:![controller canUnload]];
        [self.preferenceButton setHidden:![controller hasPreferences]];
    }
}

- (void)preferenceButtonPressed:(id)sender
{
    [[self representedObject] showPreferences];
}

- (void)unloadButtonPressed:(id)sender
{
    [[WFAppLoader appLoader] unloadApp:[self representedObject]];
}

@end
