//
//  RollSheetAddNoteController.h
//  Roll Call
//
//  Created by Kyle Conroy on Apr13.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Presence.h"
#import "Roll_CallAppDelegate.h"


@interface RollSheetAddNoteController : UIViewController {

    Presence *presence;
    Roll_CallAppDelegate *aD;
    IBOutlet UITextView *myTextView;
    UIButton *button;
}

@property(nonatomic, retain) Presence *presence;
@property(nonatomic, retain) Roll_CallAppDelegate *aD;
@property(nonatomic, retain) UIButton *button;
@property(nonatomic, retain) IBOutlet UITextView *myTextView;

- (IBAction) cancelNote;
- (IBAction) doneNote;
- (void) hideNote;

@end
