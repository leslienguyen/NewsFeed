//
//  RootViewController.m
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/4/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import "RootViewController.h"
#import "NewsFeedItem.h"
#import "NewsFeedController.h"
#import "FeedTableCell.h"
#import "ArticleWebViewController.h"
#import "UIImage+LNExtensions.h"

#define kArticleImageWidth 154.0f
#define kArticleImageHeight 134.0f

@interface RootViewController() 

- (void)newsFeedDidChange:(NSNotification*)note;
- (void)refreshFeed:(id)sender;
- (void)displayDetailForIndex:(NSUInteger)index;
- (NSUInteger)indexLeftForRow:(NSUInteger)row;
- (NSUInteger)indexRightForRow:(NSUInteger)row;
- (void)displayDetailRight:(id)sender;
- (void)displayDetailLeft:(id)sender;



@property(nonatomic, readwrite, getter=isGridFormat, assign) BOOL gridFormat;

@end


@implementation RootViewController
@synthesize tvCell;
@synthesize gridFormat;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self setTitle:@"TechCrunch"];
	
	UIColor *aColor = [UIColor colorWithRed:0.1 green:0.560 blue:0.556 alpha:1.000];
	UINavigationBar *bar = [[self navigationController] navigationBar];
	[bar setTintColor:aColor];
		
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshFeed:)];
	[[self navigationItem] setRightBarButtonItem:button];
	[button release];
	
	[[NewsFeedController sharedController] makeRequest];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsFeedDidChange:) name:NewsFeedDidChangeNotification object:nil];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

- (void)setGridFormat:(BOOL)enabled
{
	if(enabled)
	{
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
	else 
	{
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	}	
	
	gridFormat = enabled;
}

- (void)newsFeedDidChange:(NSNotification*)note
{
	[self setGridFormat:YES];
	[self.tableView reloadData];
}

//TODO: handling previous requests that are not done
- (void)refreshFeed:(id)sender
{
	[[NewsFeedController sharedController] makeRequest];
}

- (void)displayDetailLeft:(id)sender
{
	UIButton *button = (UIButton *)sender;
	UITableViewCell *cell = (UITableViewCell*)[button superview];
	int row = [self.tableView indexPathForCell:cell].row;
	
	NSUInteger index = [self indexLeftForRow:row];
	
	if(index != NSNotFound)
	{
		[self displayDetailForIndex:index];
	}
}

- (void)displayDetailRight:(id)sender
{
	UIButton *button = (UIButton *)sender;
	UITableViewCell* cell = (UITableViewCell*)[button superview];
	int row = [self.tableView indexPathForCell:cell].row;
	
	NSUInteger index = [self indexRightForRow:row];
	
	if(index != NSNotFound)
	{
		[self displayDetailForIndex:index];
	}
}


// each row will have two entries
// row 0: entry #0, 1
// row 1: entry #2, 3
// To get index of entry left: row * 2
// To get index of entry right: row*2 + 1; need to check if there is an entry
- (NSUInteger)indexLeftForRow:(NSUInteger)row
{
	NSUInteger indexLeft = row * 2;
	
	NSInteger count = [[[NewsFeedController sharedController] entries] count];

	if(indexLeft < count)
	{
		return indexLeft;
	}
	
	return NSNotFound;
}

- (NSUInteger)indexRightForRow:(NSUInteger)row
{	
	NSUInteger indexRight = row * 2 + 1;
	
	NSInteger count = [[[NewsFeedController sharedController] entries] count];

	if(indexRight < count)
	{
		return indexRight;
	}
	
	return NSNotFound;
}



#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	NSInteger count = [[[NewsFeedController sharedController] entries] count];

	if(self.gridFormat)
	{
		float f = count/2;
		NSInteger numberOfEntries = f + 0.5;
		return numberOfEntries;
	}
	
	return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
       
	if(self.gridFormat)
	{
		static NSString *GridCellIdentifier = @"GridFeedCell";

		FeedTableCell *cell = (FeedTableCell*)[tableView dequeueReusableCellWithIdentifier:GridCellIdentifier];
		if (cell == nil) {
			
			[[NSBundle mainBundle] loadNibNamed:@"FeedTableCell" owner:self options:nil];
			
			cell = tvCell;
			
			self.tvCell = nil;		
		}
		
		// Configure the cell.
		
		NSUInteger indexLeft = [self indexLeftForRow:indexPath.row];
		NSUInteger indexRight = [self indexRightForRow:indexPath.row];

		
		NSArray *entries = [[NewsFeedController sharedController] entries];
		
		if(indexLeft < [entries count] )
		{
			NewsFeedItem *entry = [entries objectAtIndex:indexLeft];
			
			UILabel *label = (UILabel *)[cell viewWithTag:1];
			label.text = [entry title];

			UIButton *button = (UIButton*)[cell viewWithTag:2];
			UIImage *image = [[entry thumbnail] imageByScalingPortraitWithAspectFillForSize: CGSizeMake(kArticleImageWidth, kArticleImageHeight)];
			[button setImage:image forState:UIControlStateNormal];
			[button addTarget:self action:@selector(displayDetailLeft:) forControlEvents:UIControlEventTouchUpInside];
		}
		
		if(indexRight < [entries count])
		{
			NewsFeedItem *entry = [entries objectAtIndex:indexRight];
			
			UILabel *label = (UILabel *)[cell viewWithTag:3];
			label.text = [entry title];
			
			UIButton *button = (UIButton*)[cell viewWithTag:4];
			UIImage *image = [[entry thumbnail] imageByScalingPortraitWithAspectFillForSize: CGSizeMake(kArticleImageWidth, kArticleImageHeight)];
			[button setImage:image forState:UIControlStateNormal];				
			[button addTarget:self action:@selector(displayDetailRight:) forControlEvents:UIControlEventTouchUpInside];

		}	
		return cell;

	}
	else 
	{
	
		static NSString *NormalCellIdentifier = @"NormalFeedCell";

		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalCellIdentifier];
		
		if (cell == nil) {
			
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NormalCellIdentifier];
			
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
		}
		
		NSArray *entries = [[NewsFeedController sharedController] entries];
		
		if(indexPath.row < [entries count])
		{
			NewsFeedItem *entry = [entries objectAtIndex:indexPath.row];
			
			cell.textLabel.text = [entry title];
			
			cell.detailTextLabel.text = [entry summary];
								
			cell.imageView.image = [entry thumbnail];
		}
		
		return cell;
	}

}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(self.gridFormat)
	{
		return 138.0f;
	}
	
	return 44.0f;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(self.gridFormat)
	{
		return nil;
	}
	
	return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if(!self.gridFormat)
	{
		[self displayDetailForIndex:indexPath.row];
	}
	
	
}
	
	
- (void)displayDetailForIndex:(NSUInteger)index
{
	ArticleWebViewController *detailViewController = [[[ArticleWebViewController alloc] init] autorelease];
	
	//Create a URL object.
	
	NSArray *entries = [[NewsFeedController sharedController] entries];
	
	if(index < [entries count])
	{
		NSURL *url = [[entries objectAtIndex:index] link];
		
		//URL Requst Object
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		
		//Load the request in the UIWebView.
		[detailViewController loadRequest:requestObj];
		
		[self.navigationController pushViewController:detailViewController animated:YES];	 
		
	}
}
		


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

