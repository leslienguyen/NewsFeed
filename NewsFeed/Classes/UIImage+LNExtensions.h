//
//  UIImage+LNExtensions.h
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/10/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (LNExtensions)  

/*!
 Returns the size of the image if it were to be scaled to fit the specified size by maintaining the aspect ratio.
 \param size The size to use for computing the size.
 \return The width and height of the resulting image's bounding box.
 */
- (CGSize)sizeByScalingWithAspectFitForSize:(CGSize)size;

// Returns the size of the image if it were to be scaled to fill the specified size.
- (CGSize)sizeByScalingWithAspectFillForSize:(CGSize)size;

/*!
 Creates and returns a new image object with content scaled to fit the specified size by maintaining the aspect ratio.
 Any remaining area is transparent.
 \param size The size to use for the new image's bounding box.
 \return A new image object.
 */
- (UIImage *)imageByScalingWithAspectFitForSize:(CGSize)size;

/*!
 Creates and returns a new image object with content scaled to fill the specified size.
 \param size - The size to use for the new image's bounding box.
 \param horizontalOffsetFactor - A value ranging from 0.0 to 1.0 that specifies how far the scaled image should be horizontally offset in the new bounding box.
 \param verticalOffsetFactor - A value ranging from 0.0 to 1.0 that specifies how far the scaled image should be vertically offset in the new bounding box.
 \return A new image object.
 */
- (UIImage *)imageByScalingWithAspectFillForSize:(CGSize)size horizontalOffsetFactor:(CGFloat)horizontalOffsetFactor verticalOffsetFactor:(CGFloat)verticalOffsetFactor;

/*!
 Creates and returns a new image object with content scaled to fill the specified size.
 Uses 0.0f horizontal and vertical offset factors
 \param size The size to use for the new image's bounding box.
 \return A new image object.
 */
- (UIImage *)imageByScalingWithAspectFillForSize:(CGSize)size;

@end
