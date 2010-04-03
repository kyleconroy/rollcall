//
//  AddStudentNameViewController.m
//  Roll Call
//
//  Created by Weizhi Li on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddStudentNameViewController.h"

@class Student;

@implementation AddStudentNameViewController

@synthesize firstName;
@synthesize lastName;
@synthesize lastNameText;
@synthesize firstNameText;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.title = @"Add Name";
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	[firstName becomeFirstResponder];
	[lastName becomeFirstResponder];
    [super viewDidLoad];
}




- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == firstName) {
		[firstName resignFirstResponder];
		firstNameText=firstName.text;
	}
	if (textField == lastName) {
		[lastName resignFirstResponder];
		lastNameText=lastName.text;
	}
	return YES;
}

- (void)save {
	lastNameText=lastName.text;
	firstNameText=firstName.text;
	NSLog(@"added: %@ %@", firstNameText, lastNameText);
	[self dismissModalViewControllerAnimated:YES];
}



- (void)cancel {
	[self dismissModalViewControllerAnimated:YES];
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
	self.firstName = nil;
	self.lastName = nil;
	[super viewDidUnload];
}


- (void)dealloc {
    [firstName release];
    [lastName release];
    [super dealloc];    
}

@end
