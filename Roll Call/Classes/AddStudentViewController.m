//
//  AddStudentViewController.m
//  Roll Call
//
//  Created by Weizhi Li on Mar24.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddStudentViewController.h"
#import "Student.h"
#import "AddStudentNameViewController.h"
#import "StudentsViewController.h"

@implementation AddStudentViewController

@synthesize student;
@synthesize aD;
@synthesize classes;
@synthesize photoButton;
@synthesize tableHeaderView;
@synthesize addNameButton;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

	aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context=[aD managedObjectContext];
	student = (Student *)[NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
	classes=[[NSMutableArray alloc] init];
	self.title = @"New Student";
	if (tableHeaderView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"AddStudentHeaderView" owner:self options:nil];
        self.tableView.tableHeaderView = tableHeaderView;
        self.tableView.allowsSelectionDuringEditing = YES;
	}
	self.editing=YES;
	self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
	self.navigationController.navigationBar.translucent=YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.tableView.tableHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	[super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
	if (student.lastName==nil&&student.firstName==nil) {
		[addNameButton setTitle:@"First Last" forState:UIControlStateNormal];
		[addNameButton setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
	}
	else {
		NSLog(@"show name!: %@ %@", student.firstName, student.lastName);
		NSString *fullname = [[NSString alloc] initWithFormat:@"%@ %@", student.firstName, student.lastName];
		[addNameButton setTitle:fullname forState:UIControlStateNormal];
	}
	if (student.thumbnailPhoto==nil) {
		[photoButton setImage:[UIImage imageNamed:@"addphoto.jpg"] forState:UIControlStateNormal];
	} else 
		[photoButton setImage:[UIImage imageNamed:@"addphoto.jpg"] forState:UIControlStateNormal];
	
	[self.tableView reloadData];
}

- (void)viewDidUnload {
    self.tableHeaderView = nil;
	self.photoButton = nil;
	[super viewDidUnload];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)save {
	NSManagedObjectContext *context=[aD managedObjectContext];
    
    if (student.lastName==nil || student.firstName==nil)
        [context deleteObject:student];
        
    NSError *error;
    if (![context save:&error]) {
        // Handle the error.
    }
    
	[self dismissModalViewControllerAnimated:YES];
}


- (void)cancel{
    NSManagedObjectContext *context=[aD managedObjectContext];
    [context deleteObject:student];
    NSError *error;
    
    if (![context save:&error]) {
        NSLog(@"I can't save the new student that I want to cancel");
    }
    
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)addName: (id)sender {
    AddStudentNameViewController *addNameView = [[AddStudentNameViewController alloc] initWithNibName:@"AddStudentNameViewController" bundle:nil];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addNameView];
	addNameView.student=student;
	[self presentModalViewController:navController animated:YES];
	[addNameView release];
	[navController release];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    
    [super setEditing:editing animated:animated];
	[self updatePhotoButton];
	[self.tableView beginUpdates];
    NSUInteger count = [classes count];
    NSArray *classesInsertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:count inSection:1]];
    
    if (editing) {
        [self.tableView insertRowsAtIndexPaths:classesInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];

	} else {
        [self.tableView deleteRowsAtIndexPaths:classesInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];

    }
    [self.tableView endUpdates];
	
	
}



