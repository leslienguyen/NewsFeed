//
//  RootViewController.m
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/4/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import "RootViewController.h"
#import "NewsFeedItem.h"
#import "FeedDownloader.h"
#import "FeedTableCell.h"
#import "ArticleWebViewController.h"
#import "UIImage+LNExtensions.h"
#import "ImageCache.h"

#define kArticleGridImageWidth 154.0f
#define kArticleGridImageHeight 134.0f
#define kArticleRowHeight 44.0f
#define kArticleGridHeight  138.0f

#define kArticleGridImageWidthIPad 248.0f
#define kArticleGridImageHeightIPad 234.0f
#define kArticleRowHeightIPad 88.0f
#define kArticleGridHeightIPad 240.0f

#define kNewsFeedLayoutGrid 0
#define kNewsFeedLayoutTable 1

#define kNewsFeedNumberOfArticlePerRow 2
#define kNewsFeedNumberOfArticlePerRowIPad 3

NSString *NewsFeedLayoutKey = @"NewsFeedLayoutKey";

@interface RootViewController() 

- (void)newsFeedDidChange:(NSNotification*)note;
- (void)newsFeedRequestDidFail:(NSNotification*)note;
- (void)refreshFeed:(id)sender;
- (void)displayDetailForIndex:(NSUInteger)index;
- (UIImage*)imageForFeed:(NewsFeedItem*)entry;
- (void)changeFormat:(id)sender;

@property(nonatomic, readwrite, getter=isTableFormat, assign) BOOL tableFormat;
@property(nonatomic, readwrite, retain) NSMutableDictionary *cachedImages;
@property(nonatomic, readwrite, retain) NSString *errorString;
@property(nonatomic, readwrite, retain) UIActivityIndicatorView *spinner;

@end


@implementation RootViewController
@synthesize tvCell = myTvCell;
@synthesize tableFormat = myTableFormat;
@synthesize cachedImages = myCachedImages;
@synthesize errorString = myErrorString;
@synthesize spinner = mySpinner;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self setTitle:@"LesCrunch"];
		
	// Right bar button
	UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh 
																			target:self 
																			action:@selector(refreshFeed:)];
	self.navigationItem.rightBarButtonItem = button;
	[button release];
	
	// Left bar button

	UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Grid", @"Table", nil]];
	[segControl setSegmentedControlStyle:UISegmentedControlStyleBar];	
	[segControl addTarget:self action:@selector(changeFormat:) forControlEvents:UIControlEventValueChanged];
	
	//If the key does not exist, this method returns 0, which defaults us to grid layout
	NSUInteger layoutIndex = [[NSUserDefaults standardUserDefaults] integerForKey:NewsFeedLayoutKey];
							
	[segControl setSelectedSegmentIndex:layoutIndex];
	
	UIBarButtonItem *segBarItem = [[UIBarButtonItem alloc] initWithCustomView:segControl];
	self.navigationItem.leftBarButtonItem = segBarItem;
	
	[segControl release];
	[segBarItem release];	
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_bar_bg"] forBarMetrics:UIBarMetricsDefault];
        
        self.view.backgroundColor = RGBCOLOR(244, 244, 244);
        
        //Customizing the nav bar
        UIColor *aColor = RGBCOLOR(200, 200, 200);
        UINavigationBar *bar = [[self navigationController] navigationBar];
        [bar setTintColor:aColor];
        
        [segControl setTintColor:aColor];
    }
	
	[self setTableFormat:layoutIndex];
	self.cachedImages = [NSMutableDictionary dictionaryWithCapacity:10];
	
    mySpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    mySpinner.color = [UIColor grayColor];
    mySpinner.center = CGPointMake(self.view.bounds.size.width/2.0f, 100);
    [mySpinner hidesWhenStopped];
    
    [self.view addSubview:mySpinner];
    [mySpinner startAnimating];
    
	// make the first request
	[[FeedDownloader sharedController] downloadFeed:FeedTypeTechcrunch withSuccessBlock:^(NSArray *entries) {
        
    }];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsFeedDidChange:) name:NewsFeedDidChangeNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newsFeedRequestDidFail:) name:NewsFeedRequestDidFailNotification object:nil];

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

- (void)setTableFormat:(BOOL)enabled
{
	if(enabled)
	{
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	}
	else 
	{
		self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}	
	
	myTableFormat = enabled;
	
	[self.tableView reloadData];
}

- (void)newsFeedDidChange:(NSNotification*)note
{
	self.errorString = nil;
	[self.cachedImages removeAllObjects];
    [self.spinner stopAnimating];
	[self.tableView reloadData];
}

