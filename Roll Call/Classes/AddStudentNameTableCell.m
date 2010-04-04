//
//  AddStudentNameTableCell.m
//  Roll Call
//
//  Created by Weizhi on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddStudentNameTableCell.h"


@implementation AddStudentNameTableCell

@synthesize textField;

- (void)dealloc {

	[textField release];
	[super dealloc];
}

@end
