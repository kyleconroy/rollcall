//
//  AddCourseViewController.m
//  Roll Call
//
//  Created by Weizhi on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddCourseViewController.h"
#import "Course.h"
#import "Student.h"

@implementation AddCourseViewController
@synthesize student;
@synthesize aD;

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
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

- (void)cancel {
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSMutableArray *allcourses=[aD getAllCourses];
	NSInteger count= [allcourses count];
	[allcourses release];
	return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSMutableArray *allcourses=[aD getAllCourses];
	NSUInteger row = [indexPath row];
	Course *course=[allcourses objectAtIndex:row];
	cell.textLabel.text=[course name];
	[allcourses release];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableArray *allcourses=[aD getAllCourses];
	NSUInteger row = [indexPath row];
	Course *course=[allcourses objectAtIndex:row];
	[student addCoursesObject:course];
	[course addStudentsObject: student];
	[allcourses release];
	[self dismissModalViewControllerAnimated:YES];
}

/*
 - (UITableViewCellAccessoryType)tableView:(UITableView *)tableView 
 accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
 {
 return UITableViewCellAccessoryDisclosureIndicator;
 }*/


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


- (void)dealloc {
	[student release];
    [super dealloc];
}



@end

