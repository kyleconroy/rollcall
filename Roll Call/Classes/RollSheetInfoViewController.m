//
//  RollSheetInfoViewController.m
//  Roll Call
//
//  Created by Kyle Conroy on Apr15.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RollSheetInfoViewController.h"
#import "EnrollStudentsViewController.h"
#import "Student.h"
#import "StudentViewController.h"
#import "RollSheetViewController.h"
#import "RollSheetInstance.h"

@implementation RollSheetInfoViewController

@synthesize course;
@synthesize aD;
@synthesize myTableView;
@synthesize fetchController;
@synthesize studentsSection;
@synthesize courseSection;
@synthesize studentsComplete;
@synthesize nameComplete;
@synthesize rowCount;
@synthesize dsCell;
@synthesize iView;

- (IBAction) enrollStudentsInClass: (id) sender {
    
}


- (void)viewDidLoad {
    self.title = @"Class Info";
    
    aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    studentsComplete = NO;
    nameComplete = NO;
    
    NSManagedObjectContext *context = [aD managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"ANY courses == %@", course];
    
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    [sortDescriptors release];
    [sortDescriptor release];
    
    fetchController = [[NSFetchedResultsController alloc]
                       
                       initWithFetchRequest:fetchRequest
                       
                       managedObjectContext:context
                       
                       sectionNameKeyPath:nil
                       
                       cacheName:@"RollSheetInfoView"];
    
    fetchController.delegate = self;
    
    [fetchRequest release];
    
    
    
    NSError *error; 
    BOOL success = [fetchController performFetch:&error];
    
    if (!success) {
        NSLog(@"Cannot get NSFetchedResultsController for Statuses");
    }
    
    
    courseSection = 0;
    studentsSection = 1;
    rowCount = [[[fetchController sections] objectAtIndex:0] numberOfObjects];
    
    
	//self.editing=YES;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (IBAction)deleteCourse
{
	UIActionSheet *deleteAlert = [[UIActionSheet alloc] initWithTitle: nil
															 delegate: self cancelButtonTitle:@"Cancel"
											   destructiveButtonTitle: nil
												    otherButtonTitles: @"Delete", nil, nil];
	deleteAlert.actionSheetStyle = UIBarStyleBlackTranslucent;
	[deleteAlert showInView:[[aD tabBarController] view]];
	[deleteAlert release];
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)modalView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Change the navigation bar style, also make the status bar match with it
	switch (buttonIndex)
	{
		case 0:
		{
			NSManagedObjectContext *context=[aD managedObjectContext];
			[[aD managedObjectContext] deleteObject:course];
			NSError *error;
			if (![context save:&error]) {
				// Handle the error.
			}
			[self.navigationController popViewControllerAnimated:NO];
			iView.pop=1;
			break;
		}
	}
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [myTableView setEditing:editing animated:animated];
    [self.navigationItem setHidesBackButton:editing animated:animated];
	[self.tableView beginUpdates];
    NSArray *updatedPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:rowCount inSection:studentsSection],nil];
	NSArray *deleteInsertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:2]];
    if(editing) {
		[self.tableView insertRowsAtIndexPaths:deleteInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
        [myTableView insertRowsAtIndexPaths:updatedPaths withRowAnimation:UITableViewRowAnimationTop];
	}
    else {
		[self.tableView deleteRowsAtIndexPaths:deleteInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
        [myTableView deleteRowsAtIndexPaths:updatedPaths withRowAnimation:UITableViewRowAnimationTop];
	}
	[self.tableView endUpdates];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == studentsSection) {
        return @"Enrolled Students";
    }
    return nil;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == courseSection) {
        return 1;
	} else if (section==2) {
			if (self.editing) 
				return 1;
    } else {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchController sections] objectAtIndex:0];
        
        int count = [sectionInfo numberOfObjects];
        NSLog(@"%i",count);
        if (self.editing) {
            return count + 1;
        } else {
            return count;
        }
    }
	return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
	}
    
    if (indexPath.section == courseSection) {
        cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if ([course.name isEqual:@"Course Name"])
            cell.textLabel.textColor = [UIColor grayColor];
        else
            cell.textLabel.textColor = [UIColor blackColor];
        
		cell.textLabel.text = course.name;
		iView.title=course.name;
	} else if (indexPath.section == studentsSection && indexPath.row >= rowCount) {
        cell.textLabel.text = @"enroll students";
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
	} else if (indexPath.section == 2) {
		static NSString *DeleteCellIdentifier = @"DeleteCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DeleteCellIdentifier];
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"DeleteCourseCell" owner:self options:nil];
			cell = dsCell;
			self.dsCell = nil;
		}
		cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
		return cell;
	} else {
        Student *s = [fetchController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", s.firstName, s.lastName];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section==0||indexPath.section==1)
		return TRUE;
	return FALSE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section==2)
		return 29;
	return 40;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.editing) {
        if (indexPath.section == studentsSection && indexPath.row >= rowCount) {
            return indexPath;
        } else if (indexPath.section == courseSection) {
            return indexPath;
        } else {
            return nil;
        }
    } else {
        if (indexPath.section == courseSection) {
            return nil;
        } else {
            return indexPath;
        }
    }
    
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == courseSection) {
        return NO;
    } else {
        return YES;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == courseSection) {
        return UITableViewCellEditingStyleNone;
    } else if (indexPath.section == studentsSection && indexPath.row >= rowCount) {
        return UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.editing) {
        if (indexPath.section == courseSection){
            
            EditTextFieldViewController *textController = [[EditTextFieldViewController alloc] 
                                                           initWithNibName:@"EditTextFieldViewController" bundle:nil];
            textController.delegate = self;
            textController.myType = [NSNumber numberWithInt:indexPath.row];
            textController.myTitle = @"Course Name";
            
            if (![course.name isEqual:@"Course Name"])
                textController.myText = course.name;
            
            [self.navigationController pushViewController:textController animated:YES];
            [textController release];
		} else if (indexPath.section == 2&&self.editing) {
				[self deleteCourse];
            
        } else if (indexPath.section == studentsSection && indexPath.row >= rowCount) {
            
            EnrollStudentsViewController *enrollController = [[EnrollStudentsViewController alloc] 
                                                              initWithNibName:@"EnrollStudentsViewController" bundle:nil];
            enrollController.delegate = self;
            enrollController.initial = [fetchController fetchedObjects];
            [self.navigationController pushViewController:enrollController animated:YES];
            [enrollController release];
        }
    } else {
    
        StudentViewController *anotherViewController = [[StudentViewController alloc] initWithNibName:@"StudentViewController" bundle:nil];
        Student *student = [fetchController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        anotherViewController.title = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
        anotherViewController.currentStudent = student;
        
        [self.navigationController pushViewController:anotherViewController animated:YES];
        [anotherViewController release];
        
    }
    
	
}

