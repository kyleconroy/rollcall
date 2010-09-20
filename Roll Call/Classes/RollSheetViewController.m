//
//  RollSheetViewController.m
//  Roll Call
//
//  Created by Kyle Conroy on Apr3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RollSheetViewController.h"
#import "Course.h"
#import "Status.h"
#import "RollSheetInstance.h"
#import "AddRollSheetViewController.h"

@implementation RollSheetViewController

@synthesize managedObjectContext;
@synthesize coursesArray;
@synthesize aD;
@synthesize myTableView;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


 // Iplement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
     aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
     [self setTitle:@"Classes"];
     
     // Check if application launching for first time
     // If so, install initial statuses
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];  
     if (![defaults objectForKey:@"firstRun"]){
         [self installStatuses];
         [defaults setObject:[NSDate date] forKey:@"firstRun"];
     }
     
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     managedObjectContext = [aD managedObjectContext];
     //Get all the current Students in a given class
     coursesArray = [[NSMutableArray alloc] init];

     [self setCoursesArray:[aD getAllCourses]];
     
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addRollSheet)];

     
     [super viewDidLoad];
 }

-(void) installStatuses {
    NSManagedObjectContext *context = [aD managedObjectContext];
    
    NSArray *statuses = [[NSArray alloc] initWithObjects:
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Present", @"text", [NSNumber numberWithInt:0], @"rank", @"P", @"letter", 
                          [UIColor colorWithRed:0.369 green:0.835 blue:0.128 alpha:1.000], @"color", @"button_green.png", @"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Absent", @"text", [NSNumber numberWithInt:1 ], @"rank", @"A", @"letter", 
                          [UIColor colorWithRed:0.835 green:0.103 blue:0.182 alpha:1.000], @"color", @"button_red.png", @"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Tardy", @"text", [NSNumber numberWithInt:2 ], @"rank", @"T", @"letter", 
                          [UIColor colorWithRed:1.000 green:0.830 blue:0.081 alpha:1.000], @"color", @"button_yellow.png", @"image", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Excused", @"text", [NSNumber numberWithInt:3 ], @"rank", @"E", @"letter", 
                          [UIColor colorWithRed:0.179 green:0.298 blue:0.835 alpha:1.000], @"color", @"button_blue.png", @"image", nil],
                         nil];
    
    for (NSDictionary *d in statuses){
        NSLog(@"Status %@", [d objectForKey:@"text"]);
        Status *status = (Status *)[NSEntityDescription insertNewObjectForEntityForName:@"Status" inManagedObjectContext:context];
        status.text = [d objectForKey:@"text"];
        status.rank = [d objectForKey:@"rank"];
        status.color = [d objectForKey:@"color"];
        status.letter = [d objectForKey:@"letter"];
        status.imageName = [d objectForKey:@"image"];
    }
    
    NSError *error;
    if (![context save:&error]) {
        // Handle the error.
    }
    
}


- (void)viewWillAppear:(BOOL)animated {
	
	[self setCoursesArray:[aD getAllCourses]];
	[myTableView reloadData];
}

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
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [coursesArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
	Course *c = (Course *)[coursesArray objectAtIndex:indexPath.row];
	cell.textLabel.text = c.name;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	RollSheetInstance *attendanceController = [[RollSheetInstance alloc] initWithNibName:@"RollSheetInstance" bundle:nil];
    attendanceController.course = (Course *)[coursesArray objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:attendanceController animated:YES];
	[attendanceController release];
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

- (void) addRollSheet {
    AddRollSheetViewController *addSheetController = [[AddRollSheetViewController alloc] initWithNibName:@"AddRollSheetViewController" bundle:nil];
    
    addSheetController.delegate = self;
    addSheetController.courseName = @"Course Name";
    UINavigationController *nController = [[UINavigationController alloc]
                                                    initWithRootViewController:addSheetController];
    
    [self presentModalViewController:nController animated:YES];
    [nController release];
	[addSheetController release];
}

- (void) addRollSheetViewController:(AddRollSheetViewController*)addRollSheetViewController withCourse:(Course *)course {
    if (course) {
        [self setCoursesArray:[aD getAllCourses]];
        [myTableView reloadData];
    }
    [self dismissModalViewControllerAnimated:YES];
}



- (void)dealloc {
    [coursesArray release];
    [managedObjectContext release];
    [myTableView release];
    [super dealloc];
}


@end
