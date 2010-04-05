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
#import "AddAddressViewController.h"
#import "AddEmailViewController.h"
#import "AddPhoneViewController.h"
#import "AddCourseViewController.h"
#import "Course.h"
#import "Student.h"
#import "Address.h"

@implementation AddStudentViewController

@synthesize student;
@synthesize aD;
@synthesize courses;
@synthesize photoButton;
@synthesize tableHeaderView;
@synthesize addNameButton;
@synthesize name;
@synthesize add;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context=[aD managedObjectContext];
	student = (Student *)[NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
	student.address=(Address *)[NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:context];
	courses = [[NSMutableArray alloc] initWithArray:[student.courses allObjects]];
	self.title = @"New Student";
	if (tableHeaderView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"AddStudentHeaderView" owner:self options:nil];
        self.tableView.tableHeaderView = tableHeaderView;
        self.tableView.allowsSelectionDuringEditing = YES;
	}
	self.editing=YES;
	//self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
	self.navigationItem.rightBarButtonItem.enabled=NO;
	self.tableView.tableHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	[self.tableView reloadData];
	[super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated {
		
	[super viewWillAppear:animated];
	courses=nil;
	if (student.courses!=nil)
		courses = [[NSMutableArray alloc] initWithArray:[student.courses allObjects]];
	
	if (student.lastName==nil&&student.firstName==nil) {
		name.text=@"First Last";
		name.font=[UIFont boldSystemFontOfSize:20];
	}
	else {
		self.navigationItem.rightBarButtonItem.enabled=YES;
		NSLog(@"show name!: %@ %@", student.firstName, student.lastName);
		NSString *fullname = [[NSString alloc] initWithFormat:@"%@ %@", student.firstName, student.lastName];
		name.text=fullname;
		name.textColor=[UIColor blackColor];
		name.font=[UIFont boldSystemFontOfSize:20];
 	}
	if (student.thumbnailPhoto==nil) {
		[photoButton setImage:[UIImage imageNamed:@"addphoto.jpg"] forState:UIControlStateNormal];
	} else                                 
		[photoButton setImage:student.thumbnailPhoto forState:UIControlStateNormal]; 
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


#pragma mark -
#pragma mark save & cancel

- (void)save {
	
	NSManagedObjectContext *context=[aD managedObjectContext];
	NSError *error;
	if (![context save:&error]) {
			// Handle the error.
	}
	[self dismissModalViewControllerAnimated:YES];
}


- (void)cancel{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Change view methods

- (IBAction)addName: (id)sender {
    AddStudentNameViewController *addNameView = [[AddStudentNameViewController alloc] initWithNibName:@"AddStudentNameViewController" bundle:nil];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addNameView];
	addNameView.student=student;
	[self presentModalViewController:navController animated:YES];
	[addNameView release];
	[navController release];
}

- (void) addPhone {
	AddPhoneViewController *addPhoneView = [[AddPhoneViewController alloc] initWithNibName:@"AddPhoneViewController" bundle:nil];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addPhoneView];
	addPhoneView.student=student;
	[self presentModalViewController:navController animated:YES];
	[addPhoneView release];
	[navController release];
}

- (void) addEmail{
	AddEmailViewController *addEmailView = [[AddEmailViewController alloc] initWithNibName:@"AddEmailViewController" bundle:nil];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addEmailView];
	addEmailView.student=student;
	[self presentModalViewController:navController animated:YES];
	[addEmailView release];
	[navController release];
}

- (void) addAddress{
	AddAddressViewController *addAddressView = [[AddAddressViewController alloc] initWithNibName:@"AddAddressViewController" bundle:nil];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addAddressView];
	addAddressView.student=student;
	[self presentModalViewController:navController animated:YES];
	[addAddressView release];
	[navController release];
}

