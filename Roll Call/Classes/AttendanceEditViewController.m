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
#import "KalViewController.h"


@implementation AttendanceEditViewController

@synthesize presence, name;
@synthesize lastIndexPath;
@synthesize initialSelection;
@synthesize nCell, notes;
@synthesize kal;

- (void)viewDidLoad {
    [super viewDidLoad];
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
	if ([presence.status.letter isEqualToString:@"P"]) {
		initialSelection=0;
		self.header.indicator.text = @"Present";
		self.header.indicator.color = TKOverviewIndicatorViewColorGreen;
	}
	else if ([presence.status.letter isEqualToString:@"A"]) {
		initialSelection=1;
		self.header.indicator.text = @"Absent";
		self.header.indicator.color = TKOverviewIndicatorViewColorRed;
	}
	else if ([presence.status.letter isEqualToString:@"E"]) {
		initialSelection=2;
		self.header.indicator.text = @"Excused";
		self.header.indicator.color = TKOverviewIndicatorViewColorBlue;
	}
	else if ([presence.status.letter isEqualToString:@"T"]) {
		initialSelection=3;
		self.header.indicator.text = @"Tardy";
		self.header.indicator.color = TKOverviewIndicatorViewColorYellow;
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
	UIActionSheet *saveAlert = [[UIActionSheet alloc] initWithTitle: @"Are you sure you want to save the change?"
															 delegate: self cancelButtonTitle:@"No"
											   destructiveButtonTitle: nil
												    otherButtonTitles: @"Yes", nil, nil];
	saveAlert.actionSheetStyle = UIBarStyleBlackTranslucent;
	[saveAlert showInView:[[aD tabBarController] view]];
	[saveAlert release];
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
			Roll_CallAppDelegate *aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
			if([lastIndexPath row]==0){
				presence.status = [aD getStatusWithLetter:@"P"];
			} else if([lastIndexPath row]==1){
				presence.status = [aD getStatusWithLetter:@"A"];
			} else if([lastIndexPath row]==2){
				presence.status = [aD getStatusWithLetter:@"E"];
			} else if([lastIndexPath row]==3){
				presence.status = [aD getStatusWithLetter:@"T"];
			}
			NSError *error;
			if (![[aD managedObjectContext] save:&error]) {
				// Handle the error.
			}
			[self.navigationController popViewControllerAnimated:YES];
			break;
		}
	}
}

#pragma mark Table view methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0)
		return 4;
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
		 if(indexPath.row == 0)
			 cell.textLabel.text = @"Present";
		 if(indexPath.row == 1)
			 cell.textLabel.text = @"Absent";
		 if(indexPath.row == 2)
			 cell.textLabel.text = @"Excused";
		 if(indexPath.row == 3)
			 cell.textLabel.text = @"Tardy";
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
				 cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
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
		if(indexPath.row==0){
			self.header.indicator.color = TKOverviewIndicatorViewColorGreen;
			self.header.indicator.text = @"Present";
		}else if(indexPath.row==1){
			self.header.indicator.color = TKOverviewIndicatorViewColorRed;
			self.header.indicator.text = @"Absent";
		}else if(indexPath.row==2){
			self.header.indicator.color = TKOverviewIndicatorViewColorBlue;
			self.header.indicator.text = @"Excused";
		}else if(indexPath.row==3){
			self.header.indicator.color = TKOverviewIndicatorViewColorYellow;
			self.header.indicator.text = @"Tardy";
		}
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

- (void)viewWillDisappear:(BOOL)animated {
	if ([presence.status.letter isEqualToString:@"P"]) {
		self.header.indicator.text = @"Present";
		self.header.indicator.color = TKOverviewIndicatorViewColorGreen;
	}
	else if ([presence.status.letter isEqualToString:@"A"]) {
		self.header.indicator.text = @"Absent";
		self.header.indicator.color = TKOverviewIndicatorViewColorRed;
	}
	else if ([presence.status.letter isEqualToString:@"E"]) {
		self.header.indicator.text = @"Excused";
		self.header.indicator.color = TKOverviewIndicatorViewColorBlue;
	}
	else if ([presence.status.letter isEqualToString:@"T"]) {
		self.header.indicator.text = @"Tardy";
		self.header.indicator.color = TKOverviewIndicatorViewColorYellow;
	}
}


- (IBAction) showNotes {
	NoteViewController *myNoteView = [[NoteViewController alloc] initWithNibName:@"NoteViewController" bundle:nil];
	myNoteView.presence=presence;
	myNoteView.edit=YES;
	[self presentModalViewController:myNoteView animated:YES];
	[myNoteView release];
}

- (void)dealloc {
	[presence release];
	[nCell release];
	[notes release];
    [super dealloc];
}

@end
