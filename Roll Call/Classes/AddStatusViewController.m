//
//  StatusInstanceViewController.m
//  Roll Call
//
//  Created by Kyle Conroy on Apr30.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddStatusViewController.h"
#import "EditTextFieldViewController.h"
#import "EditStatusColorViewController.h"

@implementation AddStatusViewController

@synthesize delegate;
@synthesize aD;
@synthesize myTableLayout;
@synthesize myTableView;
@synthesize letter;
@synthesize text;
@synthesize imageName;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [self setTitle:@"Status"];
    
    aD = (Roll_CallAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    myTableLayout = [[NSArray alloc] initWithObjects:
                     [NSMutableDictionary dictionaryWithObjectsAndKeys:@"New Status", @"text", 
                      @"Title", @"section", nil],
                     [NSMutableDictionary dictionaryWithObjectsAndKeys:@"NS", @"text", 
                      @"Symbol", @"section", nil],
                     [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Blue", @"text", 
                      @"Color", @"section", nil],
                     nil];
    
    imageName = [NSString stringWithFormat:@"button_%@.png", @"Blue"];
    letter = @"NS";
    text = @"New Status";
    
    [imageName retain];
    [letter retain];
    [text   retain];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] 
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];    
    
    
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

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < 2) {
        
        EditTextFieldViewController *textController = [[EditTextFieldViewController alloc] 
                                                       initWithNibName:@"EditTextFieldViewController" bundle:nil];
        
        textController.delegate = self;
        textController.myType = [NSNumber numberWithInt:indexPath.row];
        textController.myTitle = [NSString stringWithFormat:@"Edit %@", [[myTableLayout objectAtIndex:indexPath.row] objectForKey:@"section"]];
        textController.myText = nil;
        
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

- (void) cancel {
    [delegate addStatusViewController:self withText:nil letter:nil imageName:nil];
}

- (void) save {
    [delegate addStatusViewController:self withText:text letter:letter imageName:imageName];
}

- (void)editStatusColorViewController:(EditStatusColorViewController *)editStatusColorViewController

                       didChangeColor:(NSString *)color {
    
    if (color) {
        imageName = [NSString stringWithFormat:@"button_%@.png", [color lowercaseString]];
        [[myTableLayout objectAtIndex:2] setObject:color forKey:@"text"]; 
        [myTableView reloadData];
        [imageName retain];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editTextFieldViewController:(EditTextFieldViewController *)editTextFieldViewController

                           withType: (NSNumber*)type didChangeText:(NSString *)newText {
    
    if(newText){
        
        if ([type intValue] == 0) {
            text = newText;
        } else if ([type intValue] == 1) {
            letter = newText;
        }
        
        [[myTableLayout objectAtIndex:[type intValue]] setObject:newText forKey:@"text"]; 
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
    [myTableLayout release];
    [letter release];
    [myTableView release];
    [imageName release];
    [text release];
    [super dealloc];
}


@end

