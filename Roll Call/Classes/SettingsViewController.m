//
//  SettingsViewController.m
//  Roll Call
//
//  Created by Kyle Conroy on Apr21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "StatusInstanceViewController.h"
#import "AddStatusViewController.h"
#import "Status.h"

@implementation SettingsViewController

@synthesize statusArray;
@synthesize aD;
@synthesize myTableView;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Statuses"];
    
    aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    statusArray = [aD getAllStatuses];
    [statusArray retain];
    
    myTableView.allowsSelectionDuringEditing = YES;
    
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTable)];

}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [myTableView reloadData];
    [super viewDidAppear:animated];
}

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
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    int count = [statusArray count];

    if (self.editing) {
        count += 1;
    } 
    
    return count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row >= [statusArray count]) {
        cell.textLabel.text = @"add new status";
    } else {
        cell.textLabel.text = [[statusArray objectAtIndex:indexPath.row] text];
    }

    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing == NO || !indexPath) 
        return UITableViewCellEditingStyleNone;
    if (self.editing && indexPath.row == ([statusArray count])) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Status *s = [statusArray objectAtIndex:indexPath.row];
        [[aD managedObjectContext] deleteObject:s];
        [statusArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
    [self recalculateRank];
    
    NSError *error;
    if (![[aD managedObjectContext] save:&error]) {
        // Handle the error.
    }
}


- (NSIndexPath *)tableView:(UITableView *)tableView

targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath

       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    if (proposedDestinationIndexPath.row >= [statusArray count]) {
        
        return [NSIndexPath indexPathForRow:[statusArray count] - 1 inSection:0];
        
    }
    
    // Allow the proposed destination.
    
    return proposedDestinationIndexPath;
    
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    if (indexPath.row == [statusArray count]) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath {
    Status *moved = [statusArray objectAtIndex:fromIndexPath.row];
    [statusArray removeObject:moved];
    [statusArray insertObject:moved atIndex:toIndexPath.row];
    
    [self recalculateRank];
    
    NSError *error;
    if (![[aD managedObjectContext] save:&error]) {
        // Handle the error.
    }
}

- (void) recalculateRank {
    for (int i = 0; i < [statusArray count]; i++) {
        Status *p = [statusArray objectAtIndex:i];
        p.rank = [NSNumber numberWithInt:i];
    }
}

- (void) editTable {
    if(self.editing)
    {
        [super setEditing:NO animated:YES];
        [myTableView setEditing:NO animated:NO];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
        
        /* Remove editing row */
        NSArray *updatedPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[statusArray count] inSection:0],nil];
        [myTableView deleteRowsAtIndexPaths:updatedPaths withRowAnimation:UITableViewRowAnimationTop];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [myTableView setEditing:YES animated:YES];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
        
        /* Add editing row */
        //[myTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects: [NSIndexPath indexPathForRow:2 inSection:0],nil] 
        //                   withRowAnimation:UITableViewRowAnimationTop];
        
        NSArray *updatedPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[statusArray count] inSection:0],nil];
        [myTableView insertRowsAtIndexPaths:updatedPaths withRowAnimation:UITableViewRowAnimationTop];
    }
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= [statusArray count]) {
        
        AddStatusViewController *statusController = [[AddStatusViewController alloc] 
                                                     initWithNibName:@"AddStatusViewController" bundle:nil];
        statusController.delegate = self;
        [self.navigationController pushViewController:statusController animated:YES];
        [statusController release];
        
    } else {
        
        StatusInstanceViewController *statusController = [[StatusInstanceViewController alloc] 
                                                          initWithNibName:@"StatusInstanceViewController" bundle:nil];
        statusController.myStatus = [statusArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:statusController animated:YES];
        [statusController release];
        
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.editing) {
        if (indexPath.row >= [statusArray count]) {
            return indexPath;
        }
        return nil;
    } else {
        return indexPath;
    }

}

- (void)addStatusViewController:(AddStatusViewController *)addStatusViewController

                       withText:(NSString *)text letter:(NSString *)letter imageName:(NSString *)imageName {
    
    NSManagedObjectContext *context = [aD managedObjectContext];
    
    if (text && letter && imageName){
        Status *p = (Status *)[NSEntityDescription insertNewObjectForEntityForName:@"Status" inManagedObjectContext:context];
        p.text = text;
        p.letter = letter;
        p.imageName = imageName;
        p.rank = [NSNumber numberWithInt:[statusArray count]];
        
        NSError *error;
        if (![context save:&error]) {
            // Handle the error.
        }
        
        [statusArray addObject:p]; 
        
    }

    [myTableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    
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
    [super dealloc];
}


@end

