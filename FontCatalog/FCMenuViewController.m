//
//  FCMenuViewController.m
//  FontCatalog
//
//  Created by Yi Zeng on 9/10/13.
//  Copyright (c) 2013 AFun. All rights reserved.
//

#import "FCMenuViewController.h"
#import "FCViewController.h"

@interface FCMenuViewController ()

@end

@implementation FCMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isReverseOn = FALSE;
        _isBackwardsOn = FALSE;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    vc = (FCViewController *)self.parentViewController;
    
    if (_isBackwardsOn) {
        [self.backwardsSwitch setOn:TRUE];
    } else {
        [self.backwardsSwitch setOn:FALSE];
    }
    
    if (_isReverseOn) {
        [self.reverseSwitch setOn:TRUE];
    } else {
        [self.reverseSwitch setOn:FALSE];
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        for (UITableViewCell *cell in self.tableView.visibleCells) {
            NSIndexPath *currentIndexPath = [self.tableView indexPathForCell:cell];
            [self.tableView cellForRowAtIndexPath:currentIndexPath].accessoryType = UITableViewCellAccessoryNone;
        }
        
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        self.selectedRow = [indexPath row];
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"You have selected %d", indexPath.row);

    if (indexPath.section == 0) {
        [vc sortFontFamilyNames:indexPath.row];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reverseToggle:(id)sender {
    UISwitch *toggle = (UISwitch *)sender;
    if (toggle.isOn) {
        self.isReverseOn = TRUE;
    } else {
        self.isReverseOn = FALSE;
    }

    [vc sortFontFamilyNames:self.selectedRow];

}

- (IBAction)backwardsToggle:(id)sender {
    UISwitch *toggle = (UISwitch *)sender;
    if (toggle.isOn) {
        self.isBackwardsOn = TRUE;
    } else {
        self.isBackwardsOn = FALSE;
    }
    
    
    [vc.fontTableView reloadData];
}

- (void)resetTableView
{
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        NSIndexPath *currentIndexPath = [self.tableView indexPathForCell:cell];
        
        if (currentIndexPath.section == 0) {
            if (currentIndexPath.row == 0) {
                [self.tableView cellForRowAtIndexPath:currentIndexPath].accessoryType = UITableViewCellAccessoryCheckmark;
            } else {
                [self.tableView cellForRowAtIndexPath:currentIndexPath].accessoryType = UITableViewCellAccessoryNone;
            }
        }
        
    }
    
    [self.tableView reloadData];
}
@end
