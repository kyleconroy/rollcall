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
#import "Roll_CallAppDelegate.h"

@interface AddStudentNameViewController : UITableViewController {
	NSString *lastName;
    NSString *firstName;
	AddStudentNameTableCell *tableCell;
	Roll_CallAppDelegate *aD;
}


@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) IBOutlet AddStudentNameTableCell *tableCell;
@property (nonatomic, retain) Roll_CallAppDelegate *aD;
- (void)cancel;
- (void)save;

@end
