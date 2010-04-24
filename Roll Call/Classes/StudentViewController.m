//
//  StudentViewController.m
//  Roll Call
//
//  Created by Weizhi Li on Mar22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StudentViewController.h"
#import "StudentsViewController.h"
#import "Student.h"
#import "AddStudentNameViewController.h"
#import "AddAddressViewController.h"
#import "AddEmailViewController.h"
#import "AddPhoneViewController.h"
#import "AddCourseViewController.h"
#import "Course.h"
#import "Address.h"
#import "Presence.h"
#import "Status.h"
#import "AttendanceTableViewController.h"
#import "KalViewDataSource.h"
#import "GraphController.h"

@implementation StudentViewController

@synthesize aD;
@synthesize currentStudent;
@synthesize photoButton;
@synthesize tableHeaderView;
@synthesize addNameButton;
@synthesize name;
@synthesize calendar;
@synthesize tvCell;
@synthesize presences;
@synthesize tableCell;
@synthesize cellLabel;
@synthesize cellImage;
@synthesize cB;
@synthesize dsCell;


- (void)viewDidLoad {
    
    [self setTitle:@"Student"];
	presences=nil;
	if (currentStudent.presences!=nil)
		presences= [[NSMutableArray alloc] initWithArray:[currentStudent.presences allObjects]];
    aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (tableHeaderView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"StudentHeaderView" owner:self options:nil];
        self.tableView.tableHeaderView = tableHeaderView;
        self.tableView.allowsSelectionDuringEditing = YES;
	}
	addNameButton.enabled=FALSE;
	//self.navigationController.navigationBar.barStyle=UIBarStyleBlackTranslucent;
	self.tableView.tableHeaderView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
	[self.tableView reloadData];
	[super viewDidLoad];
}



- (void)viewWillAppear:(BOOL)animated {
	
    [super viewWillAppear:animated];
	if (currentStudent==nil) {
		name.text=@"First Last";
		name.font=[UIFont boldSystemFontOfSize:20];
	} else {
		if (currentStudent.lastName==nil&&currentStudent.firstName==nil) {
			name.text=@"First Last";
			name.font=[UIFont boldSystemFontOfSize:20];
		}
		else {
			NSString *fullname = [[NSString alloc] initWithFormat:@"%@ %@", currentStudent.firstName, currentStudent.lastName];
			name.text=fullname;
			name.textColor=[UIColor blackColor];
			name.font=[UIFont boldSystemFontOfSize:20];
		}
		if (currentStudent.thumbnailPhoto==nil) {
			[photoButton setImage:[UIImage imageNamed:@"deafultphoto.JPG"] forState:UIControlStateNormal];
		} else                                                 
			[photoButton setImage:currentStudent.thumbnailPhoto  forState:UIControlStateNormal];
		
		aC=0;
		eC=0;
		tC=0;
		presences=nil;
		if (currentStudent.presences!=nil)
			presences= [[NSMutableArray alloc] initWithArray:[currentStudent.presences allObjects]];
		for (Presence *presence in presences) {
			if ([presence.status.letter isEqualToString:@"A"])
				aC++;
			if ([presence.status.letter isEqualToString:@"E"])
				eC++;
			if ([presence.status.letter isEqualToString:@"T"])
				tC++;		
		}
	}
	[self.tableView reloadData];
}

