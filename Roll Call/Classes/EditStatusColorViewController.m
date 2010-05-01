//
//  EditStatusColorViewController.m
//  Roll Call
//
//  Created by Kyle Conroy on May1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EditStatusColorViewController.h"


@implementation EditStatusColorViewController

@synthesize delegate;
@synthesize colors;
@synthesize currentRow;
@synthesize current;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [self setTitle:@"Pick Color"];
    
    colors = [[NSArray alloc] initWithObjects:@"Blue", @"Gray", @"Green", @"Orange", @"Purple", @"Red", @"White", @"Yellow", nil];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];    
    
    [super viewDidLoad];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [colors count];
}


- (void) cancel {
    [delegate editStatusColorViewController:self didChangeColor:nil];
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    cell.textLabel.text = [colors objectAtIndex:indexPath.row];
    
    if ([current isEqual:[colors objectAtIndex:indexPath.row] ]) {
        currentRow = indexPath;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:currentRow];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    currentRow = indexPath;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)save {
    [delegate editStatusColorViewController:self didChangeColor:[colors objectAtIndex:currentRow.row]];
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
    [colors release];
    [super dealloc];
}


@end

