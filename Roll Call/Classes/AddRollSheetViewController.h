//
//  AddRollSheetViewController.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr5.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roll_CallAppDelegate.h"
#import "EditTextFieldViewController.h"
#import "EnrollStudentsViewController.h"
#import "Course.h"

@class AddRollSheetViewController;

@protocol AddCourseDelegate <NSObject>

- (void) addRollSheetViewController:(AddRollSheetViewController*)addRollSheetViewController withCourse:(Course *)course;

@end



@interface AddRollSheetViewController : UITableViewController <EditTextFieldDelegate, EnrollDelegate> {
    
    id <AddCourseDelegate> delegate;
    Roll_CallAppDelegate *aD;
    NSMutableArray *addedStudents;
    NSString *courseName;
    IBOutlet UITableView *myTableView;
    
    int courseSection;
    int studentsSection;
    bool studentsComplete;
    bool nameComplete;
    
}
    
@property (readwrite, assign) id <AddCourseDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *addedStudents;
@property (nonatomic, retain) NSString *courseName;
@property (nonatomic, retain) Roll_CallAppDelegate *aD;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (readwrite, assign) int studentsSection;
@property (readwrite, assign) int courseSection;
@property (readwrite, assign) bool nameComplete;
@property (readwrite, assign) bool studentsComplete;

- (IBAction) enrollStudentsInClass: (id) sender;

- (void) save;
- (void) cancel;

@end
