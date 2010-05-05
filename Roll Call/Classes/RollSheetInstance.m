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
//#import "AttendanceViewCell.h"

#define DAY  86400

@implementation RollSheetInstance

@synthesize fetchController;

@synthesize aD;
@synthesize course;
@synthesize presencesArray;
@synthesize studentsArray;
@synthesize statusArray;
@synthesize myTableView;
@synthesize myDate;
@synthesize datePickerDate;
@synthesize tvCell;
@synthesize manualUpdate;
@synthesize backDate;
@synthesize forwardDate;
@synthesize displayDate;
@synthesize datePickerVisible;
@synthesize currentIndexPath;
@synthesize markDefault;
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
    manualUpdate = NO;
    currentIndexPath = nil;
    
    aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Info" 
                                                style:UIBarButtonItemStylePlain target:self action:@selector(showCourseInfo)];
    
    [self setTitle:course.name];
    
    myTableView.allowsSelection = NO;
    
    
    NSManagedObjectContext *context = [aD managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"ANY courses == %@", course];
    
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [sortDescriptors release];
    [sortDescriptor release];
    
    fetchController = [[NSFetchedResultsController alloc]
                        
                        initWithFetchRequest:fetchRequest
                        
                        managedObjectContext:context
                        
                        sectionNameKeyPath:nil
                        
                        cacheName:nil];
    
    fetchController.delegate = self;
    
    [fetchRequest release];
    
    
    
    NSError *error; 
    BOOL success = [fetchController performFetch:&error];
    
    if (!success) {
        NSLog(@"Cannot get NSFetchedResultsController for Statuses");
    }
    
    [self updateDate:[NSDate date]];
    [myDate retain];
    
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated {
    statusArray = [aD getAllStatuses];
    [statusArray retain];
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[self resignFirstResponder];
	[super viewWillDisappear:animated];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
	if (motion == UIEventSubtypeMotionShake) {
		NSDate *today = [self todayWithDate:myDate];
		NSDate *tomorrow = [self tomorrowWithDate:myDate];
		Status *stat = [aD getStatusWithLowestRank];
		NSManagedObjectContext *context = [aD managedObjectContext];
		NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND (course == %@)", today, tomorrow, course];		
		studentsArray = [[NSMutableArray alloc] initWithArray:[course.students allObjects]];
		for(Student* s in studentsArray){
			NSLog(@"im here");
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
		
		[self.myTableView reloadData];
		}
}

- (BOOL)canBecomeFirstResponder
{ return YES; }


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
    
    return [[fetchController sections] count];
    
}



- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchController sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
    
}

