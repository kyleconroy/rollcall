//
//  RollSheetInstance.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface RollSheetInstance : UIViewController <UITableViewDelegate> {
    Course *course;
    NSArray * studentsArray;
    UITableView *myTableView;
    NSDate *myDate;
    
    IBOutlet UITableViewCell *tvCell;
    IBOutlet UIButton *backDate;
    IBOutlet UIButton *forwardDate;
    IBOutlet UILabel *displayDate;
}

@property(nonatomic, retain) Course *course;
@property(nonatomic, retain) NSArray * studentsArray;
@property(nonatomic, retain) UITableView *myTableView;
@property(nonatomic, retain) NSDate *myDate;

@property(nonatomic, retain) IBOutlet UITableViewCell *tvCell;
@property(nonatomic, retain)  IBOutlet UIButton *backDate;
@property(nonatomic, retain)  IBOutlet UIButton *forwardDate;
@property(nonatomic, retain)  IBOutlet UILabel *displayDate;

-(void) updateDisplayDate;
- (IBAction)addNote:(id)sender;
- (IBAction)moveBackOneDay;
- (IBAction)moveForwardOneDay;


@end
