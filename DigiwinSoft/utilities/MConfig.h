//
//  MConfig.h
//  DigiwinSoft
//
//  Created by Jyun on 2015/6/29.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#ifndef DigiwinSoft_MConfig_h
#define DigiwinSoft_MConfig_h

#define DEVICE_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define DEVICE_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define CUST_GUIDE_UUID_PREV @"CGUI-"
#define CUST_ACT_UUID_PREV  @"CACT-"
#define CUST_WORK_ITEM_UUID_PREV @"CWI-"
#define CUST_TARGET_UUID_PREV   @"CTAR-"

#define DATE_FORMATE_01 @"yyyy-MM-dd HH:mm:ss"

/* 從哪裏進入p5 */
#define GUIDE_FROM_PHEN  0  // from p1,p2
#define GUIDE_FROM_ISSUE  1 // from p8 or p22

/* NSNotification */
#define kDidSelectedPhen    @"didSelectedPhen"
#define kDidAssignManager   @"didAssignManager"
#define kDidSettingTarget   @"didSettingTarget"

#endif
