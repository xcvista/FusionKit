//
//  WFAppCatalog.m
//  WebFusion
//
//  Created by Maxthon Chan on 13-3-13.
//
//

#import "WFAppCatalog.h"

@interface WFAppCatalog ()

@property (weak) IBOutlet NSCollectionView *collectionView;
@property (weak) IBOutlet NSSegmentedControl *segmentedControl;
@property (weak) IBOutlet NSSearchField *searchField;

-(IBAction)reload:(id)sender;

@end

@implementation WFAppCatalog

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSInteger)sortOrder
{
    return 5;
}

- (BOOL)canUnload
{
    return NO;
}

- (void)viewWillAppear
{
    [super viewWillAppear];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reload:)
                                                 name:WFAppLoaderLoadedBundleNotification
                                               object:nil];
    
    [self reload:self];
}

- (void)reload:(id)sender
{
    switch ([self.segmentedControl integerValue])
    {
        case 0:
        {
            [self.searchField setEnabled:YES];
            [self.collectionView setContent:@[]];
            break;
        }
        case 1:
        {
            [self.searchField setEnabled:NO];
            NSArray *modules = [[[WFAppLoader appLoader] loadedApps] sortedArrayUsingSelector:@selector(compare:)];
            [self.collectionView setContent:modules];
        }
        case 2:
        {
            [self.searchField setEnabled:YES];
            [self.collectionView setContent:@[]];
            break;
        }
    }
}

@end
