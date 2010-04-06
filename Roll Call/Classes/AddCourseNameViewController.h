//
//  AddStudentNameViewController.h
//  Roll Call
//
//  Created by Weizhi Li on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AddStudentViewController.h"
#import "AddStudentNameTableCell.h"
@class Student;

@interface AddCourseNameViewController : UITableViewController {
    NSString *firstName;
    NSString *labelText;
	Student *student;
	AddStudentNameTableCell *tableCell;
    UITableViewCell *parentCell;
}

@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) IBOutlet AddStudentNameTableCell *tableCell;
@property (nonatomic, retain) Student *student;
@property (nonatomic, retain) UITableViewCell *parentCell;
@property (nonatomic, retain) NSString *labelText;
- (void)cancel;
- (void)save;

@end
