//
//  AddAddressViewController.h
//  Roll Call
//
//  Created by Weizhi on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddStudentViewController.h"
#import "AddStudentNameTableCell.h"

@class Student;

@interface AddAddressViewController : UITableViewController {
	NSString *state;
    NSString *city;
	NSString *street;
	NSString *apt;
	NSString *zip;
	Student *student;
	AddStudentNameTableCell *tableCell;
}

@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *street;
@property (nonatomic, retain) NSString *apt;
@property (nonatomic, retain) NSString *zip;
@property (nonatomic, retain) IBOutlet AddStudentNameTableCell *tableCell;
@property (nonatomic, retain) Student *student;
- (void)cancel;
- (void)save;

@end
