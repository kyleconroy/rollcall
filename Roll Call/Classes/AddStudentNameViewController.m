//
//  AddStudentNameViewController.m
//  Roll Call
//
//  Created by Weizhi Li on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddStudentNameViewController.h"
#import "Student.h"
#import "AddStudentNameTableCell.h"

@implementation AddStudentNameViewController

@synthesize firstName;
@synthesize lastName;
@synthesize tableCell;
@synthesize aD;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.title = @"Add Name";
	self.tableView.allowsSelection = NO;
	self.tableView.allowsSelectionDuringEditing = NO;
    [super viewDidLoad];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"NameCell";
    
	aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
    AddStudentNameTableCell *cell = (AddStudentNameTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"AddStudentNameTableCell" owner:self options:nil];
        cell = tableCell;
		self.tableCell = nil;
    }
    Student *student=[aD.students lastObject];
    if (indexPath.row == 0) {
        cell.textField.text =  student.firstName;
        cell.textField.placeholder = @"First";
    }
	else     {    
		cell.textField.text = student.lastName;
        cell.textField.placeholder = @"Last";
    }
	
    return cell;
}


- (void)save {
	AddStudentNameTableCell *cell;
	Student *student=[aD.students lastObject];

    cell = (AddStudentNameTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    student.firstName = cell.textField.text;
	
    cell = (AddStudentNameTableCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    student.lastName = cell.textField.text;
	
	
	NSLog(@"added: %@ %@",  student.lastName , student.firstName);
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
