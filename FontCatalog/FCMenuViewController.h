//
//  FCMenuViewController.h
//  FontCatalog
//
//  Created by Yi Zeng on 9/10/13.
//  Copyright (c) 2013 AFun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FCViewController;

@interface FCMenuViewController : UITableViewController
{
    FCViewController *vc;
}


- (IBAction)reverseToggle:(id)sender;
- (IBAction)backwardsToggle:(id)sender;
- (void)resetTableView;
@property (nonatomic) BOOL isBackwardsOn;
@property (nonatomic) BOOL isReverseOn;
@property (nonatomic) NSInteger selectedRow;
@property (weak, nonatomic) IBOutlet UISwitch *reverseSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *backwardsSwitch;

@end
