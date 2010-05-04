//
//  AttendanceTableViewController.h
//  Roll Call
//
//  Created by Weizhi on 4/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"
@class Status;
@class KalViewController;

@interface AttendanceTableViewController : UIViewController<UITableViewDelegate> {
	Student *student;
	NSMutableArray *statuses;
	NSInteger type;
	UITableViewCell *myCell;
	IBOutlet UILabel  *courseL;
	IBOutlet UILabel  *dateL;
	IBOutlet UIButton  *aB;
	NSString *myTitle;
	IBOutlet UIButton  *addB;
	IBOutlet UILabel  *addL;
	IBOutlet UIButton  *indicator;
	KalViewController *kal;
	IBOutlet UITableView *tableView;
}

@property(nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger type;
@property(nonatomic, retain) KalViewController *kal;
@property(nonatomic, retain) Student *student;
@property(nonatomic, retain) NSMutableArray *statuses;
@property(nonatomic, retain) IBOutlet UITableViewCell *myCell;
@property(nonatomic, retain) IBOutlet UILabel  *courseL;
@property(nonatomic, retain) IBOutlet UILabel  *dateL;
@property(nonatomic, retain) IBOutlet UIButton  *aB;
@property(nonatomic, retain) NSString *myTitle;

//- (IBAction) showGraph;
- (IBAction) addNote;
- (IBAction)setEditing:(BOOL)editing animated:(BOOL)animated;

@end
