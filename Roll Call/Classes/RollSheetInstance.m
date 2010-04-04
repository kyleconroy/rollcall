//
//  RollSheetInstance.m
//  Roll Call
//
//  Created by Kyle Conroy on Apr3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RollSheetInstance.h"
#import "Student.h"

#define DAY  86400

@implementation RollSheetInstance

@synthesize course;
@synthesize studentsArray;
@synthesize myTableView;
@synthesize myDate;

@synthesize tvCell;
@synthesize backDate;
@synthesize forwardDate;
@synthesize displayDate;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [self setTitle:course.name];
    
    myDate = [NSDate  date];
    [myDate retain];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    NSMutableArray * ss = [[NSMutableArray alloc] init];
    
    NSEnumerator *e = [course.students objectEnumerator];
    id collectionMemberObject;
    
    while ( (collectionMemberObject = [e nextObject]) ) {
        [ss addObject:collectionMemberObject];
    }
    
    studentsArray = [ss sortedArrayUsingDescriptors:sortDescriptors];
    //studentsArray = [[NSArray alloc] initWithObjects:@"HEY", @"YOU", @"THERE", nil];

    [self updateDisplayDate];
    
    [sortDescriptors release];
    [ss release];
    [studentsArray retain];
    
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [studentsArray count];
}

- (void) updateDisplayDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    displayDate.text = [formatter stringFromDate:myDate];
    [formatter release];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"AttendanceTableCell" owner:self options:nil];
        cell = tvCell;
        self.tvCell = nil;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:0.369 green:0.835 blue:0.128 alpha:1.000];
    
    Student * s = [studentsArray objectAtIndex:indexPath.row];
    
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:1];
    label.text = @"P";
    
    label = (UILabel *)[cell viewWithTag:2];
    label.text = [NSString stringWithFormat:@"%@ %@", [s firstName], [s lastName]];
    
    return cell;
}

-(IBAction)addNote:(id)sender
{
    UIView *senderButton = (UIView*) sender;
    NSIndexPath *indexPath = [myTableView  indexPathForCell: (UITableViewCell*)[[senderButton superview]superview]];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:1];
    NSString *statusString = label.text;
    
    if([statusString isEqualToString:@"P"]){
        label.text = @"A";
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.835 green:0.103 blue:0.182 alpha:1.000];
    } else if([statusString isEqualToString:@"A"]){
        label.text = @"T";
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.835 green:0.737 blue:0.195 alpha:1.000];
    } else if([statusString isEqualToString:@"T"]){
        label.text = @"E";
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.179 green:0.298 blue:0.835 alpha:1.000];
    } else if([statusString isEqualToString:@"E"]){
        label.text = @"P";
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.369 green:0.835 blue:0.128 alpha:1.000];
    }
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.opaque = NO;
}

- (IBAction)moveBackOneDay {
    myDate = [myDate addTimeInterval:-DAY];
    [self updateDisplayDate];
    [myDate retain];
}

- (IBAction)moveForwardOneDay {
    myDate = [myDate addTimeInterval:DAY];
    [self updateDisplayDate];
    [myDate retain];
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

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
    
}


@end
