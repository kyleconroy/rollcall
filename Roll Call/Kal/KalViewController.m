/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalViewController.h"
#import "KalLogic.h"
#import "KalDataSource.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "GraphController.h"
#import "Status.h"
#import "Student.h"
#import "Presence.h"
#import "AttendanceTableViewController.h"

#define PROFILER 0
#if PROFILER
#include <mach/mach_time.h>
#include <time.h>
#include <math.h>
void mach_absolute_difference(uint64_t end, uint64_t start, struct timespec *tp)
{
    uint64_t difference = end - start;
    static mach_timebase_info_data_t info = {0,0};

    if (info.denom == 0)
        mach_timebase_info(&info);
    
    uint64_t elapsednano = difference * (info.numer / info.denom);
    tp->tv_sec = elapsednano * 1e-9;
    tp->tv_nsec = elapsednano - (tp->tv_sec * 1e9);
}
#endif

@interface KalViewController ()
- (KalView*)calendarView;
@end

@implementation KalViewController

@synthesize dataSource, delegate, student, statuses, titleString, isAll;

- (id)initWithSelectedDate:(NSDate *)selectedDate
{
  if ((self = [super init])) {
    logic = [[KalLogic alloc] initForDate:selectedDate];
    initialSelectedDate = [selectedDate retain];
  }
  return self;
}

- (id)init
{
  return [self initWithSelectedDate:[NSDate date]];
}

- (KalView*)calendarView { return (KalView*)self.view; }

- (void)setDataSource:(id<KalDataSource>)aDataSource
{
  if (dataSource != aDataSource) {
    [dataSource release];
    [aDataSource retain];
    dataSource = aDataSource;
    tableView.dataSource = dataSource;
  }
}

- (void)setDelegate:(id<UITableViewDelegate>)aDelegate
{
  if (delegate != aDelegate) {
    [delegate release];
    [aDelegate retain];
    delegate = aDelegate;
    tableView.delegate = delegate;
  }
}

- (void)clearTable
{
  [dataSource removeAllItems];
  [tableView reloadData];
}

- (void)reloadData
{
  [dataSource presentingDatesFrom:logic.fromDate to:logic.toDate delegate:self];
}

// -----------------------------------------
#pragma mark KalViewDelegate protocol

- (void)didSelectDate:(KalDate *)date
{
  NSDate *from = [[date NSDate] cc_dateByMovingToBeginningOfDay];
  NSDate *to = [[date NSDate] cc_dateByMovingToEndOfDay];
  [self clearTable];
  [dataSource loadItemsFromDate:from toDate:to];
  [tableView reloadData];
  [tableView flashScrollIndicators];
}

- (void)showPreviousMonth
{
  [self clearTable];
  [logic retreatToPreviousMonth];
  [[self calendarView] slideDown];
  [self reloadData];
}

- (void)showFollowingMonth
{
  [self clearTable];
  [logic advanceToFollowingMonth];
  [[self calendarView] slideUp];
  [self reloadData];
}

// -----------------------------------------
#pragma mark KalDataSourceCallbacks protocol

- (void)loadedDataSource:(id<KalDataSource>)theDataSource;
{
  NSArray *markedDates = [theDataSource markedDatesFrom:logic.fromDate to:logic.toDate];
  NSMutableArray *dates = [[markedDates mutableCopy] autorelease];
  for (int i=0; i<[dates count]; i++)
    [dates replaceObjectAtIndex:i withObject:[KalDate dateFromNSDate:[dates objectAtIndex:i]]];
  
  [[self calendarView] markTilesForDates:dates];
  [self didSelectDate:self.calendarView.selectedDate];
}

// ---------------------------------------
#pragma mark -

- (void)showAndSelectDate:(NSDate *)date
{
  if ([[self calendarView] isSliding])
    return;
  
  [logic moveToMonthForDate:date];
  
#if PROFILER
  uint64_t start, end;
  struct timespec tp;
  start = mach_absolute_time();
#endif
  
  [[self calendarView] jumpToSelectedMonth];
  
#if PROFILER
  end = mach_absolute_time();
  mach_absolute_difference(end, start, &tp);
  printf("[[self calendarView] jumpToSelectedMonth]: %.1f ms\n", tp.tv_nsec / 1e6);
#endif
  
  [[self calendarView] selectDate:[KalDate dateFromNSDate:date]];
  [self reloadData];
}

// -----------------------------------------------------------------------------------
#pragma mark UIViewController

- (void)loadView
{
	isKal=YES;
	KalView *kalView = [[KalView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] delegate:self logic:logic];
	self.view = kalView;
	tableView = kalView.tableView;
	tableView.dataSource = dataSource;
	tableView.delegate = delegate;
	[tableView retain];
	[kalView selectDate:[KalDate dateFromNSDate:initialSelectedDate]];
	[self reloadData];
}

