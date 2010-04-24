//
//  AddStudentNameViewController.m
//  Roll Call
//
//  Created by Weizhi Li on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddStudentNameViewController.h"
#import "AddStudentNameTableCell.h"
#import"Student.h"


@implementation AddStudentNameViewController

@synthesize firstName;
@synthesize lastName;
@synthesize tableCell;
@synthesize student;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.title = @"Add Name";
	//self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
	self.tableView.allowsSelection = NO;
	self.tableView.allowsSelectionDuringEditing = NO;
	self.tableView.rowHeight=60.0;
    [super viewDidLoad];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
    if (indexPath.row == 0) {
        cell.textField.placeholder = @"First";
		cell.textField.font=[UIFont boldSystemFontOfSize:20];
		[cell.textField becomeFirstResponder];
    }
	else     {    
        cell.textField.placeholder = @"Last";
		cell.textField.font=[UIFont boldSystemFontOfSize:20];
    }
    return cell;
}


- (void)save {
	AddStudentNameTableCell *cell;
    cell = (AddStudentNameTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    student.firstName = cell.textField.text;
    cell = (AddStudentNameTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	student.lastName = cell.textField.text;
	[self.navigationController popViewControllerAnimated:YES];
}



- (void)cancel {
	[self.navigationController popViewControllerAnimated:YES];
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
	self.firstName = nil;
	self.lastName = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	[tableCell release];
    [firstName release];
    [lastName release];
	[student release];
    [super dealloc];    
}

@end
