//
//  FCViewController.h
//  FontCatalog
//
//  Created by Yi Zeng on 8/10/13.
//  Copyright (c) 2013 AFun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *familyNames;
    BOOL isLeftAlignOn;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortingControl;
@property (weak, nonatomic) IBOutlet UITableView *fontTableView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *settingsButton;
- (IBAction)resetButtonPressed:(id)sender;

- (IBAction)settingsButtonPressed:(id)sender;
- (IBAction)editButtonPressed:(id)sender;

- (void)sortFontFamilyNames:(NSInteger)index;
@end
