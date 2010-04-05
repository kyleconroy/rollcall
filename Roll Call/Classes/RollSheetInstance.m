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
@synthesize myTextView;
@synthesize myTableView;
@synthesize myDate;
@synthesize myPickerView;
@synthesize myNoteView;
@synthesize datePickerDate;
@synthesize tvCell;
@synthesize backDate;
@synthesize forwardDate;
@synthesize displayDate;
@synthesize datePickerVisible;
@synthesize currentIndexPath;

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
    datePickerVisible = NO;
    currentIndexPath = nil;
    // Set up Views
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    myPickerView.transform = transform;
    myNoteView.transform = transform;
    [UIView commitAnimations];
    
    // From http://stackoverflow.com/questions/1824463/how-to-style-uitextview-to-like-rounded-rect-text-field
    
    //The rounded corner part, where you specify your view's corner radius:
    //myTextView.layer.cornerRadius = 5;
    myTextView.clipsToBounds = YES;

    
    aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
    myDate = [NSDate date];
    
    [self setTitle:course.name];
    
    [self updateDisplayDate];
    [self initializeData];
    [self loadData];
    
    // Save and release stuff
    [myDate retain];
    
    [super viewDidLoad];
}

- (void)loadData {
    
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
    
    [sortDescriptors release];
    [sortDescriptor release];
    [mutableFetchResults release];
    [request release];
    
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
            //NSLog(@"Add new event");
        } else {
            //NSLog(@"Old event");
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
    //SUPER HACK
    myTableView = tableView;
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [presencesArray count];
}

- (void) updateDisplayDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [displayDate setTitle:[formatter stringFromDate:myDate] forState:UIControlStateNormal];
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
    
    if (s.note) {
        UIButton *button;
        button = (UIButton *)[cell viewWithTag:3];
        [button setImage:[UIImage imageNamed:@"note_on.png"] forState:UIControlStateNormal];
    }
    
    return cell;
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
    
    [self initializeData];
    [self loadData];
    
    int x = [presencesArray count];
    
    NSMutableArray *updatedPaths = [NSMutableArray array];
    for (int i = 0; i < x; i++) {
        NSIndexPath *updatedPath = [NSIndexPath indexPathForRow:i inSection:0];
        [updatedPaths addObject:updatedPath];
    }
    [myTableView reloadRowsAtIndexPaths:updatedPaths withRowAnimation:UITableViewRowAnimationRight];
    
}

- (IBAction)moveForwardOneDay {
    myDate = [myDate addTimeInterval:DAY];
    [self updateDisplayDate];
    [myDate retain];
    
    [self initializeData];
    [self loadData];
    
    int x = [presencesArray count];
    
    
    NSMutableArray *updatedPaths = [NSMutableArray array];
    for (int i = 0; i < x; i++) {
        NSIndexPath *updatedPath = [NSIndexPath indexPathForRow:i inSection:0];
        [updatedPaths addObject:updatedPath];
    }
    [myTableView reloadRowsAtIndexPaths:updatedPaths withRowAnimation:UITableViewRowAnimationLeft];
    


}

- (IBAction) showDatePicker {

    if (!datePickerVisible) {
        datePickerVisible = YES;
        datePickerDate = nil;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 55);
        myPickerView.transform = transform;
        [self.view addSubview:myPickerView];
        [UIView commitAnimations];
    }
    
}

- (void) hideDatePicker {
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
	myPickerView.transform = transform;
	[UIView commitAnimations];
    datePickerVisible = NO;
}

- (IBAction) doneDatePicker {
    UIDatePicker *picker = (UIDatePicker *)[myPickerView viewWithTag:1];
    NSDate *selectedDate = picker.date;
    [self setMyDate:selectedDate];
    [self updateDisplayDate];
    [self initializeData];
    [self loadData];    
    [myTableView reloadData];
    
    
    [self hideDatePicker];
}

- (IBAction) cancelDatePicker {
    [self hideDatePicker];
}

-(IBAction)addNote:(id)sender
{
    //Position Selected Table Row
    UIView *senderButton = (UIView*) sender;
    NSIndexPath *indexPath = [myTableView  indexPathForCell: (UITableViewCell*)[[senderButton superview]superview]];
    Presence* p = [presencesArray objectAtIndex:indexPath.row];
    
    [myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    myTableView.scrollEnabled = NO;
    myTextView.text = p.note;
    
    UIButton *button;
    button = (UIButton *)[[myTableView cellForRowAtIndexPath:indexPath] viewWithTag:3];
    [button setImage:[UIImage imageNamed:@"note_on.png"] forState:UIControlStateNormal];
    
    [self setCurrentIndexPath:indexPath];
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

- (void) hideNote {
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 480);
	myNoteView.transform = transform;
	[UIView commitAnimations];
    myTableView.scrollEnabled = YES;
}

- (IBAction) doneNote {
    
    UIButton *button;
    button = (UIButton *)[[myTableView cellForRowAtIndexPath:currentIndexPath] viewWithTag:3];
    
    if ([myTextView.text length] != 0) {
        Presence* p = [presencesArray objectAtIndex:currentIndexPath.row];
        p.note = myTextView.text;
        
        NSError *error;
        if (![[aD managedObjectContext] save:&error]) {
            // Handle the error.
        }
    } else {
        [button setImage:[UIImage imageNamed:@"note_outline.png"] forState:UIControlStateNormal];
    }

    
    currentIndexPath = nil;
    [self hideNote];
}

- (IBAction) cancelNote {
    
    Presence* p = [presencesArray objectAtIndex:currentIndexPath.row];
    if ([p.note length] == 0) {    
        UIButton *button;
        button = (UIButton *)[[myTableView cellForRowAtIndexPath:currentIndexPath] viewWithTag:3];
        [button setImage:[UIImage imageNamed:@"note_outline.png"] forState:UIControlStateNormal];
    }
    
    [self hideNote];
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range 
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, 95);
        myNoteView.transform = transform;
        [self.view addSubview:myNoteView];
        [UIView commitAnimations];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
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
    [datePickerDate release];
    [myPickerView release];
    [myDate release];
    [myNoteView release];
    [myTextView release];
    [studentsArray release];
    [presencesArray release];
    [course release];
    [super dealloc];
    
}


@end
