//
//  EditStatusColorViewController.h
//  Roll Call
//
//  Created by Kyle Conroy on May1.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditStatusColorViewController;

@protocol ColorChangeDelegate <NSObject>

- (void)editStatusColorViewController:(EditStatusColorViewController *)editStatusColorViewController

                           didChangeColor:(NSString *)color;

@end


@interface EditStatusColorViewController : UITableViewController {
    
    id <ColorChangeDelegate> delegate;
    NSArray *colors;
    NSString *current;
    NSIndexPath *currentRow;
    
}

@property(nonatomic,retain) NSArray *colors;
@property(nonatomic,retain) NSString *current;
@property(nonatomic,retain) NSIndexPath *currentRow;
@property (nonatomic, assign) id <ColorChangeDelegate> delegate;

- (void) cancel;
-(void) save;
@end
