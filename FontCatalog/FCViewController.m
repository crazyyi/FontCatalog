//
//  FCViewController.m
//  FontCatalog
//
//  Created by Yi Zeng on 8/10/13.
//  Copyright (c) 2013 AFun. All rights reserved.
//

#import "FCViewController.h"
#import "FCMenuViewController.h"

@interface FCViewController ()
@property (nonatomic, strong) FCMenuViewController *vc;
@end

@implementation FCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect tableViewFrame = self.fontTableView.frame;
    tableViewFrame.origin.y += 20;
    self.fontTableView.frame = tableViewFrame;
    
    [self familyNamesInDefaultOrder];
    
    self.fontTableView.dataSource = self;
    self.fontTableView.delegate = self;
    
    [_sortingControl setImage:[UIImage imageNamed:@"text-align-left.png"] forSegmentAtIndex:0];
    [_sortingControl setImage:[UIImage imageNamed:@"text-align-right.png"] forSegmentAtIndex:1];
    
    _sortingControl.selectedSegmentIndex = 0;
    
    [_sortingControl addTarget:self action:@selector(alignCells:) forControlEvents:UIControlEventValueChanged];
    
    isLeftAlignOn = TRUE; // default text alignment is left;
    
    // Swipe actions
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftAction:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightAction:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
    _vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FCMenuViewController"];
    [_vc.view setFrame:CGRectMake(-320, self.view.frame.origin.y, _vc.view.frame.size.width, _vc.view.frame.size.height)];
    [self addChildViewController:self.vc];
    [self.view addSubview:self.vc.view];
}

- (void)alignCells:(id)sender
{
    UISegmentedControl *segmentController = (UISegmentedControl *)sender;
    NSInteger index = segmentController.selectedSegmentIndex;
    
    if (index == 1) {
        isLeftAlignOn = FALSE;
    } else {
        isLeftAlignOn = TRUE;
    }
    
    [self.fontTableView reloadData];
}

#pragma mark - UITableViewDelegate
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [familyNames removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellName = @"fontCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    NSString *familyName = [familyNames objectAtIndex:[indexPath row]];
    UIFont *font = [UIFont fontWithName:familyName size:15];
    
    if (_vc.isBackwardsOn) {
        familyName = [self reverseFontName:familyName];
    }
    
    cell.textLabel.text = familyName;
    cell.textLabel.font = font;
    
    if (isLeftAlignOn) {
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    } else {
        cell.textLabel.textAlignment = NSTextAlignmentRight;
    }
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [familyNames count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - animations -
- (void)showMenu
{

    [self.vc didMoveToParentViewController:self];
    
    [UIView animateWithDuration:0.7 animations:^{
        
        [self.view setFrame:CGRectMake(180, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGRect frame = self.vc.view.frame;
        frame.origin.x = -210;
        self.vc.view.frame = frame;
    }];
}

- (void)hideMenu
{
    [UIView animateWithDuration:0.7 animations:^{
        [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGRect frame = self.vc.view.frame;
        frame.origin.x = -320;
        self.vc.view.frame = frame;
    }];
    
}

- (NSString *)reverseFontName:(NSString *)fontName
{
    NSMutableString *returnString = [[NSMutableString alloc] initWithCapacity:fontName.length];
    NSInteger currentCharIndex = fontName.length;
    
    while (currentCharIndex > 0) {
        currentCharIndex--;
        NSRange subString = NSMakeRange(currentCharIndex, 1);
        [returnString appendString:[fontName substringWithRange:subString]];
    }
    
    return returnString;
}

- (void)familyNamesInDefaultOrder
{
    familyNames = [[NSMutableArray alloc] initWithArray:[[UIFont familyNames] sortedArrayUsingSelector:@selector(compare:)]];
}

- (CGFloat)widthOfString:(NSString *)string withFont:(UIFont *)font {
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    return [[[NSAttributedString alloc] initWithString:string attributes:attributes] size].width;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)resetButtonPressed:(id)sender {
    _sortingControl.selectedSegmentIndex = 0;
    isLeftAlignOn = TRUE; // default text alignment is left;
    _vc.isBackwardsOn = FALSE;
    _vc.isReverseOn = FALSE;
    [_vc resetTableView];
    [self familyNamesInDefaultOrder];
    [self.fontTableView reloadData];
}

- (IBAction)settingsButtonPressed:(id)sender {
    if (self.view.frame.origin.x == 0) {
        [self showMenu];
    } else {
        [self hideMenu];
    }
}

- (IBAction)editButtonPressed:(id)sender {
    UIBarButtonItem *button = (UIBarButtonItem *)sender;
    if (self.fontTableView.isEditing) {
        [self setEditing:NO animated:YES];
        button.title = @"Edit";
    } else {
        [self setEditing:YES animated:YES];
        button.title = @"Done";
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:YES];
    [self.fontTableView setEditing:editing animated:YES];
}

- (void)swipeLeftAction:(UIGestureRecognizer *)recognizer
{
    if (self.view.frame.origin.x != 0) {
        [self hideMenu];
    }
}

- (void)swipeRightAction:(UIGestureRecognizer *)recognizer
{
    if (self.view.frame.origin.x == 0) {
        [self showMenu];
    }
}

- (void)sortFontFamilyNames:(NSInteger)index
{
    NSLog(@"Selected index %d", index);
    if (self.vc.isReverseOn) {
        familyNames = [[NSMutableArray alloc] initWithArray:[[familyNames reverseObjectEnumerator] allObjects]];
    } else {
        switch (index) {
            case 0:
                if (self.vc.isReverseOn) {
                    familyNames = [[NSMutableArray alloc] initWithArray:[[[familyNames sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] reverseObjectEnumerator] allObjects]];
                } else {
                    [self familyNamesInDefaultOrder];
                }
                break;
            case 1:
                familyNames = [self sortFontFamilyNamesByCharacterCount];
                break;
            case 2:
                familyNames = [self sortFontFamilyNamesByDisplaySize];
            default:
                break;
        }

    }
    
    [self.fontTableView reloadData];
}

- (NSMutableArray *)sortFontFamilyNamesByCharacterCount
{
    return [[NSMutableArray alloc] initWithArray:[familyNames sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        
        if (str1.length < str2.length) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if (str1.length > str2.length) {
            return (NSComparisonResult)NSOrderedDescending;
        } else {
            return (NSComparisonResult)NSOrderedSame;
        }
    }]];
}

- (NSMutableArray *)sortFontFamilyNamesByDisplaySize
{
    return [[NSMutableArray alloc] initWithArray:[familyNames sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *str1 = (NSString *)obj1;
        NSString *str2 = (NSString *)obj2;
        
        CGSize fontSize1 = [str1 sizeWithFont:[UIFont fontWithName:str1 size:15]];
        CGSize fontSize2 = [str1 sizeWithFont:[UIFont fontWithName:str2 size:15]];
        
        if (fontSize1.width < fontSize2.width) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if (fontSize1.width > fontSize2.width) {
            return (NSComparisonResult)NSOrderedDescending;
        } else {
            return (NSComparisonResult)NSOrderedSame;
        }
    }]];
}

@end
