//
//  RollSheetAddNoteController.m
//  Roll Call
//
//  Created by Kyle Conroy on Apr13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RollSheetAddNoteController.h"


@implementation RollSheetAddNoteController

@synthesize presence;
@synthesize aD;
@synthesize myTextView;
@synthesize button;

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
- (void)viewDidLoad {
    aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
    myTextView.text = presence.note;
    [myTextView becomeFirstResponder];
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void) hideNote {
    [myTextView resignFirstResponder];
    [self dismissModalViewControllerAnimated:YES];    
}

- (IBAction) doneNote {
    presence.note = myTextView.text;
    
    NSError *error;
    if (![[aD managedObjectContext] save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    if ([presence.note length] == 0) {
        [button setImage:[UIImage imageNamed:@"note_outline.png"] forState:UIControlStateNormal];
    } else {
        [button setImage:[UIImage imageNamed:@"note_on.png"] forState:UIControlStateNormal];
    }

    [self hideNote];
}

- (IBAction) cancelNote {
    [self hideNote];
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
    [super dealloc];
    [myTextView release];
}


@end
