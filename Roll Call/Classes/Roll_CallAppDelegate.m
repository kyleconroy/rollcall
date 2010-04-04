//
//  Roll_CallAppDelegate.m
//  Roll Call
//
//  Created by Kyle Conroy on Mar22.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "Roll_CallAppDelegate.h"
#import "Student.h"
#import "SchoolClass.h"

@implementation Roll_CallAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize students;
@synthesize classes;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    // Configure and show the window.
    //bool install = YES;
    
    if (install) {
        //[self installCourses];
        //[self installStudents];
        
    }
    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];

}

- (void) installStudents {
    NSManagedObjectContext *context = [self managedObjectContext];
    if (!context) {
        NSLog(@"Context isn't loading correctly, shit");
    }
    
    NSMutableArray *courses = [self getAllCourses];
    
    NSArray *kids = [[NSArray alloc] initWithObjects:
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Timmy", @"firstName", @"Took", @"lastName", nil], 
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Kyle", @"firstName", @"Kooky", @"lastName", nil], 
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Lindsay", @"firstName", @"Lame", @"lastName", nil],
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
    NSManagedObjectContext *context = [self managedObjectContext];
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


/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/

//Data Helper Methods 

- (NSMutableArray *) getAllStudents {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    [sortDescriptors release];
    [sortDescriptor release];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        NSLog(@"Can't fetch the students array"); 
    }
    
    return mutableFetchResults ;
    // Make sure to release this array
}

- (NSMutableArray *) getAllCourses {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:[self managedObjectContext]];
    [request setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    [sortDescriptors release];
    [sortDescriptor release];
    
    NSError *error;
    NSMutableArray *mutableFetchResults = [[[self managedObjectContext] executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        NSLog(@"Can't fetch the students array"); 
    }
    
    return mutableFetchResults ;
    // Make sure to release this array
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"Roll_Call.sqlite"]];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 
		 Typical reasons for an error here include:
		 * The persistent store is not accessible
		 * The schema for the persistent store is incompatible with current managed object model
		 Check the error message to determine what the actual problem was.
		 */
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
    }    
	
    return persistentStoreCoordinator;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}



- (void)dealloc {
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
    
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

