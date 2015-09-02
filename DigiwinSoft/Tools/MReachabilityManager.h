//
//  MReachabilityManager.h
//  dataQuery
//
//  Created by Li Yeh Chiu on 2009/12/7.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"


@interface MReachabilityManager : NSObject {

	//
	Reachability* internetReach;
	//
    Reachability* wifiReach;
	
	bool internetAvailable;
	
	bool wifiAvailable;
}

+(MReachabilityManager*) sharedInstance;

-(void) start;

-(bool) isInternetAvailable;

@end
