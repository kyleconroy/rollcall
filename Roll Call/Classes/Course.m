// 
//  Course.m
//  Roll Call
//
//  Created by Kyle Conroy on Apr4.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Course.h"

#import "Presence.h"
#import "Student.h"

@implementation Course 

- (NSComparisonResult) courseCompare:(Course*) c
{
    return [((Course*)self).name compare: c.name];
}

@dynamic startDate;
@dynamic name;
@dynamic endDate;
@dynamic presences;
@dynamic students;

@end
