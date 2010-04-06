//
//  ClassesViewController.h
//  Roll Call
//
//  Created by Kyle Conroy on Mar22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roll_CallAppDelegate.h"

@interface ClassesViewController : UITableViewController {
    Roll_CallAppDelegate *aD;
    NSMutableArray *coursesArray;
}

@property(nonatomic, retain) Roll_CallAppDelegate *aD;
@property(nonatomic, retain) NSMutableArray *coursesArray;

- (void) addRollSheet;

@end
