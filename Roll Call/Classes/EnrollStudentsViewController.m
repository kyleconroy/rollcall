//
//  EnrollStudentsViewController.m
//  Roll Call
//
//  Created by Kyle Conroy on May1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EnrollStudentsViewController.h"
#import "Student.h"

@implementation EnrollStudentsViewController

@synthesize delegate;
@synthesize aD;
@synthesize chosen;
@synthesize students;
@synthesize myTableView;
@synthesize initial;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
    students = [aD getAllStudents];
    chosen = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [students count]; i++){
        if ([initial containsObject:[students objectAtIndex:i]]) {
            [chosen addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    [self setTitle:@"Enroll Students"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
	
    
    [super viewDidLoad];

}


#pragma mark -
#pragma mark Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [students count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EnrollCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if ([chosen containsObject:[NSNumber numberWithInt:indexPath.row]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    Student *s = [students objectAtIndex: indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", s.firstName, s.lastName];
    
    return cell;
}


- (void) save {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    [chosen sortUsingSelector:@selector(compare:)];
    
    for (NSNumber *n in chosen) {
        [result addObject:[students objectAtIndex:[n intValue]]];
    }
    
    [delegate enrollStudentsViewController:self withStudents:result];
    
}

- (void) cancel {
    [delegate enrollStudentsViewController:self withStudents:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


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

    if ([chosen containsObject:[NSNumber numberWithInt:indexPath.row]]) {
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
        [chosen removeObject:[NSNumber numberWithInt:indexPath.row]];
    } else {
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        [chosen addObject:[NSNumber numberWithInt:indexPath.row]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

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
    [chosen release];
    [students release];
    [super dealloc];
}


@end

