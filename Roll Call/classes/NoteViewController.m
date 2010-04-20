//
//  NoteViewController.m
//  Roll Call
//
//  Created by Weizhi on 4/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NoteViewController.h"
#import "Roll_CallAppDelegate.h"
#import "Presence.h"

@implementation NoteViewController


@synthesize myNoteView;
@synthesize myTextView;
@synthesize button1;
@synthesize button2;
@synthesize presence;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    myTextView.text = presence.note;
	[button1 setTitle:@"Edit"];
	[button1 setAction:@selector(editNote)];
	myTextView.keyboardAppearance=NO;
	myTextView.editable=NO;
    [super viewDidLoad];
}

- (IBAction) hideNote {
	myTextView.keyboardAppearance=NO;
	myTextView.editable=NO;
	[self dismissModalViewControllerAnimated:YES];    
}

- (IBAction) editNote {
	myTextView.editable = YES;
	myTextView.keyboardAppearance=YES;
	[myTextView resignFirstResponder];
	[button1 setTitle:@"Save"];
	[button1 setAction:@selector(doneNote)];
}

- (IBAction) doneNote {
	presence.note = myTextView.text;
    NSError *error;
	Roll_CallAppDelegate *aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[aD managedObjectContext] save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
	myTextView.keyboardAppearance=NO;
	myTextView.editable=NO;
	[button1 setTitle:@"Edit"];
	[button1 setAction:@selector(editNote)];
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
}

@end
