//
//  AppDelegate.h
//  Created by david  on 2019/7/31.
//  Copyright © 2019 NWayRtc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>
#import <NWayRtcSDK/SipEngineManager.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) Account* current_account;

@end

