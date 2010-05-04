//
//  AddAddressViewController.m
//  Roll Call
//
//  Created by Weizhi on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddAddressViewController.h"
#import "AddStudentNameTableCell.h"
#import "Student.h"
#import "Address.h"
#import "Roll_CallAppDelegate.h"

@implementation AddAddressViewController

@synthesize state;
@synthesize city;
@synthesize street;
@synthesize apt;
@synthesize zip;
@synthesize student;
@synthesize tableCell;


- (void)viewDidLoad {
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.title = @"Add Address";
	//self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
	self.tableView.allowsSelection = NO;
	self.tableView.allowsSelectionDuringEditing = NO;
	self.tableView.rowHeight=60.0;
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	Roll_CallAppDelegate *aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context=[aD managedObjectContext];
	if (student.address==nil)
		student.address = (Address *)[NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:context];
	static NSString *CellIdentifier = @"NameCell";
    AddStudentNameTableCell *cell = (AddStudentNameTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"AddStudentNameTableCell" owner:self options:nil];
        cell = tableCell;
		self.tableCell = nil;
    }
    if (indexPath.row == 0) {
		cell.textField1.hidden=YES;
		cell.textField2.hidden=YES;
		cell.textField3.hidden=YES;
        cell.textField.placeholder = @"Street";
		cell.textField.font=[UIFont systemFontOfSize:18];
		if (student.address.apt!=nil)
			cell.textField.text=student.address.apt;
		[cell.textField becomeFirstResponder];
    }
	else if (indexPath.row == 1){  
		cell.textField1.hidden=YES;
		cell.textField2.hidden=YES;
		cell.textField3.hidden=YES;
        cell.textField.placeholder = @"Street";
		cell.textField.font=[UIFont systemFontOfSize:18];
		if (student.address.street!=nil)
			cell.textField.text=student.address.street;
    } else {
		cell.textField.hidden=YES;
        cell.textField1.placeholder = @"City";
		cell.textField1.font=[UIFont systemFontOfSize:18];
		if (student.address.city!=nil)
			cell.textField1.text=student.address.city;
		
        cell.textField2.placeholder = @"State";
		cell.textField2.font=[UIFont systemFontOfSize:18];
		if (student.address.state!=nil)
			cell.textField2.text=student.address.state;
		
        cell.textField3.placeholder = @"ZIP";
		cell.textField3.font=[UIFont systemFontOfSize:18];
		if (student.address.zip!=nil)
			cell.textField3.text=student.address.zip;
	}
    return cell;
}

- (void)save {
	AddStudentNameTableCell *cell;
    cell = (AddStudentNameTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    student.address.apt = cell.textField.text;
    cell = (AddStudentNameTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	student.address.street = cell.textField.text;
	cell = (AddStudentNameTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
	student.address.city = cell.textField1.text;
	student.address.state = cell.textField2.text;
	student.address.zip = cell.textField3.text;
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
	self.city = nil;
	self.state = nil;
	self.apt = nil;
	self.zip = nil;
	self.street = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	[state release];
	[city release];
	[street release];
	[apt release];
	[zip release];
	[student release];
	[tableCell release];
    [super dealloc];
}


@end

