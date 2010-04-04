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
	NSString		*savedSearchTerm;
    BOOL			searchWasActive;
	NSMutableArray	*filteredListContent;
	NSMutableArray *sectionsArray;
	NSMutableArray *students;
	UILocalizedIndexedCollation *collation;
	
}

@property (nonatomic, retain) NSMutableArray *students;
@property(nonatomic, retain) Roll_CallAppDelegate *aD;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) BOOL searchWasActive;
@property (nonatomic, retain) NSMutableArray *sectionsArray;
@property (nonatomic, retain) UILocalizedIndexedCollation *collation;

- (void) addStudent;
- (void)configureSections ;

@end