- (IBAction) showList {
	isKal=NO;
	if (!isAll) {
	UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 100, 44.4)];	
	NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
	
	UIBarButtonItem *calButton = [[UIBarButtonItem alloc]
								  initWithImage: [UIImage imageNamed:@"calendar_button.png"]
								  style: UIBarButtonItemStyleBordered
								  target:self
								  action:@selector(showKal)];
	
	calButton.width=40;
	[buttons addObject:calButton];
	[calButton release];
	UIBarButtonItem *graphButton = [[UIBarButtonItem alloc]
									initWithImage: [UIImage imageNamed:@"16-line-chart.png"]
									style: UIBarButtonItemStyleBordered
									target:self
									action:@selector(showGraph)];
	graphButton.width=40;
	[buttons addObject:graphButton];
	[graphButton release];
	[toolbar setBarStyle:UIStatusBarStyleDefault];
	[toolbar setItems:buttons animated:NO];
	[buttons release];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
	[toolbar release];
	} else {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
												  initWithImage:[UIImage imageNamed:@"calendar_button.png"] 
												  style:UIBarButtonItemStyleBordered 
												  target:self 
												  action:@selector(showKal)];
	} 

	AttendanceTableViewController *aView = [[AttendanceTableViewController alloc] initWithNibName:@"AttendanceTableViewController" bundle:nil];
	aView.type=2;
	aView.student=student;
	aView.statuses=statuses;
	aView.myTitle=titleString;
	aView.kal=self;
	self.view=aView.view;
}

- (IBAction) showKal {
	isKal=YES;
	if (!isAll) {
	UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 100, 44.4)];	
	NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
	UIBarButtonItem *listButton = [[UIBarButtonItem alloc]
								   initWithImage: [UIImage imageNamed:@"list_button.png"]////calendar_button.png
								   style: UIBarButtonItemStyleBordered
								   target:self
								   action:@selector(showList)];
	listButton.width=40;
	[buttons addObject:listButton];
	[listButton release];
	UIBarButtonItem *graphButton = [[UIBarButtonItem alloc]
									initWithImage: [UIImage imageNamed:@"16-line-chart.png"]
									style: UIBarButtonItemStyleBordered
									target:self
									action:@selector(showGraph)];
	graphButton.width=40;
	[buttons addObject:graphButton];
	[graphButton release];
	[toolbar setBarStyle:UIStatusBarStyleDefault];
	[toolbar setItems:buttons animated:NO];
	[buttons release];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
	[toolbar release];
	} else {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
												   initWithImage:[UIImage imageNamed:@"list_button.png"] 
												   style:UIBarButtonItemStyleBordered 
												   target:self 
												   action:@selector(showList)];
	}
	KalView *kalView = [[KalView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame] delegate:self logic:logic];
	self.view = kalView;
	tableView = kalView.tableView;
	tableView.dataSource = dataSource;
	tableView.delegate = delegate;
	[tableView retain];
	//[kalView selectDate:[KalDate dateFromNSDate:initialSelectedDate]];
	[self reloadData];
}

- (IBAction) showGraph {
	GraphController *vc = [[GraphController alloc] init];
	vc.presences=statuses;
	vc.lastName=student.lastName;
	vc.firstName=student.firstName;
	vc.statusText=titleString;
	[vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
	[self presentModalViewController:vc animated:YES];
	[vc release];	
}


- (void)showAndSelectToday
{
	[self showAndSelectDate:[NSDate date]];
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if (!isAll) {
		UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 100, 44.4)];	
		NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
		if (isKal) {
	UIBarButtonItem *listButton = [[UIBarButtonItem alloc]
								   initWithImage: [UIImage imageNamed:@"list_button.png"]////calendar_button.png
								   style: UIBarButtonItemStyleBordered
								   target:self
								   action:@selector(showList)];
	listButton.width=40;
	[buttons addObject:listButton];
	[listButton release];
		} else {
			UIBarButtonItem *calButton = [[UIBarButtonItem alloc]
										  initWithImage: [UIImage imageNamed:@"calendar_button.png"]
										  style: UIBarButtonItemStyleBordered
										  target:self
										  action:@selector(showKal)];
			
			calButton.width=40;
			[buttons addObject:calButton];
			[calButton release];
		}
	UIBarButtonItem *graphButton = [[UIBarButtonItem alloc]
									initWithImage: [UIImage imageNamed:@"16-line-chart.png"]
									style: UIBarButtonItemStyleBordered
									target:self
									action:@selector(showGraph)];
	graphButton.width=40;
	[buttons addObject:graphButton];
	[graphButton release];
	[toolbar setBarStyle:UIStatusBarStyleDefault];
	toolbar.translucent=YES;
	[toolbar setItems:buttons animated:NO];
	[buttons release];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
	[toolbar release];
	} else {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
													   initWithImage:[UIImage imageNamed:@"list_button.png"] 
													   style:UIBarButtonItemStyleBordered 
													   target:self 
													   action:@selector(showList)];
	}
	isKal=YES;
	[tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [tableView flashScrollIndicators];
}


#pragma mark -

- (void)dealloc
{
  [initialSelectedDate release];
  [logic release];
  [tableView release];
  [super dealloc];
}

@end
