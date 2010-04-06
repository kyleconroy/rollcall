//
//  StudentsViewController.h
//  Roll Call
//
//  Created by Weizhi Li on Mar22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Roll_CallAppDelegate.h"

@interface StudentsViewController : UITableViewController {
    Roll_CallAppDelegate *aD;
	NSMutableArray	*filteredListContent;
	NSMutableArray *sectionsArray;
	UILocalizedIndexedCollation *collation;
	
}

@property(nonatomic, retain) Roll_CallAppDelegate *aD;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) NSMutableArray *sectionsArray;
@property (nonatomic, retain) UILocalizedIndexedCollation *collation;

- (void) addStudent;
- (void)configureSections ;

@end    
