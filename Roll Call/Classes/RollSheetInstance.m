//
//  RollSheetInstance.m
//  Roll Call
//
//  Created by Kyle Conroy on Apr3.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RollSheetInstance.h"
#import "Student.h"
#import "Presence.h"
#import "Status.h"

#define DAY  86400

@implementation RollSheetInstance

@synthesize aD;
@synthesize course;
@synthesize presencesArray;
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
    myDate = [NSDate date];
    
    [self setTitle:course.name];
        
    [self updateDisplayDate];
    [self initializeData];
    
    presencesArray = [[NSMutableArray alloc] init];
    
    NSManagedObjectContext *context = [aD managedObjectContext];
    
    // Perfom a new fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Presence" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND (course == %@)", 
                              [self todayWithDate:myDate], [self tomorrowWithDate:myDate], course];
    [request setPredicate:predicate];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        NSLog(@"No results"); 
    }
    
    [self setPresencesArray:mutableFetchResults];
    
    // Save and release stuff
    [myDate retain];
    
    [sortDescriptors release];
    [sortDescriptor release];
    [mutableFetchResults release];
    [request release];
    
    [super viewDidLoad];
}

- (void)initializeData {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    NSMutableArray * ss = [[NSMutableArray alloc] init];
    
    //get all students in the class
    NSEnumerator *e = [course.students objectEnumerator];
    id collectionMemberObject;
    
    //add them to a temporary array
    while ( (collectionMemberObject = [e nextObject]) ) {
        [ss addObject:collectionMemberObject];
    }
    
    // return the sorted array
    NSArray *students = [ss sortedArrayUsingDescriptors:sortDescriptors];
    
    // get all events associated with this day
    NSDate *today = [self todayWithDate:myDate];
    NSDate *tomorrow = [self tomorrowWithDate:myDate];
    
    NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND (course.name == %@)", today, tomorrow,course.name];
    Status *currentStatus = [aD getStatusWithLetter:@"P"];
    NSManagedObjectContext *context = [aD managedObjectContext];
    
    for (Student *s in students){
        NSSet *events = [s.presences filteredSetUsingPredicate:myPredicate];
        if ([events count] == 0) {
            Presence *presence = (Presence *)[NSEntityDescription insertNewObjectForEntityForName:@"Presence" inManagedObjectContext:context];
            presence.date = myDate;
            presence.student = s;
            presence.lastName = s.lastName;
            presence.course = course;
            presence.status = currentStatus;
            NSLog(@"Add new event");
        } else {
            NSLog(@"Old event");
        }
    }
    
    // Save the insertions
    NSError *error;
    if (![context save:&error]) {
        // Handle the error.
    }
    
    [sortDescriptor release];
    [sortDescriptors release];
    [ss release];
}

- (NSDate *)todayWithDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit 
                                          fromDate:date];
    
    [comps setHour:00];
    [comps setMinute:00];
    [comps setSecond:00];
    
    return [calendar dateFromComponents:comps];
}

- (NSDate *)tomorrowWithDate:(NSDate *)date {
    NSDate *now = [date addTimeInterval:DAY]; // 24h from now
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit 
                        fromDate:now];
    
    [comps setHour:00];
    [comps setMinute:00];
    [comps setSecond:00];
    
    return [calendar dateFromComponents:comps];
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
    return [presencesArray count];
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
    
    Presence *s = [presencesArray objectAtIndex:indexPath.row];
    
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:1];
    label.text = s.status.letter;
    
    cell.contentView.backgroundColor = s.status.color;
    
    label = (UILabel *)[cell viewWithTag:2];
    label.text = [NSString stringWithFormat:@"%@ %@", s.student.firstName, [s lastName]];
    
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
    Presence *c = [presencesArray objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *label;
    label = (UILabel *)[cell viewWithTag:1];
    NSString *statusString = label.text;
    
    if([statusString isEqualToString:@"P"]){
        
        c.status = [aD getStatusWithLetter:@"A"];
        
    } else if([statusString isEqualToString:@"A"]){
        
        c.status = [aD getStatusWithLetter:@"T"];
        
    } else if([statusString isEqualToString:@"T"]){
        
        c.status = [aD getStatusWithLetter:@"E"];
        
    } else if([statusString isEqualToString:@"E"]){
        
        c.status = [aD getStatusWithLetter:@"P"];
    }
    
    NSError *error;
    if (![[aD managedObjectContext] save:&error]) {
        // Handle the error.
    }
    
    label.text = c.status.letter;
    cell.contentView.backgroundColor = c.status.color;
    
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
    [presencesArray release];
    [course release];
    [super dealloc];
    
}


@end
