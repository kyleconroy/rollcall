//
//  SettingsViewController.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roll_CallAppDelegate.h"

@interface SettingsViewController : UITableViewController {
    NSMutableArray * statusArray;
    Roll_CallAppDelegate *aD;
    IBOutlet UITableView * myTableView; 
}

@property(nonatomic, assign) Roll_CallAppDelegate * aD;
@property(nonatomic, assign) NSMutableArray * statusArray;
@property(nonatomic, assign) IBOutlet UITableView * myTableView;

- (void) editTable;
- (void) recalculateRank;

@end
