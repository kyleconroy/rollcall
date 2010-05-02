//
//  EnrollStudentsViewController.h
//  Roll Call
//
//  Created by Kyle Conroy on May1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roll_CallAppDelegate.h"

@class EnrollStudentsViewController;

@protocol EnrollDelegate <NSObject>

- (void)enrollStudentsViewController:(EnrollStudentsViewController *)enrollStudentsViewController

                        withStudents:(NSMutableArray *)enrolled;

@end

@interface EnrollStudentsViewController : UITableViewController {
    id <EnrollDelegate> delegate;
    Roll_CallAppDelegate *aD;
    NSMutableArray *chosen;
    NSMutableArray *students;
    NSMutableArray *initial;
    UITableView *myTableView;
}   

@property (nonatomic, assign) id <EnrollDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *chosen;
@property (nonatomic, retain) NSMutableArray *students;
@property (nonatomic, retain) NSMutableArray *initial;
@property (nonatomic, assign) Roll_CallAppDelegate *aD;
@property (nonatomic, assign) UITableView *myTableView;

- (void) cancel;
- (void) save;

@end
