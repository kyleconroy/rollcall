//
//  AttendanceTableViewController.h
//  Roll Call
//
//  Created by Weizhi on 4/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"

@interface AttendanceTableViewController : UITableViewController {
	Student *student;
	NSMutableArray *statuses;
	NSInteger type;
}
@property (nonatomic) NSInteger type;
@property(nonatomic, retain) Student *student;
@property(nonatomic, retain) NSMutableArray *statuses;

@end
