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

@implementation RollSheetInfoViewController

@synthesize course;
@synthesize aD;
@synthesize addedStudents;
@synthesize myTableView;
@synthesize courseName;
@synthesize studentsSection;
@synthesize courseSection;
@synthesize studentsComplete;
@synthesize nameComplete;

- (IBAction) enrollStudentsInClass: (id) sender {
    
}


- (void)viewDidLoad {
    self.title = @"Class Info";
    
    aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    studentsComplete = NO;
    nameComplete = NO;
    
    if(!addedStudents)
        addedStudents = [[NSMutableArray alloc] initWithCapacity:0];
    
    courseSection = 0;
    studentsSection = 1;
    
	//self.editing=YES;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [super viewDidLoad];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [myTableView setEditing:editing animated:animated];
    [self.navigationItem setHidesBackButton:editing animated:animated];
    NSArray *updatedPaths = [NSArray arrayWithObjects:[NSIndexPath indexPathForRow:[addedStudents count] inSection:studentsSection],nil];

    if(editing)
        [myTableView insertRowsAtIndexPaths:updatedPaths withRowAnimation:UITableViewRowAnimationTop];
    else
        [myTableView deleteRowsAtIndexPaths:updatedPaths withRowAnimation:UITableViewRowAnimationTop];
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
    return 2;
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
    } else {
        if (self.editing) {
            return  [addedStudents count] + 1;
        } else {
            return [addedStudents count];
        }
    }
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
        
        if ([courseName isEqual:@"Course Name"])
            cell.textLabel.textColor = [UIColor grayColor];
        else
            cell.textLabel.textColor = [UIColor blackColor];
        
		cell.textLabel.text = courseName;
	} else if (indexPath.section == studentsSection && indexPath.row >= [addedStudents count]) {
        cell.textLabel.text = @"enroll students";
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        Student *s = [addedStudents objectAtIndex:indexPath.row];
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", s.firstName, s.lastName];
    }
    
	
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.editing) {
        if (indexPath.section == studentsSection && indexPath.row >= [addedStudents count]) {
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
    } else if (indexPath.section == studentsSection && indexPath.row >= [addedStudents count]) {
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
            
            if (![courseName isEqual:@"Course Name"])
                textController.myText = courseName;
            
            [self.navigationController pushViewController:textController animated:YES];
            [textController release];
            
        } else if (indexPath.section == studentsSection && indexPath.row >= [addedStudents count]) {
            
            EnrollStudentsViewController *enrollController = [[EnrollStudentsViewController alloc] 
                                                              initWithNibName:@"EnrollStudentsViewController" bundle:nil];
            enrollController.delegate = self;
            enrollController.initial = addedStudents;
            [self.navigationController pushViewController:enrollController animated:YES];
            [enrollController release];
        }
    } else {
    
        StudentViewController *anotherViewController = [[StudentViewController alloc] initWithNibName:@"StudentViewController" bundle:nil];
        Student *student = [addedStudents objectAtIndex:indexPath.row];
        anotherViewController.title = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
        anotherViewController.currentStudent = student;
        
        [self.navigationController pushViewController:anotherViewController animated:YES];
        [anotherViewController release];
        
    }
    
	
}

- (void)enrollStudentsViewController:(EnrollStudentsViewController *)enrollStudentsViewController

                        withStudents:(NSMutableArray *)enrolled {
    
    addedStudents = enrolled;
    [myTableView reloadData];
    
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
        courseName = text;
        [courseName retain];
        [self.navigationItem setTitle:courseName];
        [myTableView reloadData];
        nameComplete = YES;
        if(nameComplete && studentsComplete)
            self.navigationItem.rightBarButtonItem.enabled = YES;
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [aD managedObjectContext];
        
        Student *s = [addedStudents objectAtIndex:indexPath.row];
        
        [course removeStudentsObject:s];
        
        NSError *error;
        if (![context save:&error]) {
            // Handle the error.
        }
        
        [addedStudents removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


- (void)dealloc {
    [myTableView release];
    [super dealloc];
}


@end


