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
    switch ([self.segmentedControl selectedSegment])
    {
        case 0:
        {
            [self.collectionView setContent:@[]];
            break;
        }
        case 1:
        {
            NSArray *modules = [[[WFAppLoader appLoader] loadedApps] sortedArrayUsingSelector:@selector(compare:)];
            if ([[self.searchField stringValue] length])
            {
                NSString *keyword = [self.searchField stringValue];
                NSMutableArray *tmp = [NSMutableArray arrayWithCapacity:[modules count]];
                for (WFViewController *app in modules)
                {
                    NSArray *keys = @[[app appName], [app longAppName], [app appCategory], [[app appBundle] bundleIdentifier]];
                    BOOL check = NO;
                    for (NSString *key in keys)
                        if ([key rangeOfString:keyword
                                       options:NSDiacriticInsensitiveSearch | NSCaseInsensitiveSearch].location != NSNotFound)
                        {
                            check = YES;
                            break;
                        }
                    if (check)
                        [tmp addObject:app];
                }
                modules = tmp;
            }
            [self.collectionView setContent:modules];
            break;
        }
        case 2:
        {
            [self.collectionView setContent:@[]];
            break;
        }
    }
}

@end
