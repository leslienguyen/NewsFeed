//
//  UINavigationBar+Custom.m
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/6/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import "LNNavigationBar.h"


@implementation LNNavigationBar

//- (void)viewDidLoad
//{
////	[self.navigationController.navigationBar setTintColor:/* Custom color here */];
////	
////	UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
////	[self.navigationItem setTitleView:logoView];
////	[logoView release];
//
//}
- (void)drawRect:(CGRect)rect
{
//	// custom background
//	UIImage *image = [UIImage imageNamed: @"NavigationBar.png"];
//    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//
//	//
    [[UIImage imageNamed:@"customNavBar"] drawInRect:rect];
	
    // Optionally you can set the tintColor here to go with the background
}


@end
