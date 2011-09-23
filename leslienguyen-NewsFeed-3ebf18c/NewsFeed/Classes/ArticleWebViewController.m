//
//  ArticleWebViewController.m
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/6/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import "ArticleWebViewController.h"

@interface ArticleWebViewController ()

@property (nonatomic, readwrite, retain) UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, readonly, retain) UIWebView *webView;

@end


@implementation ArticleWebViewController
@synthesize loadingIndicator=myLoadingIndicator;

- (id)init
{
	self = [super init];
	if (self != nil)
	{
		self.view = [[[UIWebView alloc] init] autorelease];
		self.webView.delegate = self;
		self.webView.dataDetectorTypes = UIDataDetectorTypeLink;
		self.webView.scalesPageToFit = YES;
		
		self.loadingIndicator = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
		CGSize indicatorSize = CGSizeMake(50.0f, 50.0f);
		self.loadingIndicator.frame = CGRectMake(0.0f, 0.0f, indicatorSize.width, indicatorSize.height);
	}
	
	return self;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	// Center the loading indicator.
	UIWindow *window = [self.view window];
	self.loadingIndicator.center = window.center;
	[window addSubview:self.loadingIndicator];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	// Return YES for supported orientations
	return YES;
}

- (UIWebView *)webView
{
	return (UIWebView *)self.view;
}

- (void)dealloc
{
	self.webView.delegate = nil;
	
	[myLoadingIndicator removeFromSuperview];
	[myLoadingIndicator release];
	myLoadingIndicator = nil;
	
    [super dealloc];
}

#pragma mark public access to UIWebView methods

- (void)loadRequest:(NSURLRequest *)request
{
	[self.webView loadRequest:request];
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
	[self.webView loadHTMLString:string baseURL:baseURL];
}

#pragma mark UIWebViewDelegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[self.view addSubview:self.loadingIndicator];
	//[[self superview] bringSubviewToFront:self];

	[self.loadingIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self.loadingIndicator stopAnimating];
	[self.loadingIndicator removeFromSuperview];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	[self.loadingIndicator stopAnimating];
	[self.loadingIndicator removeFromSuperview];
	NSLog(@"[CSIWebViewController webView:didFailLoadWithError:] Web view failed to load with the following error: %@", error);
}


@end