- (void)newsFeedRequestDidFail:(NSNotification*)note
{
	self.errorString = [[note userInfo] objectForKey:NewsFeedErrorKey];
	[self.cachedImages removeAllObjects];
    [self.spinner stopAnimating];
	[self.tableView reloadData];
}

//TODO: handling previous requests that are not done
- (void)refreshFeed:(id)sender
{
    [self.spinner startAnimating];
	[[FeedDownloader sharedController] downloadFeed:FeedTypeTechcrunch withSuccessBlock:^(NSArray *entries) {
        
    }];
}

- (IBAction)displayDetail:(id)sender;
{
	UIButton *button = (UIButton *)sender;
	NSUInteger index = button.tag;
		
	[self displayDetailForIndex:index];	
}

- (void)changeFormat:(id)sender
{
	[self.cachedImages removeAllObjects];

	UISegmentedControl *control = (UISegmentedControl*)sender;
	NSUInteger index = [control selectedSegmentIndex];
	
	[self setTableFormat:index];

}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if(self.errorString)
	{
		return 1;
	}
	
	NSInteger count = [[[FeedDownloader sharedController] entries] count];

	if(!self.tableFormat)
	{
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
		{
			float f = count/kNewsFeedNumberOfArticlePerRowIPad;
			NSInteger numberOfEntries = f + 0.5;
			return numberOfEntries;
		}
		else 
		{
			float f = count/kNewsFeedNumberOfArticlePerRow;
			NSInteger numberOfEntries = f + 0.5;
			return numberOfEntries;
		}

	}
	
	return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
       
	if(self.errorString)
	{
		static NSString *NormalCellIdentifier = @"ErrorFeedCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalCellIdentifier];
		
		if (cell == nil) {
			
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NormalCellIdentifier];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		
		[cell.textLabel setText:self.errorString];
		
		return cell;
	}
		
	if(self.tableFormat)
	{		
		static NSString *NormalCellIdentifier = @"NormalFeedCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalCellIdentifier];
		
		if (cell == nil) {
			
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:NormalCellIdentifier];
			
			[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];			
		}
		
		NSArray *entries = [[FeedDownloader sharedController] entries];
		
		if(indexPath.row < [entries count])
		{
			NewsFeedItem *entry = [entries objectAtIndex:indexPath.row];
			
			cell.textLabel.text = [entry title];
			
			cell.detailTextLabel.text = [entry summary];
			
			cell.imageView.image = [self imageForFeed:entry];
		}
		
		return cell;
	}
	
	else
	{
		static NSString *GridCellIdentifier = @"GridFeedCell";

		FeedTableCell *cell = (FeedTableCell*)[tableView dequeueReusableCellWithIdentifier:GridCellIdentifier];
		if (cell == nil) 
		{
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
			{
				[[NSBundle mainBundle] loadNibNamed:@"FeedTableCell-iPad" owner:self options:nil];
			}
			else 
			{
				[[NSBundle mainBundle] loadNibNamed:@"FeedTableCell" owner:self options:nil];

			}
			
			cell = self.tvCell;
			
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			self.tvCell = nil;		
		}
		
		// Configure the cell.
		
		// For iPad: 3 articles per row
		// For iPhone: 2 articles per row
		
		NSUInteger indexLeft;
		NSUInteger indexMiddle;
		NSUInteger indexRight;
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
		{			
			indexLeft = indexPath.row * kNewsFeedNumberOfArticlePerRowIPad;
			indexMiddle = indexLeft + 1;
			indexRight = indexLeft + 2;
		}
		else 
		{
			indexLeft = indexPath.row * kNewsFeedNumberOfArticlePerRow;
			indexRight = indexLeft + 1;
		}
		
		NSArray *entries = [[FeedDownloader sharedController] entries];
		
		if(indexLeft < [entries count] )
		{
			NewsFeedItem *entry = [entries objectAtIndex:indexLeft];

			UIButton *button = [cell buttonLeft];
			button.tag = indexLeft;						

			UIImage *sizedImage = [self imageForFeed:entry];
			
			// if there is an image display it
			if(sizedImage)
			{
				[button setImage:sizedImage forState:UIControlStateNormal];
				
				[cell.titleLeft setText:[entry title]];				
				[cell.bigTitleLeft setHidden:YES];
				[cell.bigTitleViewLeft setHidden:YES];
			}
			else 
			{
				[button setImage:nil forState:UIControlStateNormal];
				[cell.bigTitleLeft setHidden:NO];
				[cell.bigTitleViewLeft setHidden:NO];
				[cell.bigTitleLeft setText:[entry title]];
				[cell.titleLeft setText:[entry author]];
			}
		}
		
		// the middle article is only for iPad
		
		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
		{			
			if(indexMiddle < [entries count])
			{
				NewsFeedItem *entry = [entries objectAtIndex:indexMiddle];
				
				UIButton *button = [cell buttonMiddle];
				button.tag = indexMiddle;						
				
				UIImage *sizedImage = [self imageForFeed:entry];
				
				// if there is an image display it
				if(sizedImage)
				{		
					[button setImage:sizedImage forState:UIControlStateNormal];
					
					[cell.titleMiddle setText:[entry title]];				
					[cell.bigTitleMiddle setHidden:YES];
					[cell.bigTitleViewMiddle setHidden:YES];
					
				}
				else 
				{
					[button setImage:nil forState:UIControlStateNormal];
					[cell.bigTitleMiddle setHidden:NO];
					[cell.bigTitleViewMiddle setHidden:NO];
					[cell.bigTitleMiddle setText:[entry title]];
					[cell.titleMiddle setText:[entry author]];
				}
			}
		}
		
		if(indexRight < [entries count])
		{
			NewsFeedItem *entry = [entries objectAtIndex:indexRight];
			
			UIButton *button = [cell buttonRight];
			button.tag = indexRight;						

			UIImage *sizedImage = [self imageForFeed:entry];
			
			// if there is an image display it
			if(sizedImage)
			{		
				[button setImage:sizedImage forState:UIControlStateNormal];
				
				[cell.titleRight setText:[entry title]];				
				[cell.bigTitleRight setHidden:YES];
				[cell.bigTitleViewRight setHidden:YES];

			}
			else 
			{
				[button setImage:nil forState:UIControlStateNormal];
				[cell.bigTitleRight setHidden:NO];
				[cell.bigTitleViewRight setHidden:NO];
				[cell.bigTitleRight setText:[entry title]];
				[cell.titleRight setText:[entry author]];
			}
		}	
		
		return cell;
	}

}

