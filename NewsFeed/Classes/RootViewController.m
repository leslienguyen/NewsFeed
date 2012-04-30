//
//  RootViewController.m
//  NewsFeed
//
//  Created by Leslie Nguyen on 4/30/12.
//  Copyright 2012 Leslie Nguyen. All rights reserved.
//

#import "RootViewController.h"
#import "GridViewController.h"
#import "Common.h"

#define kTableRowTechcrunch 0
#define kTableRowGizmodo 1
#define kTableRowEngadget 2
#define kTableRowReddit 3
#define kTableRowAtlantic 4
#define kTableRowNYTimes 5

#define kTableRowCount kTableRowNYTimes+1

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
        // Custom initialization
    }
    return self;
}

- (id)init
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"LesCrunch";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bar_bg"] forBarMetrics:UIBarMetricsDefault];
        
        self.view.backgroundColor = RGBCOLOR(244, 244, 244);
        
        //Customizing the nav bar
        UIColor *aColor = RGBCOLOR(150, 150, 150);
        UINavigationBar *bar = [[self navigationController] navigationBar];
        [bar setTintColor:aColor];
        
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return kTableRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    switch (indexPath.row) {
        case kTableRowReddit:
            cell.textLabel.text = @"Reddit";
            break;
        case kTableRowGizmodo:
            cell.textLabel.text = @"Gizmodo";
            break;           
        case kTableRowTechcrunch:
            cell.textLabel.text = @"TechCrunch";
            break; 
        case kTableRowEngadget:
            cell.textLabel.text = @"Engadget";
            break; 
        case kTableRowNYTimes:
            cell.textLabel.text = @"NY Times";
            break;
        case kTableRowAtlantic:
            cell.textLabel.text = @"The Atlantic";
            break;
        default:
            break;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GridViewController *gridViewController = [[GridViewController alloc] init];
    
    switch (indexPath.row) {
        case kTableRowReddit:
            gridViewController.feedType = FeedTypeReddit;
            gridViewController.title = @"Reddit";
            break;
        case kTableRowGizmodo:
            gridViewController.feedType = FeedTypeGizmodo;
            gridViewController.title = @"Gizmodo";
            break;           
        case kTableRowTechcrunch:
            gridViewController.feedType = FeedTypeTechcrunch;
            gridViewController.title = @"TechCrunch";
            break; 
        case kTableRowEngadget:
            gridViewController.feedType = FeedTypeEngadget;
            gridViewController.title = @"Engadget";
            break; 
        case kTableRowNYTimes:
            gridViewController.feedType = FeedTypeNYTimes;
            gridViewController.title = @"NY Times";
            break;
        case kTableRowAtlantic:
            gridViewController.feedType = FeedTypeAtlantic;
            gridViewController.title = @"The Atlantic";
            break;
        default:
            break;  
    }
            
     [self.navigationController pushViewController:gridViewController animated:YES];
     [gridViewController release];
}

@end
