//
//  Student.m
//  Roll Call
//
//  Created by Kyle Conroy on Mar22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Student.h"


@implementation Student

@synthesize firstName;
@synthesize lastName;

- (id)initWithFirstName:(NSString *)myFirstName lastName:(NSString *)myLastName {
    self.firstName = myFirstName;
    self.lastName = myLastName;
    return self;
}

- (void)dealloc {
    [super dealloc];
}

@end
