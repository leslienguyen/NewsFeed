//
//  NSDictionary+Extensions.h
//  GrouponiPad
//
//  Created by Leslie Nguyen on 12/16/11.
//  Copyright (c) 2011 Groupon. All rights reserved.
//

// this is needed to handle all the NSNull object

#import <Foundation/Foundation.h>

@interface NSDictionary (Extensions)

- (id)objectForKeyNotNull:(id)key; 
- (id)valueForKeyNotNull:(id)key; 
-(id)valueForKeyPathNotNull:(id)key;

@end