- (UIImage*)imageForFeed:(NewsFeedItem*)entry
{
	//look for image in cache first
	__block UIImage *sizedImage = [self.cachedImages objectForKey:[entry link]];
	
	// if image doesnt exist in cache, find it and size it 
	if(sizedImage == nil)
	{
        [[ImageCache sharedCache] fetchImageURL:[entry thumbnailUrl] withBlock:^(UIImage *image, NSString *url) {
            
            CGSize size;

            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
            {
                size = (self.tableFormat) ? CGSizeMake(kArticleRowHeightIPad, kArticleRowHeightIPad): CGSizeMake(kArticleGridImageWidthIPad, kArticleGridImageHeightIPad);			
                sizedImage = [image imageByScalingWithAspectFillForSize:size];
            }
            else 
            {
                size = (self.tableFormat) ?  CGSizeMake(kArticleRowHeight, kArticleRowHeight): CGSizeMake(kArticleGridImageWidth, kArticleGridImageHeight);
                sizedImage = [image imageByScalingWithAspectFillForSize:size];
            }		
            
            if(sizedImage != nil)
            {
                // save image to cache
                [self.cachedImages setObject:sizedImage forKey:[entry link]];
            }
            
            //[self.tableView reloadData];
        }];
    }
	
	return sizedImage;	
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
	CGFloat height;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
	{
		if(self.tableFormat)
		{
			height = kArticleRowHeightIPad;
		}
		else 
		{
			height = kArticleGridHeightIPad;
		}
	}
	else 
	{
		if(self.tableFormat)
		{

			height = kArticleRowHeight;
		}
		else 
		{
			height = kArticleGridHeight;
		}
	}

	return height;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if(self.tableFormat)
	{
		return indexPath;
	}
	
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if(self.tableFormat)
	{
		[self displayDetailForIndex:indexPath.row];
	}
}
	
	
- (void)displayDetailForIndex:(NSUInteger)index
{
	ArticleWebViewController *detailViewController = [[[ArticleWebViewController alloc] init] autorelease];
	
	//Create a URL object.
	
	NSArray *entries = [[FeedDownloader sharedController] entries];
	
	if(index < [entries count])
	{
		NewsFeedItem *entry = [entries objectAtIndex:index];
		NSURL *url = [entry link];
		
		//URL Request Object
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


- (void)dealloc 
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[myCachedImages release]; myCachedImages = nil;
	[myErrorString release]; myErrorString = nil;
	
    [super dealloc];
}


@end

