//
//  EditTextFieldViewController.m
//  Roll Call
//
//  Created by Kyle Conroy on May1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EditTextFieldViewController.h"

@implementation EditTextFieldViewController

@synthesize delegate;
@synthesize myCell;
@synthesize myPlaceHolder;
@synthesize myText;
@synthesize myTextField;
@synthesize myTitle;
@synthesize myType;


#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    
    [self setTitle:myTitle];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];    
    self.tableView.allowsSelection = NO;
    self.tableView.allowsSelectionDuringEditing = NO;
    self.tableView.rowHeight=60.0;
    
    

    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated {
    [myTextField becomeFirstResponder];
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EditTextFieldCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = myCell;
        myCell = nil;
    }
    
    myTextField.text = myText;
    myTextField.placeholder = myPlaceHolder;

    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}

- (void) cancel {
    [delegate editTextFieldViewController:self withType:myType didChangeText:nil];
}

- (void) save {
	[delegate editTextFieldViewController:self withType:myType didChangeText:myTextField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [delegate editTextFieldViewController:self withType:myType didChangeText:myTextField.text];
    return NO;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [myPlaceHolder release];
    [myText release];
    [myTitle release];
    [myType release];
    [myTextField release];
    [myCell release];
    [super dealloc];
}


@end

