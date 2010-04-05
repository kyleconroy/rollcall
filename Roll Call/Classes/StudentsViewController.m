//
//  StudentsViewController.m
//  Roll Call
//
//  Created by Weizhi Li on Mar22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StudentsViewController.h"
#import "StudentViewController.h"
#import "AddStudentViewController.h"
#import "student.h"
@implementation StudentsViewController

@synthesize aD, filteredListContent, collation, sectionsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"All Students"];
    aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSMutableArray *allstudents=[aD getAllStudents];
	self.filteredListContent = [NSMutableArray arrayWithCapacity:[allstudents count]];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addStudent)];
	if (allstudents == nil) {
		self.sectionsArray = nil;
	}
	else {
		[self configureSections];
	}
	//self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
	self.navigationController.navigationBar.translucent=YES;
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
	[allstudents release];
}

 
- (void)viewWillAppear:(BOOL)animated {	
		[self configureSections];
		[self.searchDisplayController setActive:NO];
		[self.tableView reloadData];
}

- (void)configureSections {
	NSLog(@"Start Configuring!");
	// Get the current collation and keep a reference to it.
	self.collation = [UILocalizedIndexedCollation currentCollation];	
	NSInteger index, sectionTitlesCount = [[collation sectionTitles] count];	
	NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
	// Set up the sections array
	for (index = 0; index < sectionTitlesCount; index++) {
		NSMutableArray *array = [[NSMutableArray alloc] init];
		[newSectionsArray addObject:array];
		[array release];
	}
	NSMutableArray *allstudents=[aD getAllStudents];
	// Segregate into the appropriate arrays.
	for (Student *student in allstudents) {
		NSInteger sectionNumber = [collation sectionForObject:student collationStringSelector:@selector(lastName)];
		
		// Get the array for the section.
		NSMutableArray *sectionStudents = [newSectionsArray objectAtIndex:sectionNumber];
				//  Add student to the section.
		[sectionStudents addObject:student];
	}
	// Now that all the data's in place, each section array needs to be sorted.
	for (index = 0; index < sectionTitlesCount; index++) {
		
		NSMutableArray *studentArrayForSection = [newSectionsArray objectAtIndex:index];
		
		// If the table view or its contents were editable, you would make a mutable copy here.
		NSArray *sortedStudentArrayForSection = [collation sortedArrayFromArray:studentArrayForSection collationStringSelector:@selector(lastName)];
		
		// Replace the existing array with the sorted array.
		[newSectionsArray replaceObjectAtIndex:index withObject:sortedStudentArrayForSection];
	}
	self.sectionsArray = newSectionsArray;
	[newSectionsArray release];	
}



- (void)viewDidDisappear:(BOOL)animated
{
}


- (void)addStudent {

    AddStudentViewController *addController = [[AddStudentViewController alloc] initWithNibName:@"AddStudentViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addController];
    [self presentModalViewController:navController animated:YES];
    [navController release];
    [addController release];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.filteredListContent = nil;
}


#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// The number of sections is the same as the number of titles in the collation.
    if (tableView == self.searchDisplayController.searchResultsTableView)
		return 1;
	return [sectionsArray count];
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
        return [self.filteredListContent count];
	else
	{
		NSArray *studentsInSection = [sectionsArray objectAtIndex:section];
		return [studentsInSection count];
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Student *myStudent = nil;
    NSString *CellIdentifier = [NSString stringWithFormat:@"%@ %@", myStudent.firstName, myStudent.lastName];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
	}
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        myStudent = [self.filteredListContent objectAtIndex:indexPath.row];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
		NSArray *studentsInSection = [sectionsArray objectAtIndex:indexPath.section];
		myStudent = [studentsInSection objectAtIndex:indexPath.row];
	}
	cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", myStudent.firstName, myStudent.lastName];
    return cell;
}

		/*
		 Section-related methods: Retrieve the section titles and section index titles from the collation.
		 */
		 
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
		if (tableView == self.searchDisplayController.searchResultsTableView)
			return 0;
		if ([[sectionsArray objectAtIndex:section] count]==0)
			return 0;
		return [[collation sectionTitles] objectAtIndex:section];
}
		 
		 
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	if (tableView == self.searchDisplayController.searchResultsTableView)
		return nil;
	return [collation sectionIndexTitles];
}
		 
		 
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
		return [collation sectionForSectionIndexTitleAtIndex:index];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	StudentViewController *anotherViewController = [[StudentViewController alloc] initWithNibName:@"StudentViewController" bundle:nil];
	Student *student = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        student = [self.filteredListContent objectAtIndex:indexPath.row];
    }
	else
	{
		NSArray *studentsInSection = [sectionsArray objectAtIndex:indexPath.section];
		
		student = [studentsInSection objectAtIndex:indexPath.row];
    }
	anotherViewController.title = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
	anotherViewController.currentStudent = student;
	[self.navigationController pushViewController:anotherViewController animated:YES];
	[anotherViewController release];
}


- (void)filterContentForSearchText:(NSString*)searchText
{
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	NSMutableArray *allstudents=[aD getAllStudents];
	for (Student *student in allstudents)
	{
		NSString *name=[[NSString alloc] initWithFormat: @"%@", student.lastName];
		NSComparisonResult result = [name compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
		if (result == NSOrderedSame)
		{
			[self.filteredListContent addObject:student];
		}
	}	
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
	[self filterContentForSearchText:searchString];  
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)dealloc {
	[collation release];
	[filteredListContent release];
	[sectionsArray release];
    [super dealloc];
}

@end