- (void) addCourse{
	AddCourseViewController *addCourseView = [[AddCourseViewController alloc] initWithNibName:@"AddCourseViewController" bundle:nil];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addCourseView];
	addCourseView.student=student;
	[self presentModalViewController:navController animated:YES];
	[addCourseView release];
	[navController release];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {

    [super setEditing:editing animated:animated];
	[self updatePhotoButton];
	[self.tableView beginUpdates];
    NSUInteger count = [courses count];
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
		return 4;
	NSInteger cout=[courses count];
	if (self.editing) {
		cout++;
	}
	return cout;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	// For the Classes section, if necessary create a new cell and configure it with an additional label for the amount.
	if (indexPath.section == 1) {
        if (indexPath.row < [courses count]) {
            // If the row is within the range, then configure the cell to show the class name.
			static NSString *ClassesCellIdentifier = @"ClassesCell";
			cell = [tableView dequeueReusableCellWithIdentifier:ClassesCellIdentifier];
			if (cell == nil) {
				// Create a cell to display a class.
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ClassesCellIdentifier] autorelease];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			Course *course = [courses objectAtIndex:indexPath.row];
			cell.textLabel.text = [NSString stringWithFormat:@"%@", course.name];
        } else {
            // If the row is outside the range, it's the row that was added to allow insertion (see tableView:numberOfRowsInSection:) so give it an appropriate label.
			static NSString *AddClassCellIdentifier = @"AddClassCell";
			
			cell = [tableView dequeueReusableCellWithIdentifier:AddClassCellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddClassCellIdentifier] autorelease];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
            cell.textLabel.text = @"add new course";
			cell.textLabel.textColor=[UIColor grayColor];
			cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }		
    } else {
		static NSString *MyIdentifier = @"GenericCell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:MyIdentifier] autorelease];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
		cell.textLabel.textAlignment=UITextAlignmentLeft;
		cell.detailTextLabel.minimumFontSize=20; 
		if (indexPath.row == 0) {
			if ([student phone]==nil) {
				cell.textLabel.text = @"Phone";
				cell.detailTextLabel.text = @"     add new";
				cell.detailTextLabel.textColor=[UIColor grayColor];
			}
			else {
				cell.textLabel.text = @"Phone";
				cell.detailTextLabel.textColor=[UIColor blackColor];
				cell.detailTextLabel.text =student.phone;
			}
		}
		else if (indexPath.row == 1) {
			if (student.email==nil) {
				cell.textLabel.text = @"Email";
				cell.detailTextLabel.text = @"     add new";
				cell.detailTextLabel.textColor=[UIColor grayColor];
			}
			else {
				cell.textLabel.text = @"Email";
				cell.detailTextLabel.textColor=[UIColor blackColor];
				cell.detailTextLabel.text = student.email;
			}
		}
		else if (indexPath.row == 2) {
			if (student.address.apt==nil) {
				cell.textLabel.text = @"Address";
				cell.detailTextLabel.text = @"     add new";
				cell.detailTextLabel.textColor=[UIColor grayColor];
			}
			else {
				NSString *address = [[NSString alloc] initWithFormat:@"%@  %@", student.address.apt, student.address.street];
				cell.detailTextLabel.text = address;
				cell.detailTextLabel.textColor=[UIColor blackColor];
				cell.textLabel.text = @"Address";
			}
		} else {
			if (student.address.zip==nil) {
				cell.detailTextLabel.text = @"";
				cell.detailTextLabel.textColor=[UIColor grayColor];
			}
			else {
				NSString *address = [[NSString alloc] initWithFormat:@"%@  %@, %@", student.address.city, student.address.state, student.address.zip];
				cell.detailTextLabel.text = address;
				cell.detailTextLabel.textColor=[UIColor blackColor];
				cell.textLabel.text = @"Address";
			}
			
		}

		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
    return cell;
}
			
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
       
	if (indexPath.section==0) {
		if (indexPath.row==0) {
				[self addPhone];
		}
		else if (indexPath.row==1) {
			[self addEmail];
		}
		else if (indexPath.row==2) {
			[self addAddress];
		}
	}
	else if (indexPath.section==1) {
		if (indexPath.row == [courses count]) {
			[self addCourse];
		}
	}

}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if  (section==0)
		return @"Contact Info";
	if  (section==1)
		return @"Course(s)";
	return @"";
}

#pragma mark -
#pragma mark editing Table view methods

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
	if (indexPath.section == 1) {
        // If this is the last item, it's the insertion row.
        if (indexPath.row == [courses count]) {
            style = UITableViewCellEditingStyleInsert;
        }
        else {
            style = UITableViewCellEditingStyleDelete;
        }		
    } else if (indexPath.section == 0) {
		if (indexPath.row == 0&&student.phone==nil) {
			style = UITableViewCellEditingStyleInsert;
		}
		if (indexPath.row == 1&&student.email==nil) {
			style = UITableViewCellEditingStyleInsert;
		}
		if (indexPath.row == 2&&student.address.apt==nil) {
			style = UITableViewCellEditingStyleInsert;
		}
	}
    return style;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Only allow deletion, and only in the classes section
    if ((editingStyle == UITableViewCellEditingStyleDelete) && (indexPath.section == 1)) {
        // Remove the corresponding class object from the list and delete the appropriate table view cell.
		Course *course = [courses objectAtIndex:indexPath.row];
		[student removeCoursesObject:course];
		[course removeStudentsObject: student];
		[courses removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

#pragma mark -
#pragma mark Moving rows

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL canMove = NO;
    // Moves are only allowed within the classes section.  Within the classes section, the last row (Add Class) cannot be moved.
    if (indexPath.section == 1) {
        canMove = indexPath.row != [courses count];
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
        NSUInteger classesCount_1 = [courses count] - 1;
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
	Course *class = [courses objectAtIndex:fromIndexPath.row];
    [courses removeObjectAtIndex:fromIndexPath.row];
    [courses insertObject:class atIndex:toIndexPath.row];
	
	NSInteger start = fromIndexPath.row;
	if (toIndexPath.row < start) {
		start = toIndexPath.row;
	}
	NSInteger end = toIndexPath.row;
	if (fromIndexPath.row > end) {
		end = fromIndexPath.row;
	}
	for (NSInteger i = start; i <= end; i++) {
		class = [courses objectAtIndex:i];
	}
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
	student.thumbnailPhoto = UIGraphicsGetImageFromCurrentImageContext();
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
	[student release];
	[courses release];
	[photoButton release];
	[tableHeaderView release];
	[addNameButton release];
	[name release];
    [super dealloc];    
}


@end
