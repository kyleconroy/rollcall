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
@class RollSheetInstance;

@protocol ClassEditProtocol <NSObject>

@optional 
- (void) changeCourseNameFromPrevious:(NSString *)previous to:(NSString *)current;
- (void) changeEnrolledStudents:(NSMutableArray *)students;

@end


@interface RollSheetInfoViewController : UITableViewController <EditTextFieldDelegate, EnrollDelegate, NSFetchedResultsControllerDelegate, UIActionSheetDelegate> {
    
    RollSheetInstance *iView;
    Course *course;
    Roll_CallAppDelegate *aD;
    NSFetchedResultsController *fetchController;
    IBOutlet UITableView *myTableView;
    int courseSection;
    int studentsSection;
    int rowCount;
    bool studentsComplete;
    bool nameComplete;
	IBOutlet UITableViewCell *dsCell;
    
}
@property (nonatomic, retain) RollSheetInstance *iView;
@property (nonatomic, retain) IBOutlet UITableViewCell *dsCell;
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
- (IBAction)deleteCourse;

@end
