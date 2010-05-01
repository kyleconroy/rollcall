//
//  StatusInstanceViewController.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Status.h"
#import "EditTextFieldViewController.h"
#import "EditStatusColorViewController.h"
#import "Roll_CallAppDelegate.h"

@interface StatusInstanceViewController : UITableViewController <EditTextFieldDelegate, ColorChangeDelegate> {
    Roll_CallAppDelegate *aD;
    Status *myStatus;
    NSArray *myTableLayout;
    IBOutlet UITableView * myTableView; 
}

@property(nonatomic, assign) Status *myStatus;
@property(nonatomic, retain) NSArray *myTableLayout;
@property(nonatomic, retain) IBOutlet UITableView * myTableView;
@property(nonatomic, assign) Roll_CallAppDelegate *aD;

- (void) editStatus;

@end
