//
//  AddEmailViewController.m
//  Roll Call
//
//  Created by Weizhi on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddEmailViewController.h"
#import "AddStudentNameTableCell.h"
#import"Student.h"

@implementation AddEmailViewController

@synthesize email;
@synthesize tableCell;
@synthesize student;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.title = @"Add Email";
	//self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
	self.tableView.allowsSelection = NO;
	self.tableView.allowsSelectionDuringEditing = NO;
	self.tableView.rowHeight=60.0;
    [super viewDidLoad];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NameCell";
    AddStudentNameTableCell *cell = (AddStudentNameTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"AddStudentNameTableCell" owner:self options:nil];
        cell = tableCell;
		self.tableCell = nil;
    }
	cell.textField1.hidden=YES;
	cell.textField2.hidden=YES;
	cell.textField3.hidden=YES;
	cell.textField.placeholder = @"Email";
	cell.textField.font=[UIFont systemFontOfSize:20];
	cell.textField.autocapitalizationType=UITextAutocapitalizationTypeNone; 
	[cell.textField becomeFirstResponder];
	return cell;
}


- (void)save {
	AddStudentNameTableCell *cell;
    cell = (AddStudentNameTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    student.email = cell.textField.text;
	[self dismissModalViewControllerAnimated:YES];
}



- (void)cancel {
	[self dismissModalViewControllerAnimated:YES];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.email = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	[tableCell release];
    [email release];
	[student release];
    [super dealloc];    
}

@end

