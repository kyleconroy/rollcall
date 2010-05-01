//
//  GraphController.h
//  Created by Devin Ross on 7/17/09.
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
#import "TKGraphController.h"
#import "TKGraphView.h"

@class GraphPoint;

@interface GraphController : TKGraphController {
	UIActivityIndicatorView *indicator;
	NSMutableArray *data;
	NSMutableArray *presences;
	NSString *lastName;
	NSString *firstName;
}

@property (nonatomic, retain) NSMutableArray *presences;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *firstName;

- (BOOL)comparedate:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

@end

@interface GraphPoint : NSObject <TKGraphViewPoint> {
	int pk;
	NSNumber *value;
}

- (id) initWithID:(int)pk value:(NSNumber*)number;

@end
