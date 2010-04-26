//
//  AddPhoneViewController.h
//  Roll Call
//
//  Created by Weizhi on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddStudentViewController.h"
#import "AddStudentNameTableCell.h"
@class Student;

@interface AddPhoneViewController : UITableViewController {
	NSString *phone;
	Student *student;
	AddStudentNameTableCell *tableCell;
}

@property (nonatomic, retain) NSString *phone;
@property (nonatomic, retain) IBOutlet AddStudentNameTableCell *tableCell;
@property (nonatomic, retain) Student *student;

- (void)cancel;
- (void)save;

@end
