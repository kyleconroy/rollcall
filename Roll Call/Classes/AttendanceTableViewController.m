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
#import "NoteViewController.h"
#import "RollSheetInstance.h"
#import "AttendanceEditViewController.h"
#import "GraphController.h"
#import "RollSheetAddNoteController.h"
#import "Roll_CallAppDelegate.h"
#import "KalViewController.h"

@implementation AttendanceTableViewController

@synthesize statuses;
@synthesize student;
@synthesize type;
@synthesize myCell;
@synthesize courseL;
@synthesize dateL;
@synthesize aB;
@synthesize myTitle;
@synthesize kal;
@synthesize tableView;

- (void)viewDidLoad {
	
	[super viewDidLoad];
	UIView *footer = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 45)] autorelease];
	footer.backgroundColor = [UIColor clearColor];
	self.tableView.tableFooterView = footer;
	self.title=myTitle;
	self.tableView.allowsSelectionDuringEditing=YES;
	if (type!=1) {
	UIBarButtonItem *rButton = [[UIBarButtonItem alloc]
                                     initWithTitle:NSLocalizedString(@"Graph", @"Graph - Monthly Overview")
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(showGraph)];
    self.navigationItem.rightBarButtonItem = rButton;
    [rButton release];
	[footer release];
	} else {
		//self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(setEditing)];
	 self.navigationItem.rightBarButtonItem = self.editButtonItem;
	}
	//self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
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
	if (type==1) {
		NSMutableArray *presences=nil;
		statuses=[[NSMutableArray alloc] init];
		if (student.presences!=nil)
			presences= [[NSMutableArray alloc] initWithArray:[student.presences allObjects]];
		for (Presence *presence in presences) {
			if (presence.note!=nil) {
				[statuses addObject:presence];
			}
		}
	}
	[self.tableView reloadData];
	[super viewWillAppear:animated];
}

/*
- (IBAction) showGraph {
	GraphController *vc = [[GraphController alloc] init];
	vc.presences=statuses;
	vc.lastName=student.lastName;
	vc.firstName=student.firstName;
	vc.statusText=myTitle;
	[vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	[self presentModalViewController:vc animated:YES];
	[vc release];	
}
 */

- (IBAction) addNote {
	Roll_CallAppDelegate *aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context=[aD managedObjectContext];
	RollSheetAddNoteController *myNoteView = [[RollSheetAddNoteController alloc] initWithNibName:@"RollSheetAddNoteController" bundle:nil];
	Presence *presence = (Presence *)[NSEntityDescription insertNewObjectForEntityForName:@"Presence" inManagedObjectContext:context];
	presence.date=[NSDate date];
	[student addPresencesObject:presence];
	myNoteView.presence=presence;
	[self presentModalViewController:myNoteView animated:YES];
	[myNoteView release];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (self.editing&&type==1) {
		NSMutableArray *presences=nil;
		statuses=[[NSMutableArray alloc] init];
		if (student.presences!=nil)
			presences= [[NSMutableArray alloc] initWithArray:[student.presences allObjects]];
		for (Presence *presence in presences) {
			if (presence.note!=nil) {
				[statuses addObject:presence];
			}
		}
	}
	NSInteger count= [statuses count];
	if (self.editing) 
		return count+1;
	NSLog (@"count %i",count); 
	return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableview cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *mCellIdentifier = @"mCell";
	UITableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:mCellIdentifier];
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"AttCell" owner:self options:nil];
		cell = myCell;
		self.myCell = nil;
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	cell.selectionStyle = UITableViewCellSelectionStyleBlue;
	courseL.hidden=NO;
	dateL.hidden=NO;
	aB.hidden=NO;
	addB.hidden=YES;
	indicator.hidden=YES;
	addL.hidden=YES;
	if (type==1) {
		if (indexPath.row < ([statuses count])) {
			[aB setBackgroundImage:[UIImage imageNamed:@"note_outline.png"] forState:UIControlStateNormal];
			Presence  *presence=[statuses objectAtIndex:indexPath.row];
			courseL.text=presence.course.name;
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			[dateFormat setDateFormat:@"ha, EEEE MMMM d"];
			NSDate *date=presence.date;
			NSString *theDate = [dateFormat stringFromDate:date];
			dateL.text=[NSString stringWithFormat:@"%@", theDate];
			if (self.editing)
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			[dateFormat release];
			return cell;
		} 
		courseL.hidden=YES;
		dateL.hidden=YES;
		aB.hidden=YES;
		addB.hidden=NO;
		indicator.hidden=NO;
		addL.hidden=NO;
		return cell;
	}
	else {
	Presence  *presence=[statuses objectAtIndex:indexPath.row];
	courseL.text=presence.course.name;
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"ha, EEEE MMMM d"];
	NSDate *date=presence.date;
	NSString *theDate = [dateFormat stringFromDate:date];
	dateL.text=[NSString stringWithFormat:@"%@", theDate];
	[dateFormat release];
	[aB setTitle:presence.status.letter forState: UIControlStateNormal];
	[aB setBackgroundImage:[UIImage imageNamed:presence.status.imageName] forState:UIControlStateNormal];
	return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Presence  *presence=[statuses objectAtIndex:indexPath.row];
	if (type==1) {
		if (indexPath.row < ([statuses count])) {
			NoteViewController *myNoteView = [[NoteViewController alloc] initWithNibName:@"NoteViewController" bundle:nil];
			myNoteView.presence=presence;
			[self presentModalViewController:myNoteView animated:YES];
			[myNoteView release];
		}
	} else if (type==2) {
		Presence *presence = [statuses objectAtIndex:indexPath.row];
		AttendanceEditViewController *vc = [[AttendanceEditViewController alloc] init];
		vc.name=[[NSString alloc] initWithFormat:@"%@ %@'s Attendance",student.firstName, student.lastName];
		vc.presence=presence;
		[kal.navigationController pushViewController:vc animated:YES];
	} else {
		Presence *presence = [statuses objectAtIndex:indexPath.row];
		AttendanceEditViewController *vc = [[AttendanceEditViewController alloc] init];
		vc.name=[[NSString alloc] initWithFormat:@"%@ %@'s Attendance",student.firstName, student.lastName];
		vc.presence=presence;
		[self.navigationController pushViewController:vc animated:YES];
	}
}	
	

- (void)tableView:(UITableView *)tableview commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableArray *courses=nil;
    if (editingStyle == UITableViewCellEditingStyleDelete){
        // Delete the row from the data source
		Presence *p = [statuses objectAtIndex:indexPath.row];
		p.note=nil;
		//numOfdelete++;
        [tableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}
	[courses release];
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {return TRUE;}

- (IBAction)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	[self.tableView beginUpdates];
	NSUInteger count = [statuses count];
	NSLog (@"setEditing count %i",count); 
    NSArray *classesInsertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:count inSection:0]];
	[self.navigationItem setHidesBackButton:editing animated:animated];
    if (editing) {
		[self.navigationItem setHidesBackButton:editing animated:animated];
		[self.tableView insertRowsAtIndexPaths:classesInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
	} else {
		[self.tableView deleteRowsAtIndexPaths:classesInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
		Roll_CallAppDelegate *aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
		NSManagedObjectContext *context=[aD managedObjectContext];
		NSError *error;
		if (![context save:&error]) {
			// Handle the error.
		}
	}
		//numOfdelete=0;
    [self.tableView endUpdates];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleDelete;
	if (self.editing && indexPath.row == ([statuses count])) {
            style = UITableViewCellEditingStyleInsert;
        }
	return style;
}


- (void)dealloc {
	[statuses release];
	[student release];
    [super dealloc];
}


@end

