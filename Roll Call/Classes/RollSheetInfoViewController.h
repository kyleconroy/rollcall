//
//  RollSheetInfoViewController.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface RollSheetInfoViewController : UITableViewController {
    
    Course *course;
    NSMutableArray *students;
    NSArray *tableLayout;
    NSArray *editTableLayout;
    UITableView *myTableView;
}

@property(nonatomic,assign) Course *course;
@property(nonatomic,assign) NSMutableArray *students;
@property(nonatomic,assign) NSArray *tableLayout;
@property(nonatomic,assign) NSArray *editTableLayout;
@property(nonatomic,assign) UITableView *myTableView;

- (void) enterEditMode;
- (void) leaveEditMode;

@end
