//
//  WFContactNameViewController.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-13.
//
//

#import "WFContactNameViewController.h"
#import <FusionApps/FusionApps.h>
#import "NSData+Cache.h"

@interface WFContactNameViewController ()

@property (weak) IBOutlet NSImageView *avaratWell;
@property (weak) IBOutlet NSTextField *nameField;
@property (weak) IBOutlet NSTextField *serviceField;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

- (IBAction)infoButton:(id)sender;

@end

@implementation WFContactNameViewController

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
    if (![representedObject isKindOfClass:[FKUserContact class]])
        return;
    FKUserContact *userContact = representedObject;
    [self.nameField setStringValue:userContact.name];
    [self.serviceField setStringValue:@""];
    [self.progressIndicator startAnimation:self];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       NSData *data = [NSData cachedDataAtURL:userContact.avatar.avatar];
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          if (data)
                                              [self.avaratWell setImage:[[NSImage alloc] initWithData:data]];
                                          [self.progressIndicator stopAnimation:self];
                                      });
                   });
}

- (void)infoButton:(id)sender
{
    // TODO: Design the Info page.
}

@end
