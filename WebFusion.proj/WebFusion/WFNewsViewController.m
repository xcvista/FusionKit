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
@property (weak) IBOutlet NSScrollView *scrollView;

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

- (void)reload:(id)sender
{
    static BOOL RUNNING;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^{
                       if (RUNNING)
                           return;
                       RUNNING = YES;
                       
                       NSError *err;
                       WFAppDelegate *appDelegate = [NSApp delegate];
                       
                       NSArray *news = [appDelegate.connection newsBeforeEpoch:[NSDate distantFuture]
                                                                         count:25
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
                                          
                                          [self.collectionView setContent:news];
                                          RUNNING = NO;
                                      });
                       
                   });
}

- (void)awakeFromNib
{
    self.oldTarget = self.vertivalScroller.target;
    self.oldAction = self.vertivalScroller.action;
    
    self.vertivalScroller.target = self;
    self.vertivalScroller.action = @selector(scrollerChanged:);
    
    [self reload:self];
}

- (void)scrollerChanged:(id)sender
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self.oldTarget performSelector:self.oldAction withObject:sender]; //Redispatch it.
#pragma clang diagnostic pop
    
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
                                                                             count:25
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
                                              
                                              if ([self.scrollView respondsToSelector:@selector(flashScrollers)])
                                                  [self.scrollView flashScrollers];
                                              
                                              RUNNING = NO;
                                          });
                       });
        
        
    }
}

@end
