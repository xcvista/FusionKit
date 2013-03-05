//
//  WFNewsCollectionView.m
//  FusionKit.C
//
//  Created by Maxthon Chan on 13-3-5.
//
//

#import "WFNewsCollectionView.h"
#import "WFNewsItemViewController.h"

@implementation WFNewsCollectionView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSCollectionViewItem *)newItemForRepresentedObject:(id)object
{
    NSLog(@"Setting up view with object %@", object);
    WFNewsItemViewController *itemVC = [[WFNewsItemViewController alloc] init];
    [itemVC setRepresentedObject:object];
    [itemVC view];
    return itemVC;
}

@end
