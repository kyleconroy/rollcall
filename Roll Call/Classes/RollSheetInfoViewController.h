//
//  RollSheetInfoViewController.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roll_CallAppDelegate.h"
#import "EditTextFieldViewController.h"
#import "EnrollStudentsViewController.h"
#import "Course.h"

@protocol ClassEditProtocol <NSObject>

@optional 
- (void) changeCourseNameFromPrevious:(NSString *)previous to:(NSString *)current;
- (void) changeEnrolledStudents:(NSMutableArray *)students;

@end


@interface RollSheetInfoViewController : UITableViewController <EditTextFieldDelegate, EnrollDelegate> {
    
    
    Course *course;
    Roll_CallAppDelegate *aD;
    NSMutableArray *addedStudents;
    NSString *courseName;
    IBOutlet UITableView *myTableView;
    
    int courseSection;
    int studentsSection;
    bool studentsComplete;
    bool nameComplete;
    
}

@property (nonatomic, assign) Course *course;
@property (nonatomic, retain) NSMutableArray *addedStudents;
@property (nonatomic, retain) NSString *courseName;
@property (nonatomic, retain) Roll_CallAppDelegate *aD;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (readwrite, assign) int studentsSection;
@property (readwrite, assign) int courseSection;
@property (readwrite, assign) bool nameComplete;
@property (readwrite, assign) bool studentsComplete;

- (IBAction) enrollStudentsInClass: (id) sender;

@end