- (void) updateDate:(NSDate *)date {
    myDate = date;
    [myDate retain];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    [displayDate setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
    [formatter release];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"AttendanceViewCell";
    
	static NSInteger attendanceTag = 1;
    static NSInteger nameTag = 2;
	static NSInteger noteTag = 3;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];

        UIButton *attendanceButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        attendanceButton.frame = CGRectMake(0, 0, 51, 44); // position in the parent view and set the size of the button
        attendanceButton.tag = attendanceTag;
        attendanceButton.titleLabel.font = [UIFont boldSystemFontOfSize:22.0];
        attendanceButton.titleLabel.textColor = [UIColor blackColor];
        [attendanceButton addTarget:self action:@selector(changeAttendance:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:attendanceButton];
        
        UIButton *noteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        noteButton.frame = CGRectMake(269, 0, 56, 44); // position in the parent view and set the size of the button
        noteButton.tag = noteTag;
        [cell.contentView  addSubview:noteButton]; 
		
		UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.frame = CGRectMake(59, 0, 205, 41);
		nameLabel.tag = nameTag;
		[cell.contentView addSubview:nameLabel];
		[nameLabel release];
        
    }
    
    Student *s = [fetchController objectAtIndexPath:indexPath];

    NSDate *today = [self todayWithDate:myDate];
    NSDate *tomorrow = [self tomorrowWithDate:myDate];
    NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND (course == %@)", today, tomorrow, course];    
    NSSet *events = [s.presences filteredSetUsingPredicate:myPredicate];
    Presence *p = [events anyObject];
    
    UIButton *button;
    button = (UIButton *)[cell viewWithTag:attendanceTag];
    UIButton *note;
    note = (UIButton *)[cell viewWithTag:noteTag];
    
    if (p){
        [button setTitle:p.status.letter forState: UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:p.status.imageName] forState:UIControlStateNormal];
        [note setImage:[UIImage imageNamed:@"note_outline.png"] forState:UIControlStateNormal];
        [note setImage:[UIImage imageNamed:@"notes_on.png"] forState:UIControlStateSelected];
        [note setImage:[UIImage imageNamed:@"notes_on.png"] forState:UIControlStateHighlighted];
        [note addTarget:self action:@selector(addNote:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [button setTitle:@"" forState: UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"button_white.png"] forState:UIControlStateNormal];
        [note setImage:nil forState:UIControlStateNormal];
        [note setImage:nil forState:UIControlStateSelected];
        [note setImage:nil forState:UIControlStateHighlighted];
        [note addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    if (p.note) {
        [note setImage:[UIImage imageNamed:@"note_on.png"] forState:UIControlStateNormal];
    }
    
	UILabel * nameLabel = (UILabel *) [cell.contentView viewWithTag:nameTag];
	nameLabel.font = [UIFont boldSystemFontOfSize:18.0];
	nameLabel.text = [NSString stringWithFormat:@"%@ %@", s.firstName, s.lastName];
    
    return cell;
}

-(IBAction)changeAttendance:(id)sender {
    //Position Selected Table Row
    
    manualUpdate = YES;
    UIView *senderButton = (UIView*) sender;
    NSIndexPath *indexPath = [myTableView  indexPathForCell: (UITableViewCell*)[[senderButton superview]superview]];
    UITableViewCell *cell = [myTableView  cellForRowAtIndexPath:indexPath];
    
    Student *s = [fetchController objectAtIndexPath:indexPath];
    
    NSDate *today = [self todayWithDate:myDate];
    NSDate *tomorrow = [self tomorrowWithDate:myDate];
    NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND (course == %@)", today, tomorrow, course];    
    NSSet *events = [s.presences filteredSetUsingPredicate:myPredicate];
    Presence *p = [events anyObject];

    
    if (p == nil) {

        NSManagedObjectContext *context = [aD managedObjectContext];
        p = (Presence *)[NSEntityDescription insertNewObjectForEntityForName:@"Presence" inManagedObjectContext:context];
        p.date = myDate;
        p.student = s;
        p.course = course;
        p.status = [statusArray objectAtIndex:0];
    } else if ([p.status.rank intValue] + 1 >= [statusArray count]) {
        p.status = [statusArray objectAtIndex:0];
    } else {
        p.status = [statusArray objectAtIndex:[p.status.rank intValue] + 1]; 
    }
    
    NSError *error;
    if (![[aD managedObjectContext] save:&error]) {
        // Handle the error.
    }
    
    UIButton *button;
    button = (UIButton *)[cell viewWithTag:1];
    
    [button setTitle: p.status.letter forState: UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:p.status.imageName] forState:UIControlStateNormal];
    
    [myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    manualUpdate = NO;
    
}

- (void) updateAttendance:(UITableViewRowAnimation)rowAnimation {
    NSMutableArray *updatedPaths = [NSMutableArray array];
    for (NSManagedObject *managed in [fetchController fetchedObjects]) {
        [updatedPaths addObject:[fetchController indexPathForObject:managed]];
    }
    
    [myTableView reloadRowsAtIndexPaths:updatedPaths withRowAnimation:rowAnimation];
}

- (IBAction)moveBackOneDay {
    [self updateDate:[myDate addTimeInterval:-DAY]];
    [self updateAttendance:UITableViewRowAnimationRight];
}

- (IBAction)moveForwardOneDay {
    [self updateDate:[myDate addTimeInterval:DAY]];
    [self updateAttendance:UITableViewRowAnimationLeft];
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
        [self updateDate:date];
        [myTableView reloadData];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)addNote:(id)sender
{
    //Position Selected Table Row
    UIView *senderButton = (UIView*) sender;
    NSIndexPath *indexPath = [myTableView  indexPathForCell: (UITableViewCell*)[[senderButton superview]superview]];
    
    Student *s = [fetchController objectAtIndexPath:indexPath];
    
    NSDate *today = [self todayWithDate:myDate];
    NSDate *tomorrow = [self tomorrowWithDate:myDate];
    NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND (course == %@)", today, tomorrow, course];    
    NSSet *events = [s.presences filteredSetUsingPredicate:myPredicate];
    Presence *p = [events anyObject];
    
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
                                                         initWithNibName:@"AddRollSheetViewController" bundle:nil];
    
    courseInfoController.course = course;
    NSMutableArray *copyOfStudents = [[NSMutableArray alloc] initWithArray:studentsArray];
    [copyOfStudents release];
    
    [self.navigationController pushViewController:courseInfoController animated:YES];
    
    [courseInfoController release];
    
}

- (IBAction) markEmptyDefault {
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {

    if (!manualUpdate) {
        [self.myTableView beginUpdates];
    }
    
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo

           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            
            
            [self.myTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
             
                            withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
            
            
        case NSFetchedResultsChangeDelete:
            
            
            
            [self.myTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
             
                            withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
    }
    
}





- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject

       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type

      newIndexPath:(NSIndexPath *)newIndexPath {
    
    
    
    UITableView *tableView = self.myTableView;
    
    
    
    switch(type) {
            
            
            
        case NSFetchedResultsChangeInsert:
            
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
             
                             withRowAnimation:UITableViewRowAnimationRight];
            
            break;
            
            
            
        case NSFetchedResultsChangeDelete:
            
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
             
                             withRowAnimation:UITableViewRowAnimationRight];
            
            break;
            
            
            
        case NSFetchedResultsChangeUpdate:
            
            //[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            
            break;
            
            
            
        case NSFetchedResultsChangeMove:
            
                
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                 
                                 withRowAnimation:UITableViewRowAnimationRight];
                
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                 
                                 withRowAnimation:UITableViewRowAnimationRight];

            
            break;
            
    }
    
}





- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    if (!manualUpdate) {
        [myTableView reloadData];
        [myTableView endUpdates];
    }
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
    [fetchController release];
    [datePickerDate release];
    [myTableView release];
    [myDate release];
    [studentsArray release];
    [presencesArray release];
    [statusArray release];
    [course release];
    [super dealloc];
    
}


@end

