//
//  RollSheetViewController.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roll_CallAppDelegate.h"
#import "AddRollSheetViewController.h"
@interface RollSheetViewController : UITableViewController <AddCourseDelegate> {
    
    NSMutableArray *coursesArray;
    NSManagedObjectContext *managedObjectContext;
    Roll_CallAppDelegate *aD;
    IBOutlet UITableView *myTableView;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Roll_CallAppDelegate *aD;
@property (nonatomic, retain) NSMutableArray *coursesArray;
@property (nonatomic, retain) IBOutlet UITableView *myTableView;

- (void) addRollSheet;
- (void) installStatuses;
@end
