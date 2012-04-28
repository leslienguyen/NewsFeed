//
//  NewsFeedController.m
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/5/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import "FeedDownloader.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "NewsFeedItem.h"
#import "NSNotificationCenter+LNExtension.h"
#import "DDURLParser.h"

static FeedDownloader *theSharedController = nil;

NSString *NewsFeedDidChangeNotification = @"NewsFeedDidChangeNotification";
NSString *NewsFeedRequestDidFailNotification = @"NewsFeedRequestDidFailNotification";
NSString *NewsFeedErrorKey = @"NewsFeedErrorKey";
NSString *NewsFeedPathString = @"NewsFeedEntries";

@interface FeedDownloader()

@property (nonatomic, readwrite, retain) NSMutableArray *entries;

- (void)makeRequest:(NSString*)feedString;
- (void)parseData:(NSString*)jsonString;
- (void)loadCache;

@end

@implementation FeedDownloader

@synthesize entries = myEntries;

+ (FeedDownloader *)sharedController
{
    @synchronized(self) 
	{		
        if (theSharedController == nil) 
		{
            theSharedController = [[self alloc] init]; // assignment not done here
        }
    }
	
    return theSharedController;
}

- (id)init
{
	self = [super init];
	
	if(self != nil)
	{
		[self loadCache];
	}
	return self;
}

- (void)downloadFeed:(FeedType)type withSuccessBlock:(FeedBlock)block
{
    switch (type) {
        case FeedTypeTechcrunch:
            [self makeRequest:@"http://feeds.feedburner.com/TechCrunch"];
            break;
            
        default:
            break;
    }
}


- (void)makeRequest:(NSString *)feedString
{
	//create my own autorelease pool because this is in a background thread
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSLog(@"[NewsFeedController makeRequest:]");
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/feed/load?q=%@&v=1.0&output=json&num=18", feedString]];
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
	[request startAsynchronous];	
	
	[pool release];
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
	
	[self performSelectorInBackground:@selector(parseData:) withObject:jsonString];
}

- (void)parseData:(NSString*)jsonString
{	
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
			
				//get the image
				urlString = [content objectForKey:@"url"];
                
                //remove the width param
                DDURLParser *parser = [[[DDURLParser alloc] initWithURLString:urlString] autorelease];
                NSString *y = [parser valueForVariable:@"w"];
                
                if(y != nil)
                {
                    NSString *width = [NSString stringWithFormat:@"?w=%@", y];
                    urlString = [urlString stringByReplacingOccurrencesOfString:width withString:@""]; 
                }
                   
                [item setImageUrl:urlString];
                
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
//								
//				//get thumbnail
//				
				NSArray *thumbnails = [content objectForKey:@"thumbnails"];
				NSDictionary *thumbnailDict = [thumbnails lastObject];
				
				urlString = [thumbnailDict objectForKey:@"url"];
                
                //remove the width param
                parser = [[[DDURLParser alloc] initWithURLString:urlString] autorelease];
                y = [parser valueForVariable:@"w"];
                
                if(y != nil)
                {
                    NSString *width = [NSString stringWithFormat:@"?w=%@", y];
                    urlString = [urlString stringByReplacingOccurrencesOfString:width withString:@"?w=400"]; 
                }
                
                [item setThumbnailUrl:urlString];
                
                
                
//				if([urlString length] > 0)
//				{
//					url = [NSURL URLWithString:urlString];
//					image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]]; 
//					
//					if(image)
//					{
//						[item setThumbnail:image];
//						break; 	//currently don't need to fetch all thumbnails
//					}
//				}
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


@end
