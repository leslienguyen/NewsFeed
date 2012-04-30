//
//  FeedTableCell.m
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/5/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import "FeedTableCell.h"
#import "Common.h"
#import <QuartzCore/QuartzCore.h>

@implementation FeedTableCell

@synthesize titleLeft = myTitleLeft;
@synthesize buttonLeft = myButtonLeft;
@synthesize bigTitleLeft = myBigTitleLeft;
@synthesize bigTitleViewLeft = myBigTitleViewLeft;
@synthesize imageViewLeft = myImageViewLeft;

@synthesize titleMiddle= myTitleMiddle;
@synthesize buttonMiddle = myButtoMiddle;
@synthesize bigTitleMiddle = myBigTitleMiddle;
@synthesize bigTitleViewMiddle = myBigTitleViewMiddle;
@synthesize imageViewMiddle = myImageViewMiddle;

@synthesize titleRight = myTitleRight;
@synthesize buttonRight = myButtonRight;
@synthesize bigTitleRight = myBigTitleRight;
@synthesize bigTitleViewRight = myBigTitleViewRight;
@synthesize imageViewRight = myImageViewRight;

- (void)viewDidLoad
{
    self.backgroundColor = RGBCOLOR(244, 244, 244);
    self.buttonLeft.backgroundColor = RGBCOLOR(200, 200, 200);
    self.buttonLeft.layer.borderColor = [[UIColor grayColor] CGColor];
    self.buttonLeft.layer.borderWidth = 1.0f;
    
    
    self.imageViewLeft.backgroundColor = RGBCOLOR(200, 200, 200);
    self.imageViewLeft.layer.borderColor = [[UIColor grayColor] CGColor];
    self.imageViewLeft.layer.borderWidth = 1.0f;
    
    self.imageViewMiddle.backgroundColor = RGBCOLOR(200, 200, 200);
    self.imageViewMiddle.layer.borderColor = [[UIColor grayColor] CGColor];
    self.imageViewMiddle.layer.borderWidth = 1.0f;
    
    self.imageViewRight.backgroundColor = RGBCOLOR(200, 200, 200);
    self.imageViewRight.layer.borderColor = [[UIColor grayColor] CGColor];
    self.imageViewRight.layer.borderWidth = 1.0f;
}

- (void)dealloc
{
	[myTitleLeft release]; myTitleLeft = nil;
	[myButtonLeft release]; myButtonLeft = nil;
	[myBigTitleLeft release]; myBigTitleLeft = nil;
	[myBigTitleViewLeft release]; myBigTitleViewLeft = nil;
	[myImageViewLeft release]; myImageViewLeft = nil;
	
	[myTitleMiddle release]; myTitleMiddle = nil;
	[myButtonMiddle release]; myButtonMiddle = nil;
	[myBigTitleMiddle release]; myBigTitleMiddle = nil;
	[myBigTitleViewMiddle release]; myBigTitleViewMiddle = nil;
	[myImageViewMiddle release]; myImageViewMiddle = nil;
	
	[myTitleRight release]; myTitleRight = nil;
	[myButtonRight release]; myButtonRight = nil;
	[myBigTitleRight release]; myBigTitleRight = nil;
	[myBigTitleViewRight release]; myBigTitleViewRight = nil;
	[myImageViewRight release]; myImageViewRight = nil;
	
	[super dealloc];
}

@end
