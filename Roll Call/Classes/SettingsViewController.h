//
//  SettingsViewController.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roll_CallAppDelegate.h"
#import "AddStatusViewController.h"

@interface SettingsViewController : UITableViewController <AddStatusDelegate, NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController * statusController;
    Roll_CallAppDelegate *aD;
    IBOutlet UITableView * myTableView; 
    int rowCount;
    bool inReorderingOperation;
}

@property(nonatomic, retain) NSFetchedResultsController * statusController;
@property(nonatomic, assign) Roll_CallAppDelegate * aD;
@property(nonatomic, retain) IBOutlet UITableView * myTableView;
@property(nonatomic, assign) int rowCount;
@property(nonatomic, assign) bool inReorderingOperation;

@end
