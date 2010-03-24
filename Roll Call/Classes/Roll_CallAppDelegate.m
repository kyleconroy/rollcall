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
    
    students = [[NSArray alloc] initWithObjects:
                [[Student alloc] initWithFirstName:@"Jeff" lastName:@"Jumpy"], 
                [[Student alloc] initWithFirstName:@"Kyle" lastName:@"Kooky"],
                [[Student alloc] initWithFirstName:@"Lauren" lastName:@"Lazy"], 
                nil];
    
    classes = [[NSArray alloc] initWithObjects:
                [[SchoolClass alloc] initWithName:@"Algebra"], 
                [[SchoolClass alloc] initWithName:@"Triginometry"],
                [[SchoolClass alloc] initWithName:@"Geometery"], 
                nil];
    
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
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


- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