- (void)enrollStudentsViewController:(EnrollStudentsViewController *)enrollStudentsViewController

                        withStudents:(NSMutableArray *)enrolled {
    
}


- (void)enrollStudentsViewController:(EnrollStudentsViewController *)enrollStudentsViewController

                           withAdded:(NSMutableArray *)added removed:(NSMutableArray *)removed {
    
    if (added && removed) {
        
        NSManagedObjectContext *context = [aD managedObjectContext];
        
        [course addStudents:[NSSet setWithArray:added]];
        [course removeStudents:[NSSet setWithArray:removed]];
        
        NSError *error;
        if (![context save:&error]) {
            // Handle the error.
        }
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
};


- (void)editTextFieldViewController:(EditTextFieldViewController *)editTextFieldViewController

                           withType: (NSNumber*)type didChangeText:(NSString *)text {
    
    if(text){
        // this needs to be saved
        course.name = text;
        [self.navigationItem setTitle:course.name];
        [myTableView reloadData];
		
		NSError *error;
		if (![[aD managedObjectContext] save:&error]) {
			// Handle the error.
		}
		
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Student *s = [fetchController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        NSLog(@"%@",s.firstName);
        [course removeStudentsObject:s];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    
    NSError *error;
    if (![[aD managedObjectContext] save:&error]) {
        // Handle the error.
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
    
    int hackSection = 0;
    
    
    
    switch(type) {
            
            
            
        case NSFetchedResultsChangeInsert:
            
            rowCount = [[[controller sections] objectAtIndex:hackSection] numberOfObjects];
            
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:newIndexPath.row inSection:studentsSection]]
             
                             withRowAnimation:UITableViewRowAnimationRight];
            
            break;
            
            
            
        case NSFetchedResultsChangeDelete:
            
            rowCount = [[[controller sections] objectAtIndex:hackSection] numberOfObjects];
            
            
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:studentsSection]]
             
                             withRowAnimation:UITableViewRowAnimationRight];
            
            break;
            
            
            
        case NSFetchedResultsChangeUpdate:
            
            //[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            
            break;
            
            
            
        case NSFetchedResultsChangeMove:
                
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
             
                             withRowAnimation:UITableViewRowAnimationRight];
            
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
             
                             withRowAnimation:UITableViewRowAnimationRight];
    
            
            break;
            
    }
    
}





- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [myTableView endUpdates];
    
}



- (void)dealloc {
    [fetchController release];
    [myTableView release];
    [super dealloc];
}


@end


