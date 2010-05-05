//
//  DebugViewController.m
//  Roll Call
//
//  Created by Kyle Conroy on Apr4.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DebugViewController.h"
#import "Student.h"
#import "Course.h"
#import "Status.h"
#import "Presence.h"

#define DAY  86400

@implementation DebugViewController

@synthesize aD;
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
    [self becomeFirstResponder];
    [super viewDidLoad];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventSubtypeMotionShake) {
//        [self installCourses];
//        [self installStudents];
        NSString *title = [NSString stringWithFormat:@"Testing Framework"];
        NSString *alertMessage = [NSString stringWithFormat:@"Installed student and class test data"];
        NSString *ok = [NSString stringWithFormat:@"Dismiss"];
        
        // open an alert with just an OK button
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:alertMessage  delegate:self cancelButtonTitle:ok otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(IBAction) installData {
	[self installStudents];
	[self installCourses];
}

- (void) installStudents {
    NSManagedObjectContext *context = [aD managedObjectContext];
    
    NSMutableArray *courses = [aD getAllCourses];
    
    NSArray *kids = [[NSArray alloc] initWithObjects:
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Kristina", @"firstName", @"Chung", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Paige", @"firstName", @"Chen", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Sherri", @"firstName", @"Melton", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Gretchen", @"firstName", @"Hill", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Karen", @"firstName", @"Puckett", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Patrick", @"firstName", @"Song", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Elsie", @"firstName", @"Hamilton", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Hazel", @"firstName", @"Bender", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Malcolm", @"firstName", @"Wagner", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Dolores", @"firstName", @"McLaughlin", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Francis", @"firstName", @"McNamara", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Sandy", @"firstName", @"Raynor", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Marion", @"firstName", @"Moon", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Beth", @"firstName", @"Woodard", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Julia", @"firstName", @"Desai", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Jerome", @"firstName", @"Wallace", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Neal", @"firstName", @"Lawrence", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Jean", @"firstName", @"Griffin", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Kristine", @"firstName", @"Dougherty", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Crystal", @"firstName", @"Powers", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Alex", @"firstName", @"May", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Eric", @"firstName", @"Steele", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Wesley", @"firstName", @"Teague", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Franklin", @"firstName", @"Vick", @"lastName", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Claire", @"firstName", @"Gallagher", @"lastName", nil],
                     nil];
    
    for (NSDictionary *d in kids){
        NSLog(@"Student %@, %@", [d objectForKey:@"firstName"], [d objectForKey:@"lastName"]);
        Student *student = (Student *)[NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
        [student setFirstName:[d objectForKey:@"firstName"]];
        [student setLastName:[d objectForKey:@"lastName"]];
        
        for (Course *c in courses) {
            [student addCoursesObject:c];
        }
        
    }
    
    NSError *error;
    if (![context save:&error]) {
        // Handle the error.
    }
}

- (void) installCourses {
    NSManagedObjectContext *context = [aD managedObjectContext];
    if (!context) {
        NSLog(@"Context isn't loading correctly, shit");
    }
    
    NSArray *courses = [[NSArray alloc] initWithObjects:
                        [NSDictionary dictionaryWithObjectsAndKeys:@"Algebra", @"name",nil], 
                        [NSDictionary dictionaryWithObjectsAndKeys:@"Geometry", @"name", nil], 
                        [NSDictionary dictionaryWithObjectsAndKeys:@"Math", @"name", nil],
                        nil];
    
    for (NSDictionary *d in courses){
        NSLog(@"Course %@, %@", [d objectForKey:@"name"]);
        Course *course = (Course *)[NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
        [course setName:[d objectForKey:@"name"]];
    }
    
    NSError *error;
    if (![context save:&error]) {
        // Handle the error.
    }
}

-(IBAction)mailIt {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;  
    
    [picker setSubject:@"[Roll Call] Class Attendance Report"];
    
    NSArray *courses = [aD getAllCourses];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit 
                                          fromDate:[aD getEarliestPresenceDate]];
    
    [comps setHour:00];
    [comps setMinute:00];
    [comps setSecond:00];

    for (Course *c in courses) {
        
        
        //Get the students, and sort them by last name
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        NSMutableArray * ss = [[NSMutableArray alloc] init];
        
        //get all students in the class
        NSEnumerator *e = [c.students objectEnumerator];
        id collectionMemberObject;
        
        //add them to a temporary array
        while ( (collectionMemberObject = [e nextObject]) ) {
            [ss addObject:collectionMemberObject];
        }
        
        // return the sorted array
        NSArray *students = [ss sortedArrayUsingDescriptors:sortDescriptors];
        
        //NSString *csv = [[header componentsJoinedByString:@","] stringByAppendingString:@"\n"];
        NSString *csv = @"";
        
        for (Student *s in students) {
            NSMutableArray *row = [NSMutableArray arrayWithObjects:s.firstName, s.lastName, nil];
            NSDate *startDate = [calendar dateFromComponents:comps];
            
            while ([startDate compare:[NSDate date]] ==  NSOrderedAscending) {
                NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"(date >= %@) AND (date <= %@) AND (course == %@)", startDate, [startDate addTimeInterval:DAY] , c];    
                NSSet *events = [s.presences filteredSetUsingPredicate:myPredicate];
                Presence *p = [events anyObject];
                if (p) {
                    [row addObject:p.status.text];
                } else {
                    [row addObject:@""];
                }
                startDate = [startDate addTimeInterval:DAY];
            }
            
            csv = [csv stringByAppendingString:[[row componentsJoinedByString:@","] stringByAppendingString:@"\n"]];
            
        }
        
        
        NSLog(@"%@\n: %@", c.name, csv);
        
        [picker addAttachmentData:[csv dataUsingEncoding:NSUTF8StringEncoding] 
                       mimeType:@"text/csv" fileName:[NSString stringWithFormat:@"%@_attendance_report.csv", c.name]]; // addd ate?
        
        [sortDescriptor release];
        [sortDescriptors release];
        [ss release];
    }
    

    
    NSString *emailBody = @"Thanks for using Roll Call! Here is your data, sorted by class.";
    [picker setMessageBody:emailBody isHTML:YES];
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    if (result == MFMailComposeResultSent){
        NSLog(@"Message Sent");
    } else {
        NSLog(@"Message not Sent");
    }

    [self dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    [self resignFirstResponder];
}


- (void)dealloc {
    [super dealloc];
}


@end
