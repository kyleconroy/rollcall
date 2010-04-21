//
//  RollSheetInfoViewController.m
//  Roll Call
//
//  Created by Kyle Conroy on Apr15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RollSheetInfoViewController.h"


@implementation RollSheetInfoViewController


@synthesize course;
@synthesize students;
@synthesize tableLayout;
@synthesize editTableLayout;
@synthesize myTableView;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
   
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    [self setTitle:@"Course Info"];
    

    tableLayout = [[NSArray alloc] initWithObjects:
                   [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithInt:1], @"count", [NSNumber numberWithBool:YES], @"edit", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithInt:3], @"count",
                    @"Actions", @"header", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithInt:3], @"count",
                    @"Schedule", @"header", [NSNumber numberWithBool:YES], @"edit", nil],
                    nil];
    
    
    editTableLayout = [[NSArray alloc] initWithObjects:
                   [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithInt:1], @"count", [NSNumber numberWithBool:YES], @"edit", nil],
                   [NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithInt:3], @"count",
                    @"Schedule", @"header", [NSNumber numberWithBool:YES], @"edit", nil],
                   nil];
    
    myTableView = (UITableView *) self.view;

    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(enterEditMode)] animated:NO];
    
    [super viewDidLoad];
}

- (void) enterEditMode {
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)] animated:YES];
    [myTableView setEditing:YES animated:YES];
    [myTableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:YES];
    
    
}

- (void) leaveEditMode {
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(enterEditMode)] animated:YES];
    [myTableView setEditing:NO animated:YES];
    [myTableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:YES];
}
/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (tableView.editing) {
        return [editTableLayout count];
    } else {
        return [tableLayout count];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    // The header for the section is the region name -- get this from the region at the section index.
    if (tableView.editing) {
        return [[editTableLayout objectAtIndex:section] valueForKey:@"header"];
    } else {
        return [[tableLayout objectAtIndex:section] valueForKey:@"header"];
    }
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView.editing) {
        return [[[editTableLayout objectAtIndex:section] valueForKey:@"count"] intValue];
    } else {
        return [[[tableLayout objectAtIndex:section] valueForKey:@"count"] intValue];
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell...
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if([[tableLayout objectAtIndex:indexPath.section] valueForKey:@"edit"]) {
        return YES;
    } else {
        return NO;
    }

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return UITableViewCellEditingStyleNone;
    
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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
    [editTableLayout release];
    [tableLayout release];
    [super dealloc];
}


@end

