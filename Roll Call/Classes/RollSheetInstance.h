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

@interface RollSheetInstance : UIViewController <UITableViewDelegate> {
    Course *course;
    Roll_CallAppDelegate *aD;
    
    NSArray * studentsArray;
    NSIndexPath *currentIndexPath;
    NSMutableArray * presencesArray;
    NSDate *myDate;
    NSDate *datePickerDate;
    bool datePickerVisible;

    IBOutlet UIButton *backDate;
    IBOutlet UIButton *forwardDate;
    IBOutlet UIButton *displayDate;
    IBOutlet UITableViewCell *tvCell;
    IBOutlet UITableView *myTableView;
    IBOutlet UIView *myPickerView;
    
}

@property(nonatomic, retain) Course *course;
@property(nonatomic, retain) NSMutableArray * presencesArray;
@property(nonatomic, retain) NSArray * studentsArray;
@property(nonatomic, retain) NSDate *myDate;
@property(nonatomic, retain) NSDate *datePickerDate;
@property(nonatomic, retain) Roll_CallAppDelegate *aD;
@property (readwrite, assign) bool datePickerVisible;
@property(nonatomic, retain) NSIndexPath *currentIndexPath;
@property(nonatomic, retain) IBOutlet UITableView *myTableView;
@property(nonatomic, retain) IBOutlet UIView *myPickerView;
@property(nonatomic, retain) IBOutlet UIButton *backDate;
@property(nonatomic, retain) IBOutlet UIButton *forwardDate;
@property(nonatomic, retain) IBOutlet UIButton *displayDate;
@property(nonatomic, retain) IBOutlet UITableViewCell *tvCell;

- (IBAction) moveBackOneDay;
- (IBAction) moveForwardOneDay;
- (IBAction) addNote:(id)sender;
- (IBAction) changeAttendance:(id)sender;
- (IBAction) showDatePicker;
- (IBAction) cancelDatePicker;
- (IBAction) doneDatePicker;

- (NSDate *) todayWithDate:(NSDate *)date;
- (NSDate *) tomorrowWithDate:(NSDate *)date;

- (void) updateDisplayDate;
- (void) hideDatePicker;
- (void) showCourseInfo;

@end
