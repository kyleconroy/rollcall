//
//  AddRollSheetViewController.m
//  Roll Call
//
//  Created by Kyle Conroy on Apr5.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddRollSheetViewController.h"
#import "EnrollStudentsViewController.h"
#import "Student.h"

@implementation AddRollSheetViewController

@synthesize delegate;
@synthesize aD;
@synthesize addedStudents;
@synthesize myTableView;
@synthesize courseName;
@synthesize studentsSection;
@synthesize courseSection;
@synthesize studentsComplete;
@synthesize nameComplete;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (IBAction) enrollStudentsInClass: (id) sender {
    
}


- (void)viewDidLoad {
    self.title = @"New Class";
    
    aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    studentsComplete = NO;
    nameComplete = NO;
    
    addedStudents = [[NSMutableArray alloc] initWithCapacity:0];
    courseSection = 0;
    studentsSection = 1;
    
    [super setEditing:YES animated:NO];
    [myTableView setEditing:YES animated:NO];
    
	//self.editing=YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)save {
	
    NSManagedObjectContext *context = [aD managedObjectContext];
    Course *course = (Course *)[NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
    [course setName:courseName];
    
    for (Student *s in addedStudents){
       [s addCoursesObject:course]; 
    }

    NSError *error;
    if (![context save:&error]) {
        // Handle the error.
    }

    [delegate addRollSheetViewController:self withCourse:course];
}


- (void)cancel{
	[delegate addRollSheetViewController:self withCourse:nil];
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
    return 2;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == courseSection) {
        return 1;
    } else {
        return [addedStudents count] + 1;
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
        
        if ([courseName isEqual:@"Course Name"])
            cell.textLabel.textColor = [UIColor grayColor];
        else
            cell.textLabel.textColor = [UIColor blackColor];
        
		cell.textLabel.text = courseName;
	} else if (indexPath.section == studentsSection && indexPath.row >= [addedStudents count]) {
        cell.textLabel.text = @"enroll students";
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
    } else {
        Student *s = [addedStudents objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", s.firstName, s.lastName];
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
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
        return indexPath;
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
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
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

	
}

- (void)enrollStudentsViewController:(EnrollStudentsViewController *)enrollStudentsViewController

                        withStudents:(NSMutableArray *)enrolled {
    
    if (enrolled) {
        addedStudents = enrolled;
        studentsComplete = YES;
        [myTableView reloadData];
        if(nameComplete && studentsComplete)
            self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editTextFieldViewController:(EditTextFieldViewController *)editTextFieldViewController

                           withType: (NSNumber*)type didChangeText:(NSString *)text {
    
    if(text){
        courseName = text;
        [courseName retain];
        [myTableView reloadData];
        nameComplete = YES;
        if(nameComplete && studentsComplete)
            self.navigationItem.rightBarButtonItem.enabled = YES;
            
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
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

