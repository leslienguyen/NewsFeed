//
//  UIImage+LNExtensions.m
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/10/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import "UIImage+LNExtensions.h"


@implementation UIImage (LNExtensions)

- (CGSize)sizeByScalingWithAspectFitForSize:(CGSize)size
{
	CGSize imageSize = [self size];
	if (!CGSizeEqualToSize(size, imageSize))
	{
		CGFloat widthFactor = size.width / imageSize.width;
		CGFloat heightFactor = size.height / imageSize.height;
		CGFloat scale = widthFactor > heightFactor ? heightFactor : widthFactor;
		
		size.width = imageSize.width * scale;
		size.height = imageSize.height * scale;
	}
	
	return size;
}

- (CGSize)sizeByScalingWithAspectFillForSize:(CGSize)size
{
	CGSize imageSize = [self size];
	if (!CGSizeEqualToSize(size, imageSize))
	{
		CGFloat widthFactor = size.width / imageSize.width;
		CGFloat heightFactor = size.height / imageSize.height;
		CGFloat scale = widthFactor > heightFactor ? widthFactor : heightFactor;
		
		size.width = imageSize.width * scale;
		size.height = imageSize.height * scale;
	}
	
	return size;
}

- (UIImage *)imageByScalingWithAspectFitForSize:(CGSize)size
{
	UIImage *newImage = self;
	CGSize newSize = [self sizeByScalingWithAspectFitForSize:size];
	CGSize imageSize = [self size];
	if (!CGSizeEqualToSize(size, imageSize))
	{
		CGFloat horizontalOffset = (size.width - newSize.width) / 2;
		CGFloat verticalOffset = (size.height - newSize.height) / 2;
		UIGraphicsBeginImageContext(size);
		[self drawInRect:CGRectMake(horizontalOffset, verticalOffset, newSize.width, newSize.height)];
		newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	
	return newImage;
}

- (UIImage *)imageByScalingWithAspectFillForSize:(CGSize)size horizontalOffsetFactor:(CGFloat)horizontalOffsetFactor verticalOffsetFactor:(CGFloat)verticalOffsetFactor
{
	UIImage *newImage = self;
	CGSize newSize = [self sizeByScalingWithAspectFillForSize:size];
	CGSize imageSize = [self size];
	if (!CGSizeEqualToSize(size, imageSize))
	{
		CGFloat horizontalOffset = (size.width - newSize.width) * horizontalOffsetFactor;
		CGFloat verticalOffset = (size.height - newSize.height) * verticalOffsetFactor;
		UIGraphicsBeginImageContext(size);
		[self drawInRect:CGRectMake(horizontalOffset, verticalOffset, newSize.width, newSize.height)];
		newImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
	}
	
	return newImage;
}

- (UIImage *)imageByScalingWithAspectFillForSize:(CGSize)size
{
	return [self imageByScalingWithAspectFillForSize:size horizontalOffsetFactor:0.00f verticalOffsetFactor:0.00f];
}

@end
