//
//  GRTMainViewController.m
//  Greatist Message Publisher
//
//  Created by Elizabeth Choy on 4/2/14.
//  Copyright (c) 2014 Ezekiel Abuhoff. All rights reserved.
//

#import "GRTMainViewController.h"
#import "GRTFacebookLoginViewController.h"
#import "GRTPostDetailViewController.h"
#import "GRTComposePostViewController.h"
#import "GRTPostTableViewCell.h"
#import "GRTDataStore.h"
#import "Post+Methods.h"
#import "Section+Methods.h"
#import "GRTFacebookAPIClient.h"
#import "GRTCornerTriangles.h"
#import "UIColor+Helpers.h"


@interface GRTMainViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *composePostButton;
- (IBAction)composePostButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *postsTableView;
@property (weak, nonatomic) IBOutlet UIToolbar *logoutBarButtonItem;
@property (strong, nonatomic) Section *section;
@property (strong, nonatomic) GRTCornerTriangles *cornerTriangle;

@property (strong, nonatomic) GRTDataStore *dataStore;

@end

@implementation GRTMainViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
    [self setupNavBar];
    [self setupFooterToolbar];
    
    GRTCornerTriangles *cornerTriangle = [GRTCornerTriangles new];
    
//    [[GRTFacebookAPIClient sharedClient] verifyUserFacebookCachedInViewController:self];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Methods


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (GRTPostTableViewCell *)[self configureCellForMainTableViewWithIndexPath:indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataStore.postFRController.sections[0] numberOfObjects];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"mainToDetail" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - FetchedResultsController Methods


- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.postsTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.postsTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.postsTableView;

    if ([controller isEqual:self.dataStore.postFRController])
    {
        newIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row inSection:0];

    }
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCellForMainTableViewWithIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.postsTableView endUpdates];
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.postsTableView beginUpdates];
}

#pragma mark - Button Methods

- (IBAction)composePostButtonTapped:(id)sender
{

}

- (IBAction)logoutButtonTapped:(UIBarButtonItem *)sender
{
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    GRTFacebookLoginViewController *facebookLoginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"facebookLoginVC"];
//    [self presentViewController:facebookLoginVC animated:YES completion:nil];
}

#pragma mark - Cell Methods


- (GRTPostTableViewCell *) configureCellForMainTableViewWithIndexPath: (NSIndexPath *)indexPath
{
    GRTPostTableViewCell *cell = [self.postsTableView dequeueReusableCellWithIdentifier:@"postCell"];
    Post *post = [self.dataStore.postFRController objectAtIndexPath:indexPath];
    [cell configureWithPost:post];
    
    GRTCornerTriangles *leftCornerTriangle = [[GRTCornerTriangles alloc] initWithFrame:cell.frame IsLeftTriangle:YES withFillColor:[UIColor greatistFitnessColor]];

    GRTCornerTriangles *rightCornerTriangle = [[GRTCornerTriangles alloc] initWithFrame:cell.frame IsLeftTriangle:NO withFillColor:[UIColor greatistFitnessColor]];
    
    if (indexPath.row == 2) {
        NSLog(@"I'm broken");
    }
    
    if (([post.section.name isEqualToString:(@"Fitness")]) && (indexPath.row % 2 == 0))
    {
        cell.backgroundColor = [UIColor greatistFitnessColor];
        cell.buttonBar.backgroundColor=[UIColor whiteColor];
        [cell.contentView addSubview:leftCornerTriangle];
        [leftCornerTriangle setFillColor:[UIColor greatistFitnessColorSecondary]];
    }
    else if (([post.section.name isEqualToString:(@"Fitness")]) && (!indexPath.row % 2 == 0))
    {
        cell.backgroundColor = [UIColor greatistFitnessColor];
        cell.buttonBar.backgroundColor=[UIColor whiteColor];
        [cell.contentView addSubview:rightCornerTriangle];
        [rightCornerTriangle setFillColor:[UIColor greatistFitnessColorSecondary]];
    }
    else if (([post.section.name isEqualToString:(@"Health")]) && (indexPath.row % 2 == 0))
    {
        cell.backgroundColor = [UIColor greatistHealthColor];
        cell.buttonBar.backgroundColor=[UIColor whiteColor];
        [cell.contentView addSubview:leftCornerTriangle];
        [leftCornerTriangle setFillColor:[UIColor greatistHealthColorSecondary]];
    }
    else if (([post.section.name isEqualToString:(@"Health")]) && (!indexPath.row % 2 == 0))
    {
        cell.backgroundColor = [UIColor greatistHealthColor];
        cell.buttonBar.backgroundColor=[UIColor whiteColor];
        [cell.contentView addSubview:rightCornerTriangle];
        [rightCornerTriangle setFillColor:[UIColor greatistHealthColorSecondary]];

    }
    else if (([post.section.name isEqualToString:(@"Happiness")]) && (indexPath.row % 2 == 0))
    {
        cell.backgroundColor = [UIColor greatistHappinessColor];
        cell.buttonBar.backgroundColor=[UIColor whiteColor];
        [cell.contentView addSubview:leftCornerTriangle];
        [leftCornerTriangle setFillColor:[UIColor greatistHappinessColorSecondary]];

    }
    else if (([post.section.name isEqualToString:(@"Happiness")]) && (!indexPath.row % 2 == 0))
    {
        cell.backgroundColor = [UIColor greatistHappinessColor];
        cell.buttonBar.backgroundColor=[UIColor whiteColor];
        [cell.contentView addSubview:rightCornerTriangle];
        [rightCornerTriangle setFillColor:[UIColor greatistHappinessColorSecondary]];

        
    }
    [leftCornerTriangle setNeedsDisplay];
    [rightCornerTriangle setNeedsDisplay];
    
    return cell;
}



