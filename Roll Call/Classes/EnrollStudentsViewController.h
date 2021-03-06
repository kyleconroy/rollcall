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

@optional
- (void)enrollStudentsViewController:(EnrollStudentsViewController *)enrollStudentsViewController

                        withAdded:(NSMutableArray *)added removed:(NSMutableArray *)removed;

@end

@interface EnrollStudentsViewController : UITableViewController {
    id <EnrollDelegate> delegate;
    Roll_CallAppDelegate *aD;
    NSMutableArray *chosen;
    NSMutableArray *students;
    NSArray *initial;
    UITableView *myTableView;
}   

@property (nonatomic, assign) id <EnrollDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *chosen;
@property (nonatomic, retain) NSMutableArray *students;
@property (nonatomic, retain) NSArray *initial;
@property (nonatomic, assign) Roll_CallAppDelegate *aD;
@property (nonatomic, assign) UITableView *myTableView;

- (void) cancel;
- (void) save;

@end
