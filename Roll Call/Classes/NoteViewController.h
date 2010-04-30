//
//  NoteViewController.h
//  Roll Call
//
//  Created by Weizhi on 4/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Presence;

@interface NoteViewController : UIViewController {
	NoteViewController *myNoteView;
    IBOutlet UITextView *myTextView;
	UIBarButtonItem *button1;
	UIBarButtonItem *button2;
	Presence *presence;
	Boolean edit;
}

@property(nonatomic, retain) IBOutlet UITextView *myTextView;
@property(nonatomic, retain) NoteViewController *myNoteView;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *button1;
@property(nonatomic, retain) IBOutlet UIBarButtonItem *button2;
@property(nonatomic, retain) Presence *presence;
@property(nonatomic) Boolean edit;

- (IBAction) doneNote;
- (IBAction) hideNote;
- (IBAction) editNote;

@end
