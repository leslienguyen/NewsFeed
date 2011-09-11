//
//  FeedTableCell.h
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/5/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FeedTableCell : UITableViewCell 
{
	UILabel *myTitleLeft;
	UILabel *myTitleRight;
	UIImageView *myImageViewLeft;
	UIImageView *myImageViewRight;
	UIButton *myButtonLeft;
	UIButton *myButtonRight;
	
}

@property (nonatomic, readwrite, retain) IBOutlet UILabel *titleLeft;
@property (nonatomic, readwrite, retain) IBOutlet UILabel *titleRight;
@property (nonatomic, readwrite, retain) IBOutlet UIImageView *imageViewLeft;
@property (nonatomic, readwrite, retain) IBOutlet UIImageView *imageViewRight;
@property (nonatomic, readwrite, retain) IBOutlet UIButton *buttonLeft;
@property (nonatomic, readwrite, retain) IBOutlet UIButton *buttonRight;

@end
