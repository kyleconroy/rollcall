//
//  OverviewController.h
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

#import "TKOverviewTableViewController.h"
@class Presence;
@class AttendanceTableViewController;
@class KalViewController;

@interface AttendanceEditViewController : TKOverviewTableViewController <UIActionSheetDelegate> {
	Presence *presence;
	NSString *name;
	NSIndexPath *lastIndexPath;
	NSMutableArray *statusArray;
	NSInteger initialSelection;
	IBOutlet UITableViewCell *nCell;
	IBOutlet UITextView *notes;
	AttendanceTableViewController *listView;
	KalViewController *kal;
	BOOL isKal;
}
@property (nonatomic) BOOL isKal;
@property (nonatomic, retain) Presence *presence;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSIndexPath *lastIndexPath;
@property NSInteger initialSelection;
@property (nonatomic, retain) IBOutlet UITableViewCell *nCell;
@property (nonatomic, retain) IBOutlet UITextView *notes;
@property (nonatomic, retain) NSMutableArray *statusArray;
@property (nonatomic, retain) AttendanceTableViewController *listView;
@property(nonatomic, retain) KalViewController *kal;

- (IBAction) showNotes;
- (IBAction) deleteNotes;

@end

