//
//  SchoolClass.m
//  Roll Call
//
//  Created by Kyle Conroy on Mar22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SchoolClass.h"


@implementation SchoolClass

@synthesize className;

- (id)initWithName:(NSString *)name {
    className = name;
    return self;
}
@end
