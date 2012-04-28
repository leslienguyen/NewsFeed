//
//  ImageCache.h
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/4/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCache : NSObject {

}

+(ImageCache *) sharedCache;

- (void)fetchImageURL:(NSString *)url withBlock:(void(^)(UIImage *, NSString *url))block;
- (NSString *)imagePath;
- (void)clearDiskCache;

@end
