//
//  ChangeDateViewController.m
//  Roll Call
//
//  Created by Kyle Conroy on Apr30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ChangeDateViewController.h"

@implementation ChangeDateViewController

@synthesize myPickerView;
@synthesize myDate;
@synthesize delegate;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
// Set the proper date
- (void)viewDidLoad {
    
    if(!myDate)
        myDate = [[NSDate alloc] init];
    
    [myPickerView setDate:myDate animated:YES];
    
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (IBAction) doneDate {
	[delegate changeDateViewController:self didChangeDate:myPickerView.date];
}

- (IBAction) cancelDate {
    [delegate changeDateViewController:self didChangeDate:nil];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [myDate release];
    [myPickerView release];
    [super dealloc];
}


@end
