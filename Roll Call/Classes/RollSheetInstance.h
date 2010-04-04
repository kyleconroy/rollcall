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
    IBOutlet UITableViewCell *tvCell;
}

@property(nonatomic, retain) Course *course;
@property(nonatomic, retain) NSArray * studentsArray;
@property(nonatomic, retain) UITableView *myTableView;
@property(nonatomic, retain) IBOutlet UITableViewCell *tvCell;

- (IBAction)addNote:(id)sender;

@end