#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section==0)
		return 3;
	NSInteger cout=[classes count];
	if (self.editing) {
		cout++;
	}
	return cout;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
	// For the Classes section, if necessary create a new cell and configure it with an additional label for the amount.

	if (indexPath.section == 1) {
        if (indexPath.row < [classes count]) {
            // If the row is within the range, then configure the cell to show the class name.
			static NSString *ClassesCellIdentifier = @"ClassesCell";
			cell = [tableView dequeueReusableCellWithIdentifier:ClassesCellIdentifier];
			if (cell == nil) {
				// Create a cell to display a class.
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ClassesCellIdentifier] autorelease];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
            //Class *class = [[aClass alloc] init];
			//class=[classes objectAtIndex:row];
            cell.textLabel.text = @"FIX ME";
        } else {
            // If the row is outside the range, it's the row that was added to allow insertion (see tableView:numberOfRowsInSection:) so give it an appropriate label.
			static NSString *AddClassCellIdentifier = @"AddClassCell";
			
			cell = [tableView dequeueReusableCellWithIdentifier:AddClassCellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddClassCellIdentifier] autorelease];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
            cell.textLabel.text = @"add new class";
			cell.textLabel.textColor=[UIColor grayColor];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }		
    } else {
		static NSString *MyIdentifier = @"GenericCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
		if (indexPath.row == 0) {
			if ([student phone]==nil) {
				cell.textLabel.text = @"add new phone";
				cell.textLabel.textColor=[UIColor grayColor];
			}
			else 
				cell.textLabel.text = student.phone;
		}
		else if (indexPath.row == 1) {
			if (student.email==nil) {
				cell.textLabel.textColor=[UIColor grayColor];
				cell.textLabel.text = @"add new email";
			}
			else
				cell.textLabel.text = student.email;
		}
		else if (indexPath.row == 2) {
			if (student.address==nil) {
				cell.textLabel.text = @"add new address";
				cell.textLabel.textColor=[UIColor grayColor];
			}
			else 
				cell.textLabel.text = student.address;
		}
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    return cell;
}
			

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
       
	if (indexPath.section==0) {
		switch (indexPath.row) {
			case 0:
				[self addPhone];
			case 1:
				[self addEmail];
			case 2:
				[self addAddress];				
			default:
				break;
		}
    }
	else if (indexPath.section==1)
		if (indexPath.row > [classes count]) {
			[self addClass];
		}
}
 */


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
	if (indexPath.section == 1) {
        // If this is the last item, it's the insertion row.
        if (indexPath.row == [classes count]) {
            style = UITableViewCellEditingStyleInsert;
        }
        else {
            style = UITableViewCellEditingStyleDelete;
        }
    }
    
    return style;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Only allow deletion, and only in the classes section
    if ((editingStyle == UITableViewCellEditingStyleDelete) && (indexPath.section == 1)) {
        // Remove the corresponding class object from the list and delete the appropriate table view cell.
        [classes removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}


#pragma mark -
#pragma mark Moving rows

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL canMove = NO;
    // Moves are only allowed within the classes section.  Within the classes section, the last row (Add Class) cannot be moved.
    if (indexPath.section == 1) {
        canMove = indexPath.row != [classes count];
    }
    return canMove;
}


- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    NSIndexPath *target = proposedDestinationIndexPath;
    
    /*
     Moves are only allowed within the classes section, so make sure the destination is in the classes section.
     If the destination is in the classes section, make sure that it's not the Add Class row -- if it is, retarget for the penultimate row.
     */
	NSUInteger proposedSection = proposedDestinationIndexPath.section;
	
    if (proposedSection < 1) {
        target = [NSIndexPath indexPathForRow:0 inSection:1];
    } else {
        NSUInteger classesCount_1 = [classes count] - 1;
        if (proposedDestinationIndexPath.row > classesCount_1) {
            target = [NSIndexPath indexPathForRow:classesCount_1 inSection:1];
        }
    }
	
    return target;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	
	/*
	 Update the classes array in response to the move.
	 Update the display order indexes within the range of the move.
	 */
//    aClass *class = [classes objectAtIndex:fromIndexPath.row];
//    [classes removeObjectAtIndex:fromIndexPath.row];
//    [classes insertObject:class atIndex:toIndexPath.row];
//	
//	NSInteger start = fromIndexPath.row;
//	if (toIndexPath.row < start) {
//		start = toIndexPath.row;
//	}
//	NSInteger end = toIndexPath.row;
//	if (fromIndexPath.row > end) {
//		end = fromIndexPath.row;
//	}
//	for (NSInteger i = start; i <= end; i++) {
//		class = [classes objectAtIndex:i];
//	}
}


#pragma mark -
#pragma mark Photo

- (IBAction)photoTapped {
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
	[self presentModalViewController:imagePicker animated:YES];
	[imagePicker release];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)selectedImage editingInfo:(NSDictionary *)editingInfo {
	
	// Create a thumbnail version of the image
	CGSize size = selectedImage.size;
	CGFloat ratio = 0;
	if (size.width > size.height) {
		ratio = 44.0 / size.width;
	} else {
		ratio = 44.0 / size.height;
	}
	CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
	
	UIGraphicsBeginImageContext(rect.size);
	[selectedImage drawInRect:rect];
	//student.thumbnailPhoto = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    [self dismissModalViewControllerAnimated:YES];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}


- (void)updatePhotoButton {
	if (student.thumbnailPhoto != nil) {
		photoButton.highlighted = TRUE;
	} else {
		photoButton.enabled = TRUE;
		[photoButton setImage:[UIImage imageNamed:@"addphoto.jpg"] forState:UIControlStateNormal];
		[photoButton setImage:nil forState:UIControlStateNormal];
	}
}


- (void)dealloc {
	[classes release];
    [super dealloc];    
}


@end
