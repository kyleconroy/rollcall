//
//  AttendanceTableViewController.m
//  Roll Call
//
//  Created by Weizhi on 4/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AttendanceTableViewController.h"
#import "Presence.h"
#import "Status.h"
#import "Course.h"
#import "Student.h"
#import "Roll_CallAppDelegate.h"
#import "NoteViewController.h"
#import "RollSheetInstance.h"

@implementation AttendanceTableViewController

@synthesize statuses;
@synthesize student;
@synthesize type;

- (void)viewDidLoad {
    [super viewDidLoad];
	statuses= [[NSMutableArray alloc] init];
	//self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
	self.title = @"Add Course";
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
	if (type==0) 
		self.title = @"Tardy";
	if (type==1) 
		self.title = @"Absence";
	if (type==2) 
		self.title = @"Excused Absence";
	if (type==3) 
		self.title = @"Notes";
	NSMutableArray *presences=nil;
	if (student.presences!=nil)
		presences= [[NSMutableArray alloc] initWithArray:[student.presences allObjects]];
	for (Presence *presence in presences) {
		if (type==0) {
			if ([presence.status.letter isEqualToString:@"T"]) {
				[statuses addObject:presence];
			}
		}
		if (type==1) {
			if ([presence.status.letter isEqualToString:@"A"]) {
				[statuses addObject:presence];
			}
		}
		if (type==2) {
			if ([presence.status.letter isEqualToString:@"E"]) {
				[statuses addObject:presence];
			}
		}
		if (type==3) {
			if (presence.note!=nil) {
				[statuses addObject:presence];
			}
		}
	}	
	[presences release];
	[super viewWillAppear:animated];
	
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger count= [statuses count];
	return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.accessoryType = UITableViewCellAccessoryNone;
	Presence  *presence=[statuses objectAtIndex:indexPath.row];
	cell.textLabel.text=presence.course.name;
	cell.textLabel.textAlignment=UITextAlignmentLeft;
	cell.textLabel.minimumFontSize=22;
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"ha, EEEE MMMM d"];
	NSDate *date=presence.date;
	NSString *theDate = [dateFormat stringFromDate:date];
	cell.detailTextLabel.text=[NSString stringWithFormat:@"%@", theDate];
	cell.detailTextLabel.textAlignment=UITextAlignmentRight;
	cell.detailTextLabel.minimumFontSize=22;
	[dateFormat release];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Presence  *presence=[statuses objectAtIndex:indexPath.row];
	if (type==3) {
		NoteViewController *myNoteView = [[NoteViewController alloc] initWithNibName:@"NoteViewController" bundle:nil];
		myNoteView.presence=presence;
		[self presentModalViewController:myNoteView animated:YES];
	}
/*	
	else {
		RollSheetInstance *rollView = [[RollSheetInstance alloc] initWithNibName:@"RollSheetInstance" bundle:nil];
		[rollView setMyDate:presence.date];
		rollView.course=presence.course;
		[self.navigationController pushViewController:rollView animated:YES];
	}
*/
		
}	


- (void)dealloc {
	[statuses release];
	[student release];
    [super dealloc];
}


@end

