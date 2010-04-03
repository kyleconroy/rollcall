//
//  StudentViewController.h
//  Roll Call
//
//  Created by Weizhi Li on Mar22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roll_CallAppDelegate.h"
#import "Student.h"

@interface StudentViewController : UITableViewController {
    Roll_CallAppDelegate *aD;
    Student *currentStudent;
}

@property(nonatomic, retain) Roll_CallAppDelegate *aD;
@property(nonatomic, retain) Student *currentStudent;

@end
