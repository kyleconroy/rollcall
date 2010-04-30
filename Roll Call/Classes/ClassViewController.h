//
//  ClassViewController.h
//  Roll Call
//
//  Created by Kyle Conroy on Mar22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roll_CallAppDelegate.h"
#import "Course.h"
#import "EnrollStudentsViewController.h"

@interface ClassViewController : UITableViewController {
    Roll_CallAppDelegate *aD;
	Course *selectedCourse;
	IBOutlet UIButton *enrollStudents;
	EnrollStudentsViewController *enrollStudentsViewController;
	
}

@property(nonatomic, retain) Roll_CallAppDelegate *aD;
@property (nonatomic, retain) Course *selectedCourse;
@property (nonatomic, retain) IBOutlet UIButton *enrollStudents;
@property (nonatomic, retain) EnrollStudentsViewController *enrollStudentsViewController;

- (IBAction) enrollStudentsInClass: (id) sender;

@end
