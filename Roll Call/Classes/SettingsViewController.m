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

@synthesize statusController;
@synthesize aD;
@synthesize myTableView;
@synthesize rowCount;
@synthesize inReorderingOperation;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Statuses"];
    
    aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //Let's try this out
    
    NSManagedObjectContext *context = [aD managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Status" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    // Configure the request's entity, and optionally its predicate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"rank" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [sortDescriptors release];
    [sortDescriptor release];
    
    inReorderingOperation = NO;
    
    statusController = [[NSFetchedResultsController alloc]
                                              
                                              initWithFetchRequest:fetchRequest
                                              
                                              managedObjectContext:context
                                              
                                              sectionNameKeyPath:nil
                                              
                                              cacheName:@"AllStatuses"];
    
    statusController.delegate = self;
    
    [fetchRequest release];
    
    
    
    NSError *error;
    
    BOOL success = [statusController performFetch:&error];
    
    if (!success) {
        NSLog(@"Cannot get NSFetchedResultsController for Statuses");
    }
    
    rowCount = [[[statusController sections] objectAtIndex:0] numberOfObjects];
    
    myTableView.allowsSelectionDuringEditing = YES;
    
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
											  initWithTitle:@"Help" 
											  style:UIBarButtonItemStyleBordered 
											  target:self 
											  action:@selector(showHelp)];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (IBAction)showHelp {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Help" message:@"Reorder this table to change attendance-taking order. You can mark all students \"default\" status with shake gesture"
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
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
    
    return [[statusController sections] count];
    
}



- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[statusController sections] objectAtIndex:section];
    
    int count = [sectionInfo numberOfObjects];

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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = @"default";
    } else {
        cell.detailTextLabel.text = @"";
    }
    
    if (indexPath.row >= rowCount) {
        cell.textLabel.text = @"add new status";
    } else {
        NSManagedObject *managedObject = [statusController objectAtIndexPath:indexPath];
        cell.textLabel.text = [managedObject valueForKey:@"text"];
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
    if (self.editing && indexPath.row == rowCount) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *managedObject = [statusController objectAtIndexPath:indexPath];
        [[aD managedObjectContext] deleteObject:managedObject];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
    //[self recalculateRank];
    
    NSError *error;
    if (![[aD managedObjectContext] save:&error]) {
        // Handle the error.
    }
}


- (NSIndexPath *)tableView:(UITableView *)tableView

targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath

       toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    if (proposedDestinationIndexPath.row >= rowCount) {
        
        return [NSIndexPath indexPathForRow:rowCount - 1 inSection:0];
        
    }
    
    // Allow the proposed destination.
    
    return proposedDestinationIndexPath;
    
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    if (indexPath.row == rowCount) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
      toIndexPath:(NSIndexPath *)toIndexPath {
    
    inReorderingOperation = YES;
    
    // Big thanks to http://tworrall.blogspot.com/2010/02/reordering-rows-in-uitableview-with.html
    
    NSMutableArray *array = [[statusController fetchedObjects] mutableCopy];
    
    id objectToMove = [[array objectAtIndex:fromIndexPath.row] retain];
    [array removeObjectAtIndex:fromIndexPath.row];
    [array insertObject:objectToMove atIndex:toIndexPath.row];
    [objectToMove release];
    
    
    for (int i=0; i<[array count]; i++)
    {
        [(NSManagedObject *)[array objectAtIndex:i] setValue:[NSNumber numberWithInt:i] forKey:@"rank"];
    }
    [array release];
    
    self.inReorderingOperation = NO;
    
    NSError *error;
    BOOL success = [statusController performFetch:&error];
    if (!success)
    {
        NSLog(@"Could Not resort the fetch controller");
    }
    
    success = [[aD managedObjectContext] save:&error];
    if (!success)
    {
        NSLog(@"Could not save the reordering");

    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [myTableView setEditing:editing animated:animated];
    [self.navigationItem setHidesBackButton:editing animated:animated];
    NSArray *updatedPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:rowCount inSection:0],nil];
    
    if(editing)
        [myTableView insertRowsAtIndexPaths:updatedPaths withRowAnimation:UITableViewRowAnimationTop];
    else {
        [myTableView deleteRowsAtIndexPaths:updatedPaths withRowAnimation:UITableViewRowAnimationTop];
		[myTableView reloadData];
	}
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= rowCount) {
        
        AddStatusViewController *addStatusController = [[AddStatusViewController alloc] 
                                                     initWithNibName:@"AddStatusViewController" bundle:nil];
        addStatusController.delegate = self;
        [self.navigationController pushViewController:addStatusController animated:YES];
        [addStatusController release];
        
    } else {
        
        StatusInstanceViewController *addStatusController = [[StatusInstanceViewController alloc] 
                                                          initWithNibName:@"StatusInstanceViewController" bundle:nil];
        addStatusController.myStatus = [statusController objectAtIndexPath:indexPath];
        [self.navigationController pushViewController:addStatusController animated:YES];
        [addStatusController release];
        
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.editing) {
        if (indexPath.row >= rowCount) {
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
        p.rank = [NSNumber numberWithInt:rowCount];
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Error Saving New Status: %@", [error localizedDescription]);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    [self.myTableView beginUpdates];
    
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo

           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            
            
            [self.myTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
             
                          withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
            
            
        case NSFetchedResultsChangeDelete:
            
            
            
            [self.myTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
             
                          withRowAnimation:UITableViewRowAnimationFade];
            
            break;
            
    }
    
}





- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject

       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type

      newIndexPath:(NSIndexPath *)newIndexPath {
    
    
    
    UITableView *tableView = self.myTableView;
    
    
    
    switch(type) {
            
            
            
        case NSFetchedResultsChangeInsert:
            
            rowCount = [[[controller sections] objectAtIndex:newIndexPath.section] numberOfObjects];
            
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
             
                             withRowAnimation:UITableViewRowAnimationRight];
            
            break;
            
            
            
        case NSFetchedResultsChangeDelete:
            
            rowCount = [[[controller sections] objectAtIndex:newIndexPath.section] numberOfObjects];
            
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
             
                             withRowAnimation:UITableViewRowAnimationRight];
            
            break;
            
            
            
        case NSFetchedResultsChangeUpdate:
            
            //[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            
            break;
            
            
            
        case NSFetchedResultsChangeMove:
            
            if (!inReorderingOperation){
            
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                 
                                 withRowAnimation:UITableViewRowAnimationRight];
                
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                 
                                 withRowAnimation:UITableViewRowAnimationRight];
            }
            
            break;
            
    }
    
}





- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [myTableView endUpdates];
    
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
    [statusController release];
    [super dealloc];
}


@end

