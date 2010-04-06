//
//  AddRollSheetViewController.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr5.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roll_CallAppDelegate.h"
#import "Course.h"
#import "EnrollStudentsViewController.h"

@interface AddRollSheetViewController : UITableViewController {

    Roll_CallAppDelegate *aD;
    Course *selectedCourse;
    IBOutlet UIButton *enrollStudents;
    EnrollStudentsViewController *enrollStudentsViewController;
    NSMutableArray *addedStudents;
    NSString *courseName;
    
}
    
@property(nonatomic, retain) Roll_CallAppDelegate *aD;
@property (nonatomic, retain) Course *selectedCourse;
@property (nonatomic, retain) IBOutlet UIButton *enrollStudents;
@property (nonatomic, retain) EnrollStudentsViewController *enrollStudentsViewController;
@property (nonatomic, retain)  NSMutableArray *addedStudents;
@property (readwrite, assign) NSString *courseName;

- (IBAction) enrollStudentsInClass: (id) sender;

- (void) save;
- (void) cancel;
- (void) addDate;
- (void) addTime;
- (void) addName;

@end
