//
//  NewsFeedController.m
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/5/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import "NewsFeedController.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "NewsFeedItem.h"
#import "NSNotificationCenter+LNExtension.h"

static NewsFeedController *theSharedController = nil;

NSString *NewsFeedDidChangeNotification = @"NewsFeedDidChangeNotification";
NSString *NewsFeedRequestDidFailNotification = @"NewsFeedRequestDidFailNotification";
NSString *NewsFeedErrorKey = @"NewsFeedErrorKey";
NSString *NewsFeedPathString = @"NewsFeedEntries";

@interface NewsFeedController()

@property (nonatomic, readwrite, retain) NSMutableArray *entries;

- (void)loadCache;

@end

@implementation NewsFeedController

@synthesize entries = myEntries;

- (id)init
{
	self = [super init];
	
	if(self != nil)
	{
		[self loadCache];
	}
	return self;
}

- (void)makeRequest
{
	NSLog(@"[NewsFeedController makeRequest:]");
	NSURL *url = [NSURL URLWithString:@"https://ajax.googleapis.com/ajax/services/feed/load?q=http://feeds.feedburner.com/TechCrunch&v=1.0&output=json&num=18"];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request startAsynchronous];	
}

#pragma mark ASIHTTPRequest Delegate Methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSLog(@"[NewsFeedController requestFailed:]");
	
	//remove all old entries
	[self.entries removeAllObjects];
	
	// Use when fetching text data
	NSString *jsonString = [request responseString];
	//NSLog(@"%@", jsonString);
	
	NSDictionary *rootResults = [jsonString objectFromJSONString];
	NSDictionary *responseData = [rootResults objectForKey:@"responseData"];
	NSDictionary *feed = [responseData objectForKey:@"feed"];
	
	NSArray *entries = [feed objectForKey:@"entries"];
	
	for(NSDictionary *entry in entries)
	{
		NewsFeedItem *item = [[[NewsFeedItem alloc] init] autorelease];
		[item setTitle:[entry objectForKey:@"title"]];
		[item setSummary:[entry objectForKey:@"contentSnippet"]];
		
		NSString *linkString = [entry objectForKey:@"link"];
		if([linkString length] > 0)
		{
			[item setLink:[NSURL URLWithString:linkString]];
		}
			 
		[item setContent:[entry objectForKey:@"content"]];
		[item setAuthor:[entry objectForKey:@"author"]];
		
		NSArray *mediaGroups = [entry objectForKey:@"mediaGroups"];
		
		NSDictionary *mediaGroup = [mediaGroups lastObject];
		
		NSArray *contents = [mediaGroup objectForKey:@"contents"];
		
		for(NSDictionary *content in contents)
		{
			NSString *medium = [content objectForKey:@"medium"];
			
			if([medium isEqualToString:@"image"])
			{
				NSString *urlString = nil;
				NSURL *url = nil;
				UIImage *image = nil;
			
//				//get the image
//				urlString = [content objectForKey:@"url"];
//				if([urlString length] > 0)
//				{
//					url = [NSURL URLWithString:urlString];
//					image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]]; 
//					
//					if(image)
//					{
//						[item setImage:image];
//						break;//currently don't need to fetch all thumbnails
//					}
//				}
								
				//get thumbnail
				
				NSArray *thumbnails = [content objectForKey:@"thumbnails"];
				NSDictionary *thumbnailDict = [thumbnails lastObject];
				
				urlString = [thumbnailDict objectForKey:@"url"];
				if([urlString length] > 0)
				{
					url = [NSURL URLWithString:urlString];
					image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]]; 
					
					if(image)
					{
						[item setThumbnail:image];
						break; 	//currently don't need to fetch all thumbnails
					}
				}
			}
		}
		
		[self.entries addObject:item];							
		
		NSLog(@"Title: %@", [entry objectForKey:@"title"]);		
		
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:NewsFeedDidChangeNotification object:self];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	NSError *error = [request error];
	NSLog(@"[NewsFeedController requestFailed:] error - %@", [error localizedDescription]);
	
	NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[error localizedDescription] forKey:NewsFeedErrorKey];
	[[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:NewsFeedRequestDidFailNotification object:self userInfo:userInfo];
}

- (void)loadCache
{	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:NewsFeedPathString];
	self.entries = [NSKeyedUnarchiver unarchiveObjectWithFile:dataPath];
	
	if(self.entries == nil)
	{
		self.entries = [[[NSMutableArray alloc] init] autorelease];
	}	
	else 
	{
		[[NSNotificationCenter defaultCenter] postNotificationOnMainThreadWithName:NewsFeedDidChangeNotification object:self];
	}

}

- (void)saveCache
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:NewsFeedPathString];
	
    if([NSKeyedArchiver archiveRootObject:self.entries toFile:dataPath] == NO)
	{
        NSLog(@"[NewsFeedController saveCache:] Failed to save.");
	}
	else
	{
		NSLog(@"[NewsFeedController saveCache:] Saved with filepath %@", dataPath);
	}
}

- (void)dealloc
{
	[myEntries release]; myEntries = nil;
	
	[super dealloc];
}


#pragma mark Singleton Implementation
//
// Singleton Pattern Implementation
//
//
+ (NewsFeedController *)sharedController
{
    @synchronized(self) 
	{		
        if (theSharedController == nil) 
		{
            [[self alloc] init]; // assignment not done here
        }
    }
	
    return theSharedController;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) 
	{
        if (theSharedController == nil) 
		{
            theSharedController = [super allocWithZone:zone];
            return theSharedController;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released	
}

- (void)release
{
    //do nothing	
}

- (id)autorelease
{
    return self;	
}

@end
