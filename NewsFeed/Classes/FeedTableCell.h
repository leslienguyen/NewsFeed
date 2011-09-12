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
	UIButton *myButtonLeft;
	UILabel *myBigTitleLeft;
	UIView *myBigTitleViewLeft;
	UIImageView *myImageViewLeft;
	
	UILabel *myTitleMiddle;
	UIButton *myButtonMiddle;
	UILabel *myBigTitleMiddle;	
	UIView *myBigTitleViewMiddle;
	UIImageView *myImageViewMiddle;
	
	UILabel *myTitleRight;
	UIButton *myButtonRight;
	UILabel *myBigTitleRight;	
	UIView *myBigTitleViewRight;
	UIImageView *myImageViewRight;
}

@property (nonatomic, readwrite, retain) IBOutlet UILabel *titleLeft;
@property (nonatomic, readwrite, retain) IBOutlet UIButton *buttonLeft;
@property (nonatomic, readwrite, retain) IBOutlet UILabel *bigTitleLeft;
@property (nonatomic, readwrite, retain) IBOutlet UIView *bigTitleViewLeft;
@property (nonatomic, readwrite, retain) IBOutlet UIImageView *imageViewLeft;

@property (nonatomic, readwrite, retain) IBOutlet UILabel *titleMiddle;
@property (nonatomic, readwrite, retain) IBOutlet UIButton *buttonMiddle;
@property (nonatomic, readwrite, retain) IBOutlet UILabel *bigTitleMiddle;
@property (nonatomic, readwrite, retain) IBOutlet UIView *bigTitleViewMiddle;
@property (nonatomic, readwrite, retain) IBOutlet UIImageView *imageViewMiddle;

@property (nonatomic, readwrite, retain) IBOutlet UILabel *titleRight;
@property (nonatomic, readwrite, retain) IBOutlet UIButton *buttonRight;
@property (nonatomic, readwrite, retain) IBOutlet UILabel *bigTitleRight;
@property (nonatomic, readwrite, retain) IBOutlet UIView *bigTitleViewRight;
@property (nonatomic, readwrite, retain) IBOutlet UIImageView *imageViewRight;

@end
