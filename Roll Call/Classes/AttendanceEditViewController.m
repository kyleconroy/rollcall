//
//  OverviewController.m
//  Created by Devin Ross on 7/13/09.
//
/*
 
 tapku.com || http://github.com/tapku/tapkulibrary/tree/master
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 
 */

#import "AttendanceEditViewController.h"
#import "Presence.h"
#import "Course.h"
#import "Status.h"
#import "RollSheetAddNoteController.h"
#import "Roll_CallAppDelegate.h"
#import "NoteViewController.h"

@implementation AttendanceEditViewController

@synthesize presence, name;
@synthesize lastIndexPath;
@synthesize initialSelection;
@synthesize nCell, notes;
@synthesize statusArray;

- (void)viewDidLoad {
    [super viewDidLoad];
	Roll_CallAppDelegate *aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
    statusArray = [aD getAllStatuses];
    [statusArray retain];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"EEEE ha"];
	NSString *theDate = [dateFormat stringFromDate:presence.date];
	self.header.subtitle.text=[NSString stringWithFormat:@"%@  %@", presence.course.name, theDate];
	[dateFormat release];
	self.header.title.text=name;
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                   initWithTitle:NSLocalizedString(@"Save", @"Save - for button to save changes")
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButton;
    [saveButton release];
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:NSLocalizedString(@"Back", @"Cancel - for button to cancel changes")
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];	
	self.navigationItem.rightBarButtonItem.enabled=NO;
}

- (void)viewWillAppear:(BOOL)animated {
	initialSelection=-1;
	//find initialSelection
	self.header.indicator.text = presence.status.text;
	
	if ([presence.status.imageName isEqualToString:@"button_blue.png"])
		self.header.indicator.color = button_blue;
	if ([presence.status.imageName isEqualToString:@"button_gray.png"])
		self.header.indicator.color = button_gray;
	if ([presence.status.imageName isEqualToString:@"button_green.png"])
		self.header.indicator.color = button_green;
	if ([presence.status.imageName isEqualToString:@"button_orange.png"])
		self.header.indicator.color = button_orange;
	if ([presence.status.imageName isEqualToString:@"button_purple.png"])
		self.header.indicator.color = button_purple;
	if ([presence.status.imageName isEqualToString:@"button_red.png"])
		self.header.indicator.color = button_red;
	if ([presence.status.imageName isEqualToString:@"button_white.png"])
		self.header.indicator.color = button_white;
	if ([presence.status.imageName isEqualToString:@"button_yellow.png"])
		self.header.indicator.color = button_yellow;
	
	int i=0;
	for (Status *s in statusArray) {
		if ([presence.status.letter isEqualToString:s.letter]) {
			initialSelection=i;
			break;
		}
		i++;					  
	}
	if (initialSelection !=-1)
    {
        NSUInteger newIndex[] = {0, initialSelection};
        NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
        self.lastIndexPath = newPath;
        [newPath release];
    }
	[tableView reloadData];
	notes.text=presence.note;
}

-(IBAction)cancel
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) save
{
	Roll_CallAppDelegate *aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
	int index=[lastIndexPath row];
	presence.status=[statusArray objectAtIndex: index];
	NSError *error;
	if (![[aD managedObjectContext] save:&error]) {
		// Handle the error.
	}
	[self.navigationController popViewControllerAnimated:YES];	
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0)
		return [statusArray count];
	return 1;
}
- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 0) {
		 static NSString *CellIdentifier = @"Cell";
		 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		 if (cell == nil) {
			 cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		 }
		 // Set up the cell...
		 Status *status=[statusArray objectAtIndex:indexPath.row];
		 cell.textLabel.text = status.text;
		 NSUInteger row = [indexPath row];
		 NSUInteger oldRow = [lastIndexPath row];
		 cell.accessoryType = (row == oldRow && lastIndexPath != nil) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
		 return cell;
	 } else {
		 if (presence.note==nil) {
			 static NSString *CellIdentifier = @"Cell";
			 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			 if (cell == nil) {
				 cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
				 cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			 }
			 cell.textLabel.text =@"Add Note";
			 return cell;
		 } else {
			 static NSString *NoteCellIdentifier = @"NoteCell";
			 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NoteCellIdentifier];
			 if (cell == nil) {
				 [[NSBundle mainBundle] loadNibNamed:@"NotesTableCell" owner:self options:nil];
				 cell = nCell;
				 self.nCell = nil;
				 notes.text=presence.note;
				 cell.selectionStyle = UITableViewCellSelectionStyleNone;
			 }
			 return cell;
		}
	 }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section==0) {
		if (initialSelection!=indexPath.row) {
			self.navigationItem.rightBarButtonItem.enabled=YES;
		}
		Status *status=[statusArray objectAtIndex:indexPath.row];
		if ([status.imageName isEqualToString:@"button_blue.png"])
			self.header.indicator.color = button_blue;
		if ([status.imageName isEqualToString:@"button_gray.png"])
			self.header.indicator.color = button_gray;
		if ([status.imageName isEqualToString:@"button_green.png"])
			self.header.indicator.color = button_green;
		if ([status.imageName isEqualToString:@"button_orange.png"])
			self.header.indicator.color = button_orange;
		if ([status.imageName isEqualToString:@"button_purple.png"])
			self.header.indicator.color = button_purple;
		if ([status.imageName isEqualToString:@"button_red.png"])
			self.header.indicator.color = button_red;
		if ([status.imageName isEqualToString:@"button_white.png"])
			self.header.indicator.color = button_white;
		if ([status.imageName isEqualToString:@"button_yellow.png"])
			self.header.indicator.color = button_yellow;
		self.header.indicator.text = status.text;

		int newRow = [indexPath row];
		int oldRow = [lastIndexPath row];
		if (newRow != oldRow)
		{
			UITableViewCell *newCell = [self.tableView cellForRowAtIndexPath:indexPath];
			newCell.accessoryType = UITableViewCellAccessoryCheckmark;
			UITableViewCell *oldCell = [self.tableView cellForRowAtIndexPath: lastIndexPath];
			oldCell.accessoryType = UITableViewCellAccessoryNone;
			lastIndexPath = indexPath;
		}
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	} else if (indexPath.section==1) {
		if (presence.note==nil) {
			RollSheetAddNoteController *myNoteView = [[RollSheetAddNoteController alloc] initWithNibName:@"RollSheetAddNoteController" bundle:nil];
			myNoteView.presence=presence;
			[self presentModalViewController:myNoteView animated:YES];
			[myNoteView release];
		}
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	if (section==0) 
		return @"Select to Change Attendance";
	else 
		return @"Notes";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if (indexPath.section==0)
		return 40;
	if (indexPath.section==1) {
		if (presence.note==nil)
			return 40;
	}
	return 160;
}

//- (void)viewWillDisappear:(BOOL)animated {}


- (IBAction) showNotes {
	NoteViewController *myNoteView = [[NoteViewController alloc] initWithNibName:@"NoteViewController" bundle:nil];
	myNoteView.presence=presence;
	myNoteView.edit=YES;
	[self presentModalViewController:myNoteView animated:YES];
	[myNoteView release];
}

- (IBAction) deleteNotes {
	presence.note=nil;
	[self.tableView reloadData];
}

- (void)dealloc {
	[presence release];
	[nCell release];
	[notes release];
	[statusArray release];
    [super dealloc];
}

@end
