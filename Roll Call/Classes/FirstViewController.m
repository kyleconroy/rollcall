//
//  FirstViewController.m
//  Roll Call
//
//  Created by Kyle Conroy on Mar22.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "FirstViewController.h"


@implementation FirstViewController

@synthesize managedObjectContext;
@synthesize aD;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Iplement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {   
    aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
    managedObjectContext = [aD managedObjectContext];
    [super viewDidLoad];
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
    [managedObjectContext release];
    [super dealloc];
}

@end
