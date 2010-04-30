//
//  AddCourseViewController.h
//  Roll Call
//
//  Created by Weizhi on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roll_CallAppDelegate.h"
#import "Student.h"
@interface AddCourseViewController : UITableViewController {
	Roll_CallAppDelegate *aD;
	Student *student;
}

@property(nonatomic, retain) Roll_CallAppDelegate *aD;
@property(nonatomic, retain) Student *student;

- (void)cancel;
@end
