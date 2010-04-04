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
    [super viewDidLoad];
}

-(IBAction) installData {
    [self installCourses];
    [self installStudents];
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


-(IBAction) installStatuses {
    NSManagedObjectContext *context = [aD managedObjectContext];
    
    NSArray *statuses = [[NSArray alloc] initWithObjects:
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Present", @"text", [NSNumber numberWithInt:1], @"rank", @"P", @"letter", 
                          [UIColor colorWithRed:0.369 green:0.835 blue:0.128 alpha:1.000], @"color", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Absent", @"text", [NSNumber numberWithInt:4 ], @"rank", @"A", @"letter", 
                          [UIColor colorWithRed:0.835 green:0.103 blue:0.182 alpha:1.000], @"color", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Tardy", @"text", [NSNumber numberWithInt:3 ], @"rank", @"T", @"letter", 
                          [UIColor colorWithRed:0.179 green:0.298 blue:0.835 alpha:1.000], @"color", nil],
                         [NSDictionary dictionaryWithObjectsAndKeys:@"Excused", @"text", [NSNumber numberWithInt:2 ], @"rank", @"E", @"letter", 
                          [UIColor colorWithRed:0.369 green:0.835 blue:0.128 alpha:1.000], @"color", nil],
                         nil];
    
    for (NSDictionary *d in statuses){
        NSLog(@"Status %@", [d objectForKey:@"text"]);
        Status *status = (Status *)[NSEntityDescription insertNewObjectForEntityForName:@"Status" inManagedObjectContext:context];
        status.text = [d objectForKey:@"text"];
        status.rank = [d objectForKey:@"rank"];
        status.color = [d objectForKey:@"color"];
        status.letter = [d objectForKey:@"letter"];
    }
    
    NSError *error;
    if (![context save:&error]) {
        // Handle the error.
    }
    
}

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


- (void)dealloc {
    [super dealloc];
}


@end
