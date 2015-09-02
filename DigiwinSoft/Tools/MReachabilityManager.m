//
//  MReachabilityManager.m
//  dataQuery
//
//  Created by Li Yeh Chiu on 2009/12/7.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MReachabilityManager.h"


@implementation MReachabilityManager


static MReachabilityManager* _reachabilityManager = nil;

+(MReachabilityManager*) sharedInstance
{
	@synchronized([MReachabilityManager class])
	{
		if( !_reachabilityManager)
		{
			_reachabilityManager=[[MReachabilityManager alloc] init];
		}
		return _reachabilityManager;
	}
	
	return nil;
}

-(id) init
{
	self = [super init];
	if( self)
	{
		_reachabilityManager = self;
		internetAvailable = false;
		wifiAvailable = false;
		[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	}
	return self;
}

- (void) updateStatusWithReachability: (Reachability*) curReach
{
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
    //BOOL connectionRequired= [curReach connectionRequired];
	
	NSLog(@"updateStatusWithReachability !");

	if(curReach == internetReach)
	{	
		if( netStatus == NotReachable)
		{
			NSLog(@"Internet NotReachable!");
			internetAvailable = false;
		}
		else if( netStatus == ReachableViaWWAN)
		{
			NSLog(@"Internet ReachableViaWWAN!");
			internetAvailable = true;
		}
		else if( netStatus == ReachableViaWiFi)
		{
			NSLog(@"Internet ReachableViaWiFi!");
			internetAvailable = true;
		}
	}
	if(curReach == wifiReach)
	{	
		if( netStatus == NotReachable)
		{
			wifiAvailable = false;
		}
		else if( netStatus == ReachableViaWWAN)
		{
			wifiAvailable = true;
		}
		else if( netStatus == ReachableViaWiFi)
		{
			wifiAvailable = true;
		}
	}
}

- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateStatusWithReachability: curReach];
}


-(void) start
{
	internetReach = [[Reachability reachabilityForInternetConnection] retain];
	[internetReach startNotifier];
	[self updateStatusWithReachability: internetReach];
	
	wifiReach = [[Reachability reachabilityForLocalWiFi] retain];
	[wifiReach startNotifier];
	[self updateStatusWithReachability: wifiReach];
	
}


-(bool) isInternetAvailable
{
	return internetAvailable;
}


@end
