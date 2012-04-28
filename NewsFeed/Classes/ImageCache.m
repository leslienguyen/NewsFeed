//
//  ImageCache.m
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/4/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import "ImageCache.h"
#import "ASIHTTPRequest.h"
#import "NSData+Base64.h"

@implementation ImageCache

static ImageCache *sharedCache = nil;

+(ImageCache *) sharedCache {
	@synchronized([ImageCache class])
	{
		if (!sharedCache) {		
			sharedCache = [[ImageCache alloc] init];
			
			NSFileManager *manager = [NSFileManager defaultManager];
			[manager createDirectoryAtPath:[sharedCache imagePath] withIntermediateDirectories:YES attributes:nil error:nil];
		}
		
		return sharedCache;
	}
	
	return nil;
}

-(NSString *)imagePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"images"];
	return documentsDirectory;
}

-(void)clearDiskCache {
	NSFileManager *manager = [NSFileManager defaultManager];
	NSError *error = 0;
	NSString *directory = [self imagePath];
	for (NSString *file in [manager contentsOfDirectoryAtPath:directory error:&error]) {
		BOOL success = [manager removeItemAtPath:[directory stringByAppendingPathComponent:file] error:&error];		
		if (!success || error) {
			NSLog(@"Unable to delete - %@", [error localizedDescription]);
		}
	}
}

-(void)fetchImageURL:(NSString *)urlString withBlock:(void(^)(UIImage *, NSString *url))block {
	NSString *fullPath = [[self imagePath] stringByAppendingPathComponent:[[urlString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString]];
	fullPath = [fullPath stringByAppendingPathExtension:@"jpg"];
	
	UIImage *cachedImage = [UIImage imageWithContentsOfFile:fullPath];
	
	if (cachedImage == nil) {
                
        NSURL *url =[NSURL URLWithString:urlString];
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        __block NSString *absoluteString = [url absoluteString];
        
        [request setDelegate:self];
        [request setCachePolicy:ASIUseDefaultCachePolicy];
        [request setCompletionBlock:^{
            
            UIImage *image = [[UIImage alloc] initWithData:[request responseData]];
            
            // retain the image so it can be written to file in the background and then guaranteed release on the main thread
            __block UIImage *retainedImage = [image retain];
            
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				NSFileManager *manager = [NSFileManager defaultManager];
				NSString *fullPath = [[self imagePath] stringByAppendingPathComponent:[[absoluteString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString]];
				fullPath = [fullPath stringByAppendingPathExtension:@"jpg"];
				[manager createFileAtPath:fullPath contents:UIImageJPEGRepresentation(retainedImage, 0.8) attributes:nil];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [retainedImage release];
                });
			});
			
			block(image, absoluteString);	
            [image release];
        }];
        
        [request startAsynchronous];		
		
    }			
    else 
    {
		block(cachedImage, urlString);
	}
}

@end
