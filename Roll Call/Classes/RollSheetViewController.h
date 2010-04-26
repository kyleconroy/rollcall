//
//  RollSheetViewController.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roll_CallAppDelegate.h"

@interface RollSheetViewController : UITableViewController {
    
    NSMutableArray *coursesArray;
    NSManagedObjectContext *managedObjectContext;
    Roll_CallAppDelegate *aD;
    
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) Roll_CallAppDelegate *aD;
@property(nonatomic, retain) NSMutableArray *coursesArray;

- (void) addRollSheet;

@end
