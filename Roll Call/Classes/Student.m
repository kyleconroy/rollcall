// 
//  Student.m
//  Roll Call
//
//  Created by Kyle Conroy on Apr4.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Student.h"

#import "Course.h"
#import "Presence.h"
#import "Address.h"

@implementation Student 

@dynamic phone;
@dynamic address;
@dynamic firstName;
@dynamic thumbnailPhoto;
@dynamic email;
@dynamic lastName;
@dynamic courses;
@dynamic presences;

@end


@implementation ImageToDataTransformer


+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}


- (id)transformedValue:(id)value {
	NSData *data = UIImagePNGRepresentation(value);
	return data;
}


- (id)reverseTransformedValue:(id)value {
	UIImage *uiImage = [[UIImage alloc] initWithData:value];
	return [uiImage autorelease];
}

@end