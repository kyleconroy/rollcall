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


@interface RollSheetInfoViewController : UITableViewController <EditTextFieldDelegate, EnrollDelegate, NSFetchedResultsControllerDelegate> {
    
    
    Course *course;
    Roll_CallAppDelegate *aD;
    NSFetchedResultsController *fetchController;
    IBOutlet UITableView *myTableView;
    int courseSection;
    int studentsSection;
    int rowCount;
    bool studentsComplete;
    bool nameComplete;
    
}

@property (nonatomic, assign) Course *course;
@property (nonatomic, retain) NSFetchedResultsController *fetchController;
@property (nonatomic, retain) Roll_CallAppDelegate *aD;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (readwrite, assign) int studentsSection;
@property (readwrite, assign) int courseSection;
@property (readwrite, assign) int rowCount;
@property (readwrite, assign) bool nameComplete;
@property (readwrite, assign) bool studentsComplete;

- (IBAction) enrollStudentsInClass: (id) sender;

@end
