//
//  GraphController.m
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
#import "GraphController.h"
#import "Presence.h"
#import "Status.h"

@implementation GraphPoint

- (id) initWithID:(int)pkv value:(NSNumber*)number{
	if(self = [super init]){
		pk = pkv;
		value = [number retain];
	}
	return self;
}

- (NSNumber*) yValue{
	return value;
}
- (NSString*) xLabel{
	return [NSString stringWithFormat:@"%d",pk];
}
- (NSString*) yLabel{
	int y = [value intValue];
	if (y==0)
		return [NSString stringWithFormat:@"%d",y];
	return [NSString stringWithFormat:@"%i",y/8];
}

@end

@implementation GraphController

@synthesize presences, lastName, firstName;

- (void)viewDidLoad{
	[super viewDidLoad];
	graph.title.text = [[NSString alloc] initWithFormat:@"%@ %@'s Absences in Last 30 Days", firstName, lastName];
	[graph setPointDistance:25];
	indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	CGRect r = indicator.frame;
	r.origin = self.view.bounds.origin;
	r.origin.x = self.view.bounds.size.width / 2  - r.size.width / 2;
	r.origin.y = self.view.bounds.size.height / 2  - r.size.height / 2;
	indicator.frame = r;
	[self.view addSubview:indicator];
	[indicator startAnimating];
	data = [[NSMutableArray alloc] init];
	[NSThread detachNewThreadSelector:@selector(thread) toTarget:self withObject:nil];
}

- (void) thread{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	NSDate *now = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:-30];// 1 month before
	NSDate *toDate = [gregorian dateByAddingComponents:comps toDate: now options:0];
	
	NSDate *newDate = toDate;
	int i=0;
	while ([self comparedate: newDate isBetweenDate:toDate andDate:now]) {
		int aC=0;
		for (Presence *presence in presences) {
			NSDate *oneDayBefore=[newDate addTimeInterval:-3600*24];
			if ([self comparedate:presence.date isBetweenDate:oneDayBefore andDate:newDate]) {
				if ([presence.status.letter isEqualToString:@"A"])
					aC++;
				
				int pc=[presences count];
				NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
				[dateFormat setDateFormat:@"ha, EEEE MMMM d"];
				NSString *dateString = [dateFormat stringFromDate:presence.date];
				NSLog(@"date: %@ %i \n", dateString, pc);
				
			}
		}
		GraphPoint *gp = [[GraphPoint alloc] initWithID:i value:[NSNumber numberWithFloat:aC*8]];
		[data addObject:gp];
		[gp release];
		newDate=[newDate addTimeInterval:3600*24];
		i++;
	}	
	[self performSelectorOnMainThread:@selector(threadComplete) withObject:nil waitUntilDone:NO];
	
	[pool drain];
}


- (BOOL)comparedate:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
	if ([date compare:beginDate] == NSOrderedAscending)
		return NO;
	
	if ([date compare:endDate] == NSOrderedDescending) 
		return NO;
	
	return YES;
}

- (void) threadComplete{
	[indicator stopAnimating];
	
	[self.graph setGraphWithDataPoints:data];
	self.graph.goalValue = [NSNumber numberWithFloat:30.0];
	self.graph.goalShown = NO;
	[self.graph scrollToPoint:80 animated:YES];
	[self.graph showIndicatorForPoint:75];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
- (void)dealloc {
	[data release];
	[indicator release];
	[presences release];
    [super dealloc];
}

@end
