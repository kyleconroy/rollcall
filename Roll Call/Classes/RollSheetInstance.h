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
    NSMutableArray * presencesArray;
    NSDate *myDate;
    UITableView *myTableView;
    
    IBOutlet UIButton *backDate;
    IBOutlet UIButton *forwardDate;
    IBOutlet UILabel *displayDate;
    IBOutlet UITableViewCell *tvCell;
}

@property(nonatomic, retain) Course *course;
@property(nonatomic, retain) NSMutableArray * presencesArray;
@property(nonatomic, retain) NSArray * studentsArray;
@property(nonatomic, retain) NSDate *myDate;
@property(nonatomic, retain) Roll_CallAppDelegate *aD;
@property(nonatomic, retain) UITableView *myTableView;


@property(nonatomic, retain)  IBOutlet UIButton *backDate;
@property(nonatomic, retain)  IBOutlet UIButton *forwardDate;
@property(nonatomic, retain)  IBOutlet UILabel *displayDate;
@property(nonatomic, retain)  IBOutlet UITableViewCell *tvCell;

- (IBAction) moveBackOneDay;
- (IBAction) moveForwardOneDay;
- (IBAction) addNote:(id)sender;

- (NSDate *) today;
- (NSDate *) tomorrow;

- (void) updateDisplayDate;
- (void) initializeData;

@end
