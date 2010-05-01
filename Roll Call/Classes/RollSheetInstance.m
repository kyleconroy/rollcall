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
#import "RollSheetAddNoteController.h"
#import "RollSheetInfoViewController.h"

#define DAY  86400

@implementation RollSheetInstance

@synthesize aD;
@synthesize course;
@synthesize presencesArray;
@synthesize studentsArray;
@synthesize statusArray;
@synthesize myTableView;
@synthesize myDate;
@synthesize myPickerView;
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
    
    aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
    myDate = [NSDate date];
    
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(showCourseInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    modalButton.width = 80.0;
    [self.navigationItem setRightBarButtonItem:modalButton animated:NO];
    [modalButton release];
    
    [self setTitle:course.name];
    
    
    //Get the students, and sort them by last name
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
    studentsArray = [ss sortedArrayUsingDescriptors:sortDescriptors];
    
    
    [self updateDisplayDate];
    [self updateAttendance];

    
    // Save and release stuff
    [myDate retain];
    [studentsArray retain];
    
    [sortDescriptor release];
    [sortDescriptors release];
    [ss release];
    
    [super viewDidLoad];
}

- (void) updateAttendance {
    [presencesArray release];
    presencesArray = [[NSMutableArray alloc] init];
    
    NSDate *today = [self todayWithDate:myDate];
    NSDate *tomorrow = [self tomorrowWithDate:myDate];
    NSManagedObjectContext *context = [aD managedObjectContext];
    NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND (course == %@)", today, tomorrow, course];
    
    Status *stat = [aD getStatusWithLowestRank];
    
    for(Student* s in studentsArray){
        NSSet *events = [s.presences filteredSetUsingPredicate:myPredicate];
        Presence *p = [events anyObject];
        if (p == nil) {
            p = (Presence *)[NSEntityDescription insertNewObjectForEntityForName:@"Presence" inManagedObjectContext:context];
            p.date = myDate;
            p.student = s;
            p.course = course;
            p.status = stat;
        }
        [presencesArray addObject:p];
    }
    
    NSError *error;
    if (![[aD managedObjectContext] save:&error]) {
        // Handle the error.
    }
    
    [presencesArray retain];
}

- (void) viewDidAppear:(BOOL)animated {
    statusArray = [aD getAllStatuses];
    [statusArray retain];
    
    [super viewDidAppear:animated];
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
    return [studentsArray count];
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
    
    Student *s = [studentsArray objectAtIndex:indexPath.row];
    Presence *p = [presencesArray objectAtIndex:indexPath.row];
    
    UIButton *button;
    button = (UIButton *)[cell viewWithTag:1];
    
    [button setTitle:p.status.letter forState: UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:p.status.imageName] forState:UIControlStateNormal];
        
    UILabel *label = (UILabel *)[cell viewWithTag:2];
    label.text = [NSString stringWithFormat:@"%@ %@", s.firstName, s.lastName];
    
    if (p.note) {
        button = (UIButton *)[cell viewWithTag:3];
        [button setImage:[UIImage imageNamed:@"note_on.png"] forState:UIControlStateNormal];
    }
    
    return cell;
}

-(IBAction)changeAttendance:(id)sender {
    //Position Selected Table Row
    UIView *senderButton = (UIView*) sender;
    NSIndexPath *indexPath = [myTableView  indexPathForCell: (UITableViewCell*)[[senderButton superview]superview]];
    UITableViewCell *cell = [myTableView  cellForRowAtIndexPath:indexPath];
    
    Presence *p = [presencesArray objectAtIndex:indexPath.row];
    
    NSNumber *currentRank = p.status.rank   ;
    
    if ([currentRank intValue] + 1 >= [statusArray count]) {
        p.status = [statusArray objectAtIndex:0];
    } else {
        p.status = [statusArray objectAtIndex:[currentRank intValue] + 1]; 
    }

    
    UIButton *button;
    button = (UIButton *)[cell viewWithTag:1];
    
    NSError *error;
    if (![[aD managedObjectContext] save:&error]) {
        // Handle the error.
    }
    
    [button setTitle: p.status.letter forState: UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:p.status.imageName] forState:UIControlStateNormal];
    
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.opaque = NO;
}

- (IBAction)moveBackOneDay {
    myDate = [myDate addTimeInterval:-DAY];
    [self updateDisplayDate];
    [self updateAttendance];
    [myDate retain];
    
    NSMutableArray *updatedPaths = [NSMutableArray array];
    for (int i = 0; i < [studentsArray count]; i++) {
        NSIndexPath *updatedPath = [NSIndexPath indexPathForRow:i inSection:0];
        [updatedPaths addObject:updatedPath];
    }
    [myTableView reloadRowsAtIndexPaths:updatedPaths withRowAnimation:UITableViewRowAnimationRight];
    
}

- (IBAction)moveForwardOneDay {
    myDate = [myDate addTimeInterval:DAY];
    [self updateDisplayDate];
    [self updateAttendance];
    [myDate retain];
    
    NSMutableArray *updatedPaths = [NSMutableArray array];
    for (int i = 0; i < [studentsArray count]; i++) {
        NSIndexPath *updatedPath = [NSIndexPath indexPathForRow:i inSection:0];
        [updatedPaths addObject:updatedPath];
    }
    
    [myTableView reloadRowsAtIndexPaths:updatedPaths withRowAnimation:UITableViewRowAnimationLeft];

}

- (IBAction) showDatePicker {

    ChangeDateViewController *dateController = [[ChangeDateViewController alloc]
                                                 
                                                 initWithNibName:@"ChangeDateViewController" bundle:nil];
    
    dateController.myDate = myDate;
    dateController.delegate = self;
    
    [self presentModalViewController:dateController animated:YES];
    
    [dateController release];
    
}

- (void)changeDateViewController:(ChangeDateViewController *)changeDateViewController

                   didChangeDate:(NSDate *)date {
    if (date) {
        [self setMyDate:date];
        [self updateDisplayDate];
        [myTableView reloadData];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)addNote:(id)sender
{
    //Position Selected Table Row
    UIView *senderButton = (UIView*) sender;
    NSIndexPath *indexPath = [myTableView  indexPathForCell: (UITableViewCell*)[[senderButton superview]superview]];
    Presence *p = [presencesArray objectAtIndex:indexPath.row];
    
    UIButton *button;
    button = (UIButton *)[[myTableView cellForRowAtIndexPath:indexPath] viewWithTag:3];
    
    RollSheetAddNoteController *addController = [[RollSheetAddNoteController alloc]
                                              
                                              initWithNibName:@"RollSheetAddNoteController" bundle:nil];

    addController.presence = p;
    addController.button = button;
    
    [self presentModalViewController:addController animated:YES];
    
    [addController release];
}

- (void) showCourseInfo {
    
    RollSheetInfoViewController *courseInfoController = [[RollSheetInfoViewController alloc] 
                                                         initWithNibName:@"RollSheetInfoViewController" bundle:nil];
    
    [self.navigationController pushViewController:courseInfoController animated:YES];
    
    [courseInfoController release];
    
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

- (void)dealloc {
    [datePickerDate release];
    [myPickerView release];
    [myDate release];
    [studentsArray release];
    [presencesArray release];
    [statusArray release];
    [course release];
    [super dealloc];
    
}


@end

