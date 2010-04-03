//
//  Student.h
//  Roll Call
//
//  Created by Kyle Conroy on Mar22.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//#import <Foundation/Foundation.h>


@interface Student : NSObject {
    NSString *firstName;
    NSString *lastName;
	NSString *phone;
	NSString *email;
	NSString *address;
	UIImage *thumbnailPhoto;
}

- (id)initWithFirstName:(NSString *)fistname lastName:(NSString *)lastname;

@property (readwrite, assign) NSString *firstName;
@property (readwrite, assign) NSString *lastName;
@property (readwrite, assign) NSString *phone;
@property (readwrite, assign) NSString *email;
@property (readwrite, assign) NSString *address;
@property (nonatomic, retain) UIImage *thumbnailPhoto;

@end