- (void)viewDidUnload {
    self.tableHeaderView = nil;
	self.photoButton = nil;
	[super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


#pragma mark -
#pragma mark Change view methods

- (IBAction)addName: (id)sender {
	if (self.editing) {
		AddStudentNameViewController *addNameView = [[AddStudentNameViewController alloc] initWithNibName:@"AddStudentNameViewController" bundle:nil];
		addNameView.student=currentStudent;
		[self.navigationController pushViewController:addNameView animated:YES];
		[addNameView release];
	}
}

- (void) addPhone {
	AddPhoneViewController *addPhoneView = [[AddPhoneViewController alloc] initWithNibName:@"AddPhoneViewController" bundle:nil];
	addPhoneView.student=currentStudent;
	[self.navigationController pushViewController:addPhoneView animated:YES];
	[addPhoneView release];
}

- (void) addEmail{
	AddEmailViewController *addEmailView = [[AddEmailViewController alloc] initWithNibName:@"AddEmailViewController" bundle:nil];
	addEmailView.student=currentStudent;
	[self.navigationController pushViewController:addEmailView animated:YES];
	[addEmailView release];
}

- (void) addAddress{
	AddAddressViewController *addAddressView = [[AddAddressViewController alloc] initWithNibName:@"AddAddressViewController" bundle:nil];
	addAddressView.student=currentStudent;
	[self.navigationController pushViewController:addAddressView animated:YES];
	[addAddressView release];
}

- (void) addCourse{
	AddCourseViewController *addCourseView = [[AddCourseViewController alloc] initWithNibName:@"AddCourseViewController" bundle:nil];
	addCourseView.student=currentStudent;
	[self.navigationController pushViewController:addCourseView animated:YES];
	[addCourseView release];
}

- (IBAction) showKal {
	calendar = [[KalViewController alloc] init];
	KalViewDataSource *data= [[KalViewDataSource alloc] init];
	id<KalDataSource> source = data;
	id<UITableViewDelegate> delegate=data;
	data.statuses=presences;
	data.kal=calendar;
	data.name=[[NSString alloc] initWithFormat:@"%@ %@'s Attendance",currentStudent.firstName, currentStudent.lastName];
	[calendar setDataSource:source];
	[calendar setDelegate:delegate];
	calendar.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Today" style:UIBarButtonItemStyleBordered target:self action:@selector(showAndSelectToday)] autorelease];
	calendar.title=currentStudent.firstName;
	[self.navigationController pushViewController:calendar animated:YES];
}

- (IBAction) showNotes {
	AttendanceTableViewController *aView = [[AttendanceTableViewController alloc] initWithNibName:@"AttendanceTableViewController" bundle:nil];
	aView.type=3;
	aView.student=currentStudent;
	[self.navigationController pushViewController:aView animated:YES];
	[aView release];
}

- (IBAction)deleteStudent
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
			NSMutableArray *courses=nil;
			if (currentStudent.courses!=nil)
				courses = [[NSMutableArray alloc] initWithArray:[currentStudent.courses allObjects]];
			for (Course *course in courses)
				[course removeStudentsObject:currentStudent];
			[currentStudent removeCourses: currentStudent.courses];
			[context deleteObject:currentStudent]; 
			UIViewController *targetViewController = [[StudentsViewController alloc] initWithNibName:@"StudentsViewController" bundle:[NSBundle mainBundle] ];
			
			NSError *error;
			if (![context save:&error]) {
				// Handle the error.
			}
			[self.navigationController pushViewController:targetViewController animated:NO];	
			
			break;
		}
	}
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSMutableArray *courses=nil;
	if (currentStudent.courses!=nil)
		courses = [[NSMutableArray alloc] initWithArray:[currentStudent.courses allObjects]];
	if (section==0){
		NSInteger cout=[courses count];
		if (self.editing) 
			cout++;
		return cout;
	}
	else if (section==3) 
		return 5;
	else if (section==1)
		return 2;   //not sure//not sure//not sure//not sure//not sure
	else if (section==2) {
		return 1;  //not sure//not sure//not sure//not sure//not sure
	} else if (section==4) {
		if (self.editing) 
			return 1;
	}
	return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableArray *courses=nil;
	if (currentStudent.courses!=nil)
		courses = [[NSMutableArray alloc] initWithArray:[currentStudent.courses allObjects]];
	UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row < [courses count]) {
            // If the row is within the range, then configure the cell to show the class name.
			static NSString *ClassesCellIdentifier = @"CoursesCell";
			cell = [tableView dequeueReusableCellWithIdentifier:ClassesCellIdentifier];
			if (cell == nil) {
				// Create a cell to display a class.
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ClassesCellIdentifier] autorelease];
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			Course *course = [courses objectAtIndex:indexPath.row];
			cell.textLabel.text = [NSString stringWithFormat:@"%@", course.name];
			cell.editingAccessoryType = UITableViewCellAccessoryNone;
        } else {
            // If the row is outside the range, it's the row that was added to allow insertion (see tableView:numberOfRowsInSection:) so give it an appropriate label.
			static NSString *AddClassCellIdentifier = @"AddCourseCell";
			cell = [tableView dequeueReusableCellWithIdentifier:AddClassCellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddClassCellIdentifier] autorelease];
				cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
			}
            cell.textLabel.text = @"add new course";
			cell.textLabel.textColor=[UIColor grayColor];
			cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
		
	} else if (indexPath.section == 3) {
		static NSString *ContactCellIdentifier = @"ContactCell";
        cell = [tableView dequeueReusableCellWithIdentifier:ContactCellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ContactCellIdentifier] autorelease];
		}
		cell.textLabel.textAlignment=UITextAlignmentLeft;
		cell.detailTextLabel.minimumFontSize=20;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (self.editing) {
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		}
		cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		
		if (indexPath.row == 0) {
			cell.textLabel.text=@"Phone";
			if (currentStudent.phone!=nil) {
				cell.detailTextLabel.text =currentStudent.phone;
			}
		}
		else if (indexPath.row == 1) {
			cell.textLabel.text = @"Email";
			if (currentStudent.email!=nil) {                            
				cell.detailTextLabel.text =currentStudent.email;
			}
		}
		else if (indexPath.row == 2) {
			cell.textLabel.text = @"Address";
		}
		else if (indexPath.row == 3) {
			cell.editingAccessoryType = UITableViewCellAccessoryNone;
			NSString *address1=@"";
			if (currentStudent.address.apt!=nil&&currentStudent.address.street==nil) {
				address1 = [[NSString alloc] initWithFormat:@"%@", currentStudent.address.apt];
			}
			else if (currentStudent.address.apt==nil&&currentStudent.address.street!=nil){
				address1 = [[NSString alloc] initWithFormat:@"%@", currentStudent.address.street];
			}
			else if (currentStudent.address.apt!=nil&&currentStudent.address.street!=nil) {
				address1 = [[NSString alloc] initWithFormat:@" %@     %@", currentStudent.address.apt, currentStudent.address.street];
			}
			cell.detailTextLabel.text = address1;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
		} else if (indexPath.row == 4) {
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			cell.editingAccessoryType = UITableViewCellAccessoryNone;
			NSString *address2=@"";
			NSString *city=currentStudent.address.city;
			NSString *zip=currentStudent.address.zip;
			NSString *state=[[NSString alloc] initWithFormat:@"%@,",currentStudent.address.state];
			if (zip==nil) {
				zip=@"";	
			}
			if (currentStudent.address.state==nil) {
				state=@"";
			}
			if (city==nil) {
				city=@"";
			}
			address2 = [[NSString alloc] initWithFormat:@" %@     %@  %@", city, state, zip];
			[state release];
			cell.detailTextLabel.text = address2;
		}
	} else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			static NSString *CellIdentifier = @"AttendanceCell";
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				[[NSBundle mainBundle] loadNibNamed:@"AttendanceCell" owner:self options:nil];
				cell = tvCell;
				self.tvCell = nil;
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			}
			[aB setTitle:@"A" forState: UIControlStateNormal];
			[aB setBackgroundImage:[UIImage imageNamed:@"button_red.png"] forState:UIControlStateNormal];
			aL.text=[[NSString alloc] initWithFormat:@"%d", aC];
			[tB setTitle:@"T" forState: UIControlStateNormal];
			[tB setBackgroundImage:[UIImage imageNamed:@"button_yellow.png"] forState:UIControlStateNormal];
			tL.text=[[NSString alloc] initWithFormat:@"%d", tC];
			[eB setTitle:@"E" forState: UIControlStateNormal];
			[eB setBackgroundImage:[UIImage imageNamed:@"button_blue.png"] forState:UIControlStateNormal];
			eL.text=[[NSString alloc] initWithFormat:@"%d", eC];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			return cell;
		}
		else if (indexPath.row == 1) {
			static NSString *CellIdentifier = @"OverViewCell";
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				[[NSBundle mainBundle] loadNibNamed:@"ChatTableCell" owner:self options:nil];
				cell = tableCell;
				self.tableCell = nil;
				cellLabel.text=@"Monthly Overview";
				cB.hidden=YES;
				cellImage.hidden=NO;
				[cellImage setImage:[UIImage imageNamed:@"icon_chart_lg.png"]];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			return cell;
		}
	} else if (indexPath.section == 2) {
		static NSString *CellIdentifier = @"OverViewCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"ChatTableCell" owner:self options:nil];
			cell = tableCell;
			self.tableCell = nil;
			cellLabel.text=@"Notes";
			cB.hidden=NO;
			cellImage.hidden=YES;
			[cB setBackgroundImage:[UIImage imageNamed:@"note_outline.png"] forState:UIControlStateNormal];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		return cell;
	} else if (indexPath.section == 4&&self.editing) {
		static NSString *DeleteCellIdentifier = @"DeleteCell";
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DeleteCellIdentifier];
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"DeleteTableCell" owner:self options:nil];
			cell = dsCell;
			self.dsCell = nil;
		}
		cell.backgroundColor = [UIColor groupTableViewBackgroundColor];
		return cell;
	}
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section==1||indexPath.section==2)
		return 50;
	if (indexPath.section==4)
		return 29;
	return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableArray *courses=nil;
	if (currentStudent.courses!=nil)
		courses = [[NSMutableArray alloc] initWithArray:[currentStudent.courses allObjects]];
	if (indexPath.section==0) {
		if (indexPath.row == [courses count]) {
			[self addCourse];
		}
	} else if (indexPath.section==1) {
		if (indexPath.row==1) {
			GraphController *vc = [[GraphController alloc] init];
			vc.presences=presences;
			vc.lastName=currentStudent.lastName;
			vc.firstName=currentStudent.firstName;
			[vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
			[self presentModalViewController:vc animated:YES];
			[vc release];	
		}
		if (indexPath.row==0) {
			[self showKal];
		}
	} else if (indexPath.section==2) {
		[self showNotes];
	} if (self.editing&&(indexPath.section == 3)&&(indexPath.row == 0)) {
		[self addPhone];
	} if (self.editing&&(indexPath.section == 3)&&(indexPath.row == 1)) {
		[self addEmail];
	} if (self.editing&&(indexPath.section == 3)&&(indexPath.row == 2)) {
		[self addAddress];
	} if (indexPath.section == 4) {
		[self deleteStudent];
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if  (section==0)
		return @"Course(s)";
	if  (section==3)
		return @"Contact Info";
	if  (section==1)
		return @"Attendance";
	return @"";
}


- (void)showAndSelectToday
{
	[calendar showAndSelectDate:[NSDate date]];
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	NSMutableArray *courses=nil;
	if (currentStudent.courses!=nil)
		courses = [[NSMutableArray alloc] initWithArray:[currentStudent.courses allObjects]];
    if ((editingStyle == UITableViewCellEditingStyleDelete) && (indexPath.section == 0)){
        // Delete the row from the data source
		Course *course = [courses objectAtIndex:indexPath.row];
		[currentStudent removeCoursesObject:course];
		[course removeStudentsObject: currentStudent];
		[courses removeObjectAtIndex:indexPath.row];		
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
	}
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section==0||indexPath.section==3)
		return TRUE;
	return FALSE;
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	
	NSMutableArray *courses=nil;
	if (currentStudent.courses!=nil)
		courses = [[NSMutableArray alloc] initWithArray:[currentStudent.courses allObjects]];
    [super setEditing:editing animated:animated];
	
	[self.tableView beginUpdates];
	NSUInteger count = [courses count];
    NSArray *classesInsertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:count inSection:0]];
	NSArray *deleteInsertIndexPath = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:4]];
	[self.navigationItem setHidesBackButton:editing animated:animated];
    if (editing) {
		[self.navigationItem setHidesBackButton:editing animated:animated];
        [self.tableView insertRowsAtIndexPaths:classesInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
		[self updatePhotoButton];
		[self.tableView insertRowsAtIndexPaths:deleteInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
		addNameButton.enabled=TRUE;
	} else {
		addNameButton.enabled=FALSE;
		if (currentStudent.thumbnailPhoto==nil) {
			[photoButton setImage:[UIImage imageNamed:@"deafultphoto.JPG"] forState:UIControlStateNormal];
		} else                                           
			[photoButton setImage:currentStudent.thumbnailPhoto  forState:UIControlStateNormal];
        [self.tableView deleteRowsAtIndexPaths:classesInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];
		[self.tableView deleteRowsAtIndexPaths:deleteInsertIndexPath withRowAnimation:UITableViewRowAnimationTop];	
		NSManagedObjectContext *context=[aD managedObjectContext];
		NSError *error;
		if (![context save:&error]) {
			// Handle the error.
		}
	}
    [self.tableView endUpdates];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCellEditingStyle style = UITableViewCellEditingStyleNone;
	NSMutableArray *courses=nil;
	if (currentStudent.courses!=nil)
		courses = [[NSMutableArray alloc] initWithArray:[currentStudent.courses allObjects]];
	if (indexPath.section == 0) {
        // If this is the last item, it's the insertion row.
        if (indexPath.row == [courses count]) {
            style = UITableViewCellEditingStyleInsert;
        }
        else {
            style = UITableViewCellEditingStyleDelete;
        }		
    } else 
		style = UITableViewCellEditingStyleNone;
    return style;
}


- (IBAction)photoTapped {
	if (self.editing) {
		UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
		imagePicker.delegate = self;
		[self presentModalViewController:imagePicker animated:YES];
		[imagePicker release];
	}
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
	currentStudent.thumbnailPhoto = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    [self dismissModalViewControllerAnimated:YES];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissModalViewControllerAnimated:YES];
}


- (void)updatePhotoButton {
	photoButton.enabled = TRUE;
	[photoButton setImage:[UIImage imageNamed:@"addphoto.jpg"] forState:UIControlStateNormal];
}

- (void)dealloc {
	[currentStudent release];
	[photoButton release];
	[tableHeaderView release];
	[addNameButton release];
	[name release];
	[calendar release];
	[presences release];
	[cellImage release];
	[tableCell release];
	[cellLabel release];
	[dsCell release];
	[tvCell release];
	[super dealloc];
}

@end

