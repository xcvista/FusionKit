//
//  WFNewsViewController.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-5.
//
//

#import "WFNewsViewController.h"
#import "WFAppDelegate.h"
//#import <FusionBinding/FusionBinding.h>
#import <objc/message.h>

@interface WFNewsViewController ()

@property (weak) IBOutlet NSCollectionView *collectionView;
@property (weak) IBOutlet NSScroller *vertivalScroller;

@property (weak) id oldTarget;
@property SEL oldAction;

- (IBAction)scrollerChanged:(id)sender;

@end

@implementation WFNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)awakeFromNib
{
    self.oldTarget = self.vertivalScroller.target;
    self.oldAction = self.vertivalScroller.action;
    
    self.vertivalScroller.target = self;
    self.vertivalScroller.action = @selector(scrollerChanged:);
    
    NSError *err;
    WFAppDelegate *appDelegate = [NSApp delegate];
    NSArray *news = [appDelegate.connection newsBeforeEpoch:[NSDate distantFuture]
                                                      count:50
                                                       type:nil
                                                      error:&err];
    
    if (!news)
    {
        NSAlert *alert = [NSAlert alertWithError:err];
        [alert beginSheetModalForWindow:[appDelegate.rootWindowController window]
                          modalDelegate:nil
                         didEndSelector:nil
                            contextInfo:nil];
        [NSApp terminate:self];
    }
    
    [self.collectionView setContent:news];
}

- (void)scrollerChanged:(id)sender
{
    [self.oldTarget performSelector:self.oldAction withObject:sender]; //Redispatch it.
    
    if ([self.vertivalScroller doubleValue] > 0.99)
    {
        static BOOL RUNNING;
        WFAppDelegate *appDelegate = [NSApp delegate];
        NSMutableArray *currentObjects = [[self.collectionView content] mutableCopy];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                       ^{
                           if (RUNNING)
                               return;
                           
                           RUNNING = YES;
                           NSError *err;
                           NSArray *news = [appDelegate.connection newsBeforeEpoch:[[currentObjects lastObject] publishDate]
                                                                             count:50
                                                                              type:nil
                                                                             error:&err];
                           dispatch_async(dispatch_get_main_queue(),
                                          ^{
                                              
                                              if (!news)
                                              {
                                                  NSAlert *alert = [NSAlert alertWithError:err];
                                                  [alert beginSheetModalForWindow:[appDelegate.rootWindowController window]
                                                                    modalDelegate:nil
                                                                   didEndSelector:nil
                                                                      contextInfo:nil];
                                                  [NSApp terminate:self];
                                              }
                                              
                                              [currentObjects addObjectsFromArray:news];
                                              
                                              [self.collectionView setContent:currentObjects];
                                              
                                              RUNNING = NO;
                                          });
                       });
        
        
    }
}

@end
