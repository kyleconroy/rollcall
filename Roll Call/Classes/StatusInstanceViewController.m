//
//  StatusInstanceViewController.m
//  Roll Call
//
//  Created by Kyle Conroy on Apr30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StatusInstanceViewController.h"
#import "EditTextFieldViewController.h"
#import "EditStatusColorViewController.h"

@implementation StatusInstanceViewController

@synthesize aD;
@synthesize myStatus;
@synthesize myTableLayout;
@synthesize myTableView;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [self setTitle:@"Status"];
    
    aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    myTableLayout = [[NSArray alloc] initWithObjects:
                     [NSMutableDictionary dictionaryWithObjectsAndKeys:myStatus.text, @"text", 
                      @"Title", @"section", nil],
                     [NSMutableDictionary dictionaryWithObjectsAndKeys:myStatus.letter, @"text", 
                      @"Symbol", @"section", nil],
                     [NSMutableDictionary dictionaryWithObjectsAndKeys:[[[myStatus.imageName stringByReplacingOccurrencesOfString:@".png" withString:@""]
                                stringByReplacingOccurrencesOfString:@"button_" withString:@""] capitalizedString], @"text", 
                      @"Color", @"section", nil],
                     nil];
    
    [super viewDidLoad];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [myTableLayout count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = [[myTableLayout objectAtIndex:indexPath.row] objectForKey:@"text"];
    cell.textLabel.text = [[myTableLayout objectAtIndex:indexPath.row] objectForKey:@"section"];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void) editStatus {
    if(self.editing)
    {
        [super setEditing:NO animated:YES];
        [myTableView setEditing:NO animated:YES];
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [myTableView setEditing:YES animated:YES];
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.rightBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
}


// The editing style for a row is the kind of button displayed to the left of the cell when in editing mode.
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row < 2) {
        
        EditTextFieldViewController *textController = [[EditTextFieldViewController alloc] 
                                                       initWithNibName:@"EditTextFieldViewController" bundle:nil];
        
        textController.delegate = self;
        textController.myType = [NSNumber numberWithInt:indexPath.row];
        textController.myTitle = [NSString stringWithFormat:@"Edit %@", [[myTableLayout objectAtIndex:indexPath.row] objectForKey:@"section"]];
        textController.myText = [[myTableLayout objectAtIndex:indexPath.row] objectForKey:@"text"];
        
        [self.navigationController pushViewController:textController animated:YES];
        [textController release];

    } else {
        
        EditStatusColorViewController *textController = [[EditStatusColorViewController alloc] 
                                                       initWithNibName:@"EditStatusColorViewController" bundle:nil];
        
        textController.delegate = self;
        textController.current = [[myTableLayout objectAtIndex:indexPath.row] objectForKey:@"text"];
        [self.navigationController pushViewController:textController animated:YES];
        [textController release];
        
    }
    

}

- (void)editStatusColorViewController:(EditStatusColorViewController *)editStatusColorViewController

                       didChangeColor:(NSString *)color {
    
    if (color) {
        myStatus.imageName = [NSString stringWithFormat:@"button_%@.png", [color lowercaseString]];
        
        NSError *error;
        if (![[aD managedObjectContext] save:&error]) {
            // Handle the error.
        }
        
        [[myTableLayout objectAtIndex:2] setObject:color forKey:@"text"]; 
        [myTableView reloadData];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editTextFieldViewController:(EditTextFieldViewController *)editTextFieldViewController

                    withType: (NSNumber*)type didChangeText:(NSString *)text {
    
    if(text){
    
        if ([type intValue] == 0) {
            myStatus.text = text;
        } else if ([type intValue] == 1) {
            myStatus.letter = text;
        }
        
        NSError *error;
        if (![[aD managedObjectContext] save:&error]) {
            // Handle the error.
        }
        
        [[myTableLayout objectAtIndex:[type intValue]] setObject:text forKey:@"text"]; 
        [myTableView reloadData];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc {
    [myTableLayout release] ;
    [super dealloc];
}


@end

