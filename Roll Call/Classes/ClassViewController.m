//
//  ClassViewController.m
//  Roll Call
//
//  Created by Kyle Conroy on Mar22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ClassViewController.h"
#import "DaysOfWeekCell.h"

@implementation ClassViewController

@synthesize aD, selectedCourse, enrollStudents, enrollStudentsViewController;

/*
 - (id)initWithStyle:(UITableViewStyle)style {
 // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 if (self = [super initWithStyle:style]) {
 }
 return self;
 }
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	EnrollStudentsViewController *anEnrollStudentsViewController = [[EnrollStudentsViewController alloc]
                                                                    initWithNibName:@"EnrollStudentsViewController" bundle:[NSBundle mainBundle]];
	anEnrollStudentsViewController.title = @"Add Class";
	[self setEnrollStudentsViewController:anEnrollStudentsViewController];
	[anEnrollStudentsViewController release];
    
}

- (void) enrollStudentsInClass:(id)sender {
	[[self navigationController] pushViewController:enrollStudentsViewController animated:YES];
}

/*
 - (void)viewWillAppear:(BOOL)animated {
 [super viewWillAppear:animated];
 }
 */
/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 }
 */
/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection: (NSInteger) section {
	NSString *title = nil;
	switch (section) {
		case 4:
			title = @"Enrolled Students";
			break;
		default:
			break;
	}
	return title;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //class name and meeting days
	if (section == 0 || section == 3) {
		return 1;
	} else if (section == 1 || section == 2) {
		//start/end time/date
		return 2;
	} else if (section == 4) {
		//enrolled students
		return [selectedCourse.students count];
	} else {
		return 0;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	int customCellType = 0;
	static NSString *CellIdentifier;
	if (indexPath.section == 3) {
		//only different cell type for meeting days
		customCellType = 1;
		CellIdentifier = @"DaysOfWeekCell";
	} else {
		CellIdentifier = @"Cell";
	}
	
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		switch (customCellType) {
			case 0:
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				break;
			case 1:
				cell = [[[DaysOfWeekCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				break;
		}
	}
	/*
     if (indexPath.section == 3) {
     //meeting days - need segmented control
     static NSString *CellIdentifier = @"DaysOfWeekCell";
     DaysOfWeekCell *cell = (DaysOfWeekCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     
     if (cell = nil) {
     NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DaysOfWeekCell" owner:nil options:nil];
     
     for (id currentObject in topLevelObjects) {
     if ([currentObject isKindOfClass:[UITableViewCell class]]) {
     cell = (DaysOfWeekCell *) currentObject;
     break;
     }
     }
     }
     
     } else {
     
     static NSString *CellIdentifier = @"Cell";
     
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
     }
     
     }
	 */
	
    // Set up the cell...
	if (indexPath.section == 0) {
		cell.textLabel.text = selectedCourse.name;
	} else if (indexPath.section == 1) {
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"MM/DD/YYYY"];
		if (indexPath.row == 0) {
			cell.textLabel.text = [dateFormat stringFromDate:selectedCourse.startDate];
		} else {
			cell.textLabel.text = [dateFormat stringFromDate:selectedCourse.endDate];
		}
	} else if (indexPath.section == 2) {
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"h:mm a"];
		if (indexPath.row == 0) {
			cell.textLabel.text = [dateFormat stringFromDate:selectedCourse.startDate];
		} else {
			cell.textLabel.text = [dateFormat stringFromDate:selectedCourse.endDate];
		}
	} else if (indexPath.section == 3) {
		
	} else {
		
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


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


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


- (void)dealloc {
    [super dealloc];
	[selectedCourse release];
	[enrollStudents release]; 
	[enrollStudentsViewController release];
}


@end