#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"mainToDetail"])
    {
        GRTPostDetailViewController *nextVC = segue.destinationViewController;
        GRTPostTableViewCell *cell = (GRTPostTableViewCell *)[self.postsTableView cellForRowAtIndexPath:[self.postsTableView indexPathForSelectedRow]];
        
        nextVC.post = cell.post;
        
        [self.postsTableView deselectRowAtIndexPath:[self.postsTableView indexPathForSelectedRow] animated:YES];

    }
    
    else if ([segue.identifier isEqualToString:@"mainToCompose"])
    {
        GRTComposePostViewController *nextVC = segue.destinationViewController;
        
        NSFetchRequest *getVerticals = [NSFetchRequest fetchRequestWithEntityName:@"Section"];
        NSSortDescriptor *sortingVerticals = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        getVerticals.sortDescriptors = @[sortingVerticals];
        
        nextVC.verticals = [self.dataStore.managedObjectContext executeFetchRequest:getVerticals error:nil];
    }
}

#pragma mark - Helper Methods
- (void)initialize
{
   [self.postsTableView registerNib:[UINib nibWithNibName:@"GRTTableViewCell" bundle:nil] forCellReuseIdentifier:@"postCell"];
    self.dataStore = [GRTDataStore sharedDataStore];
    self.postsTableView.delegate = self;
    self.postsTableView.dataSource = self;
    self.dataStore.postFRController.delegate = self;
}


- (void)setupNavBar
{
//    UIImage *navBar = [UIImage imageNamed:@"navBar.png"];
    //    UIImage *scaledNavBar = [UIImage imageWithImage:navBar scaledToSize:CGSizeMake(320, 54)];
//    CGRect navBarTop = CGRectMake(0, 0, 320, 30);
//    [[UIColor greatistBlueColor] setFill];
//    UIImage *navBarTopImage = [UIImage imageWithCGImage:navBarTop];
//    CGRect navRect = [CGRectMake(0, 0, 320, 30)];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor greatistLightGrayColor]];
    
    UIImage *greatistLogoImage = [UIImage imageNamed:@"Greatist_Logo86x50"];
    UIImage *scaledGreatistLogoImage = [UIImage imageWithImage:greatistLogoImage scaledToSize:CGSizeMake(65, 38)];
    UIImageView *greatistLogoView = [[UIImageView alloc] initWithImage:scaledGreatistLogoImage];
    [self.navigationController.navigationBar.topItem setTitleView:greatistLogoView];
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:-4.0 forBarMetrics:UIBarMetricsDefault];
}

- (void)setupFooterToolbar
{
    [[UIToolbar appearance] setBackgroundColor:[UIColor greatistLightGrayColor]];
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *resizedPostImage = [UIImage imageWithImage:[UIImage imageNamed:@"Greatist_Logo_Badge_Blue"] scaledToSize:CGSizeMake(40, 40)];
    [postButton setBackgroundImage:resizedPostImage forState:UIControlStateNormal];
    [postButton setFrame:CGRectMake(145, 250, 40, 40)];
    [self.composePostButton setImage:resizedPostImage];
}

    
@end
