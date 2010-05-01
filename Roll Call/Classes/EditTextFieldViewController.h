//
//  EditTextFieldViewController.h
//  Roll Call
//
//  Created by Kyle Conroy on May1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditTextFieldViewController;

@protocol EditTextFieldDelegate <NSObject>

- (void)editTextFieldViewController:(EditTextFieldViewController *)editTextFieldViewController

                    withType:(NSNumber *)type didChangeText:(NSString *)text;

@end

@interface EditTextFieldViewController : UITableViewController <UITextFieldDelegate> {
    
    
    id <EditTextFieldDelegate> delegate;
    NSNumber *myType;
    NSString *myPlaceHolder;
    NSString *myText;
    NSString *myTitle;
    IBOutlet UITableViewCell *myCell;
    IBOutlet UITextField *myTextField;

}

@property (nonatomic, assign) id <EditTextFieldDelegate> delegate;
@property (nonatomic, retain) NSNumber *myType;
@property (nonatomic, retain) NSString *myPlaceHolder;
@property (nonatomic, retain) NSString *myText;
@property (nonatomic, retain) NSString *myTitle;
@property (nonatomic, retain) IBOutlet UITableViewCell *myCell;
@property (nonatomic, retain) IBOutlet UITextField *myTextField;

- (void) cancel;
- (void) save;

@end
