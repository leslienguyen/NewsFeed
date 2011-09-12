//
//  ArticleWebViewController.h
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/6/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleWebViewController : UIViewController <UIWebViewDelegate>
{
	UIActivityIndicatorView *myLoadingIndicator;
}

- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;

@end
