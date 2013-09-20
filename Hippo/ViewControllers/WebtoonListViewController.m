//
//  WebtoonListViewController.m
//  Hippo
//
//  Created by 전수열 on 13. 9. 1..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import "WebtoonListViewController.h"
#import "Webtoon.h"
#import "WebtoonDetailViewController.h"
#import "DejalActivityView.h"

@implementation UINavigationBar (Hippo)

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	if( !self.clipsToBounds && !self.hidden && self.alpha > 0 )
	{
        for (UIView *subview in self.subviews.reverseObjectEnumerator) {
            CGPoint subPoint = [subview convertPoint:point fromView:self];
            UIView *result = [subview hitTest:subPoint withEvent:event];
            if (result != nil) {
                return result;
                break;
            }
        }
    }
	
    return [super hitTest:point withEvent:event];
}

@end


@implementation WebtoonListViewController


- (void)viewDidLoad
{
	[super viewDidLoad];
	
	self.weekdaySelector = [[WeekdaySelector alloc] init];
	self.weekdaySelector.frame = CGRectMake( 10, 48, UIScreenWidth - 20, self.weekdaySelector.frame.size.height );
	[self.weekdaySelector addTarget:self action:@selector(filterWebtoons) forControlEvents:UIControlEventValueChanged];
	
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake( 0, 0, UIScreenWidth, UIScreenHeight - 48 )];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	self.tableView.contentInset = self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake( 152, 0, 0, 0 );
	[self.view addSubview:self.tableView];
	
	self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake( 0, 108, UIScreenWidth, 44 )];
	self.searchBar.placeholder = L( @"SEARCH" );
	self.searchBar.delegate = self;
	[self.view addSubview:self.searchBar];
}


- (void)viewWillAppear:(BOOL)animated
{
	if( self.type == HippoWebtoonListViewControllerTypeMyWebtoon ) {
		self.tabBarController.title = L(@"MY_WEBTOONS");
		[self filterWebtoons];
	} else {
		self.tabBarController.title = L(@"SEARCH");
	}
	
	if( animated ) {
		self.weekdaySelector.alpha = 0;
	}
	[self.tabBarController.navigationController.navigationBar addSubview:self.weekdaySelector];
	[UIView animateWithDuration:0.25 animations:^{
		self.weekdaySelector.alpha = 1;
		[[[[self.tabBarController.navigationController.navigationBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] setFrame:CGRectMake( 0, 0, 320, 108 )];
		[[[[self.tabBarController.navigationController.navigationBar.subviews objectAtIndex:0] subviews] objectAtIndex:1] setPosition:CGPointMake( 0, 108 )];
	}];
}

- (void)viewDidAppear:(BOOL)animated
{
	self.tableView.contentInset = self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake( 152, 0, 0, 0 );
}

- (void)viewDidDisappear:(BOOL)animated
{
	[UIView animateWithDuration:0.25 animations:^{
		self.weekdaySelector.alpha = 0;
	} completion:^(BOOL finished) {
		[self.weekdaySelector removeFromSuperview];
	}];
}


#pragma mark -


- (void)filterWebtoons
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
		NSString *weekday = HippoWeekdays[self.weekdaySelector.selectedSegmentIndex];
		NSFetchRequest *request = nil;
		if( [weekday isEqualToString:@"all"] )
		{
			if( self.type == HippoWebtoonListViewControllerTypeMyWebtoon ) {
				request = [[Webtoon request] filter:@"subscribed=1"];
			} else {
				request = [Webtoon request];
			}
		}
		else if( [weekday isEqualToString:@"finished"] )
		{
			if( self.type == HippoWebtoonListViewControllerTypeMyWebtoon ) {
				request = [[Webtoon request] filter:@"subscribed=1 AND finished=0"];
			} else {
				request = [[Webtoon request] filter:@"finished=1"];
			}
		}
		else
		{
			if( self.type == HippoWebtoonListViewControllerTypeMyWebtoon ) {
				request = [[Webtoon request] filter:@"subscribed=1 AND %@=1 AND finished=0", weekday];
			} else {
				request = [[Webtoon request] filter:@"%@=1&&finished=0", weekday];
			}
		}
		
		if( self.searchBar.text.length )
		{
			request = [request filter:@"title like '*%@*'", self.searchBar.text];
		}
		
		NSMutableArray *webtoons = [request orderBy:@"title"].all.mutableCopy;
		
		dispatch_async(dispatch_get_main_queue(), ^{
			self.webtoons = webtoons;
			[self.tableView reloadData];
			[DejalBezelActivityView removeView];
		});
	});
}


#pragma mark -
#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.webtoons.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellId = @"webtoonCellId";
	WebtoonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	if( !cell ) {
		cell = [[WebtoonCell alloc] initWithReuseIdentifier:cellId];
		cell.delegate = self;
	}
	
	Webtoon *webtoon = [self.webtoons objectAtIndex:indexPath.row];
	cell.webtoon = webtoon;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	WebtoonDetailViewController *detailViewController = [[WebtoonDetailViewController alloc] init];
	detailViewController.webtoon = [self.webtoons objectAtIndex:indexPath.row];
	[self.tabBarController.navigationController pushViewController:detailViewController animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if( self.searchBar.isFirstResponder ) {
		[self.searchBar resignFirstResponder];
	}
	
	if( scrollView.contentOffset.y <= -152 )
	{
		self.searchBar.position = CGPointMake( 0, 108 );
	}
	else if( scrollView.contentOffset.y > -152 )
	{
		self.searchBar.position = CGPointMake( 0, -44 - scrollView.contentOffset.y );
	}
}


#pragma mark -
#pragma mark WebtoonCellDelegate

- (void)webtoonCell:(WebtoonCell *)webtoonCell subscribeButtonDidTouchUpInside:(UIButton *)subscribeButton
{
	subscribeButton.enabled = NO;
	
	Webtoon *webtoon = webtoonCell.webtoon;
	if( !webtoon.subscribed.boolValue )
	{
		NSString *api = [NSString stringWithFormat:@"/webtoon/%@/subscribe", webtoon.id];
		[[APILoader sharedLoader] api:api method:@"POST" parameters:nil success:^(id response) {
			subscribeButton.enabled = YES;
			webtoon.subscribed = [NSNumber numberWithBool:YES];
			[JLCoreData saveContext];;
			[webtoonCell layoutContentView];
			
		} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
			subscribeButton.enabled = YES;
			webtoon.subscribed = [NSNumber numberWithBool:NO];
			[webtoonCell layoutContentView];
		}];
	}
	else
	{
		NSString *api = [NSString stringWithFormat:@"/webtoon/%@/subscribe", webtoon.id];
		[[APILoader sharedLoader] api:api method:@"DELETE" parameters:nil success:^(id response) {
			subscribeButton.enabled = YES;
			webtoon.subscribed = [NSNumber numberWithBool:NO];
			[JLCoreData saveContext];;
			[webtoonCell layoutContentView];
			
		} failure:^(NSInteger statusCode, NSInteger errorCode, NSString *message) {
			subscribeButton.enabled = YES;
			webtoon.subscribed = [NSNumber numberWithBool:YES];
			[webtoonCell layoutContentView];
		}];
	}
}


#pragma mark -
#pragma UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[self filterWebtoons];
}

@end
