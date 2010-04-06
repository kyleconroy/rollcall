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


@implementation AttendanceTableViewController

@synthesize statuses;
@synthesize student;
@synthesize type;
@synthesize myNoteView;
@synthesize myTextView;

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
	self.tableView.allowsSelection=NO;
	if (type==0) 
		self.title = @"Tardy";
	if (type==1) 
		self.title = @"Absence";
	if (type==2) 
		self.title = @"Excused Absence";
	if (type==3) {
		self.tableView.allowsSelection=YES;
		self.title = @"Notes";
	}
	
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
	
	if (type==3) {
		[self addNote: indexPath];
		//[self showNote];
	}
	
}	


-(IBAction)addNote: (NSIndexPath *)indexPath
{
    //Position Selected Table Row
    Presence* p = [statuses objectAtIndex:indexPath.row];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    self.tableView.scrollEnabled = NO;
    myTextView.text = p.note;
    
    UIButton *button;
    button = (UIButton *)[[self.tableView cellForRowAtIndexPath:indexPath] viewWithTag:3];
    [button setImage:[UIImage imageNamed:@"note_on.png"] forState:UIControlStateNormal];
    
    //[self setCurrentIndexPath:indexPath];
    [self showNote];
}


- (IBAction) showNote {
    
    //Position Selected Table Row
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 95);
    myNoteView.transform = transform;
    [self.view addSubview:myNoteView];
    [UIView commitAnimations];
	
}

- (IBAction) hideNote {
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
	myNoteView.transform = transform;
	[UIView commitAnimations];
    self.tableView.scrollEnabled = YES;
}



- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, -44);
    myNoteView.transform = transform;
    [self.view addSubview:myNoteView];
    [UIView commitAnimations];
    
    return YES;
}

/*
 - (UITableViewCellAccessoryType)tableView:(UITableView *)tableView 
 accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
 {
 return UITableViewCellAccessoryDisclosureIndicator;
 }*/



- (void)dealloc {
    [super dealloc];
}


@end

