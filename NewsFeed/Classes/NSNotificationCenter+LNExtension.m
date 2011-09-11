//
//  NSNotificationCenter+LNExtension.m
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/5/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import "NSNotificationCenter+LNExtension.h"


@implementation NSNotificationCenter (LNExtensions)

- (void)postNotificationOnMainThread:(NSNotification *)aNote
{
	[self performSelectorOnMainThread:@selector(postNotification:) withObject:aNote waitUntilDone:YES];
}

- (void)postNotificationOnMainThreadWithName:(NSString *)aName object:(id)anObject
{
	NSNotification *note = [NSNotification notificationWithName:aName object:anObject];
	[self postNotificationOnMainThread:note];
}

- (void)postNotificationOnMainThreadWithName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo
{
	NSNotification *note = [NSNotification notificationWithName:aName object:anObject userInfo:aUserInfo];
	[self postNotificationOnMainThread:note];
}

@end
