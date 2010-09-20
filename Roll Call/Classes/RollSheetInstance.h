//
//  RollSheetInstance.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "Roll_CallAppDelegate.h"
#import "ChangeDateViewController.h"

@interface RollSheetInstance : UIViewController <UITableViewDelegate, DateChangeDelegate, NSFetchedResultsControllerDelegate> {
    Course *course;
    Roll_CallAppDelegate *aD;
    
    NSArray * studentsArray;
    NSIndexPath *currentIndexPath;
    NSMutableArray * presencesArray;
    NSMutableArray * statusArray;
    NSFetchedResultsController * fetchController;
    
    NSDate *myDate;
    NSDate *datePickerDate;
    bool datePickerVisible;
    bool manualUpdate;

    IBOutlet UIButton *backDate;
    IBOutlet UIButton *forwardDate;
    IBOutlet UIButton *displayDate;
    IBOutlet UITableViewCell *tvCell;
    IBOutlet UITableView *myTableView;
    IBOutlet UIButton *markDefault;
	int pop;
    
}

@property (nonatomic) int pop;
@property (nonatomic, retain) Course *course;
@property (nonatomic, retain) NSFetchedResultsController * fetchController;
@property (nonatomic, retain) NSMutableArray * presencesArray;
@property (nonatomic, retain) NSArray * studentsArray;
@property (nonatomic, retain) NSDate *myDate;
@property (nonatomic, retain) NSDate *datePickerDate;
@property (nonatomic, retain) Roll_CallAppDelegate *aD;
@property (readwrite, assign) bool datePickerVisible;
@property (readwrite, assign) bool manualUpdate;
@property (nonatomic, retain) NSIndexPath *currentIndexPath;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet UIButton *backDate;
@property (nonatomic, retain) IBOutlet UIButton *markDefault;
@property (nonatomic, retain) IBOutlet UIButton *forwardDate;
@property (nonatomic, retain) IBOutlet UIButton *displayDate;
@property (nonatomic, retain) IBOutlet UITableViewCell *tvCell;
@property (nonatomic, assign) NSMutableArray * statusArray;

- (IBAction) moveBackOneDay;
- (IBAction) moveForwardOneDay;
- (IBAction) addNote:(id)sender;
- (IBAction) changeAttendance:(id)sender;
- (IBAction) showDatePicker;
- (IBAction) markEmptyDefault;

- (NSDate *) todayWithDate:(NSDate *)date;
- (NSDate *) tomorrowWithDate:(NSDate *)date;

- (void) updateDate:(NSDate *)date;
- (void) updateAttendance:(UITableViewRowAnimation)rowAnimation;
- (void) showCourseInfo;

@end
