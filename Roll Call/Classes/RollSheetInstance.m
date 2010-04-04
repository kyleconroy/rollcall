//
//  RollSheetInstance.m
//  Roll Call
//
//  Created by Kyle Conroy on Apr3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RollSheetInstance.h"
#import "Student.h"
#import  "Presence.h"
#import "Status.h"

#define DAY  86400

@implementation RollSheetInstance

@synthesize aD;
@synthesize course;
@synthesize eventsArray;
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
    
    aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self setTitle:course.name];
    
    //update the Date
    myDate = [NSDate  date];
    [self updateDisplayDate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    NSMutableArray * ss = [[NSMutableArray alloc] init];
    NSMutableArray * ee = [[NSMutableArray alloc] init];
    
    //get all students in the class
    NSEnumerator *e = [course.students objectEnumerator];
    id collectionMemberObject;
    
    //add them to a temporary array
    while ( (collectionMemberObject = [e nextObject]) ) {
        [ss addObject:collectionMemberObject];
    }
    
    // return the sorted array
    studentsArray = [ss sortedArrayUsingDescriptors:sortDescriptors];
    eventsArray = [[NSMutableArray alloc] init];
    
    
    // get all events associated with this day
    //NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"date == %@", myDate];
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit 
                                          fromDate:now];
    
    [comps setHour:00];
    [comps setMinute:00];
    [comps setSecond:00];
    
    NSDate *today = [calendar dateFromComponents:comps];
    
    now = [NSDate dateWithTimeIntervalSinceNow:24 * 60 * 60]; // 24h from now
    
    comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit 
                                          fromDate:now];
    
    [comps setHour:00];
    [comps setMinute:00];
    [comps setSecond:00];
    
    NSDate *tomorrow = [calendar dateFromComponents:comps];
    
    
    NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@)", today, tomorrow];
    Status *currentStatus = [aD getStatusWithLetter:@"P"];
    NSManagedObjectContext *context = [aD managedObjectContext];
    
    for (Student *s in studentsArray){
        NSSet *events = [s.presences filteredSetUsingPredicate:myPredicate];
        if ([events count] == 0) {
            Presence *presence = (Presence *)[NSEntityDescription insertNewObjectForEntityForName:@"Presence" inManagedObjectContext:context];
            presence.date = myDate;
            presence.student = s;
            presence.class = course;
            presence.status = currentStatus;
            [ee addObject:presence];
            NSLog(@"Add new event");
        } else {
            [ee addObject:[events anyObject]];
            NSLog(@"Old event");
        }
    }
    
    if ([ee count] != [studentsArray count]) {
        NSLog(@"Incompatible sizes %d %d", [ee count], [studentsArray count]);
    }
    
    eventsArray = [[NSArray arrayWithArray:ee] retain];
    
    NSError *error;
    if (![context save:&error]) {
        // Handle the error.
    }
    
    // Save and release stuff
    [myDate retain];
    [studentsArray retain]; 
    [context release];
        
    [sortDescriptors release];
    [ss release];
    [ee release];
        
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
    
    
    
    Student *s = [studentsArray objectAtIndex:indexPath.row];
    Presence *p = [eventsArray objectAtIndex:indexPath.row];
    
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:1];
    label.text = @"HEY";
    
    
    //cell.contentView.backgroundColor = p.status.color;
    
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
    [myDate release];
    [studentsArray release];
    [eventsArray release];
    [super dealloc];
    
}


@end
