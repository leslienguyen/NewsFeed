//
//  NSNotificationCenter+LNExtension.h
//  NewsFeed
//
//  Created by Leslie Nguyen on 9/5/11.
//  Copyright 2011 Leslie Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSNotificationCenter (LNExtension)

- (void)postNotificationOnMainThread:(NSNotification *)aNote;

- (void)postNotificationOnMainThreadWithName:(NSString *)aName object:(id)anObject;

- (void)postNotificationOnMainThreadWithName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;

@end
