//
//  GrouponDictionary.m
//  GrouponiPad
//
//  Created by Leslie Nguyen on 12/16/11.
//  Copyright (c) 2011 Groupon. All rights reserved.
//

#import "NSDictionary+Extensions.h"

@implementation NSDictionary (Extensions)

// in case of [NSNull null] values a nil is returned ...
- (id)objectForKeyNotNull:(id)key 
{
    id object = [self objectForKey:key];
    if (object == [NSNull null])
        return nil;
    
    return object;
}

- (id)valueForKeyNotNull:(id)key 
{
    id object = [self valueForKey:key];
    if (object == [NSNull null])
        return nil;
    
    return object;
}

-(id)valueForKeyPathNotNull:(id)key
{
    id object = [self valueForKeyPath:key];
    if (object == [NSNull null])
        return nil;
    
    return object;

}

@end
