//
//  AddStudentNameTableCell.h
//  Roll Call
//
//  Created by Weizhi on 4/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddStudentNameTableCell : UITableViewCell {
	UITextField *textField;
	UITextField *textField1;
	UITextField *textField2;
	UITextField *textField3;
}
@property (nonatomic, retain) IBOutlet UITextField *textField1;
@property (nonatomic, retain) IBOutlet UITextField *textField2;
@property (nonatomic, retain) IBOutlet UITextField *textField3;
@property (nonatomic, retain) IBOutlet UITextField *textField;

@end
