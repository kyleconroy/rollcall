//
//  AddStudentNameTableCell.m
//  Roll Call
//
//  Created by Weizhi on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddStudentNameTableCell.h"


@implementation AddStudentNameTableCell

@synthesize textField, textField1, textField2, textField3;

- (void)dealloc {
	[textField release];
	[textField1 release];
	[textField2 release];
	[textField3 release];
	[super dealloc];
}

@end
