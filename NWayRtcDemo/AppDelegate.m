//
//  AppDelegate.m
//
//  Created by david  on 2019/7/31.
//  Copyright © 2019 NWayRtc. All rights reserved.
//

#import "AppDelegate.h"
#import <NWayRtcSDK/SipEngineManager.h>

static NSInteger seq = 0;
static NSString* registrationID_;

// 引入 JPush 功能所需头文件
# import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
# ifdef NSFoundationVersionNumber_iOS_9_x_Max
# import <UserNotifications/UserNotifications.h>
# endif

@interface AppDelegate ()<JPUSHRegisterDelegate>
   @property UIBackgroundTaskIdentifier backgroundTaskId;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"==========didFinishLaunchingWithOptions========:");
    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
      // 可以添加自定义 categories
      // NSSet<UNNotificationCategory *> *categories for iOS10 or later
      // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    [JPUSHService setupWithOption:launchOptions            appKey:@"5d8cd2482d8c16a42f809304"
        channel:@"APPLE STORE"
        apsForProduction:0
        advertisingIdentifier:nil];
    
    //NSArray* tagsList;
    //NSMutableSet* tags = [[NSMutableSet alloc] init];
    //[tags addObjectsFromArray:tagsList];
    //过滤掉无效的tag
    NSString *alias = @"1006";
    //[JPUSHService filterValidTags:tags];
    [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        
    } seq:seq];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(register:) name:UIApplicationDidBecomeActiveNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unregister:) name:UIApplicationDidEnterBackgroundNotification object:nil];

    //[JPUSHService setTags:newTags completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
      //[self inputResponseCode:iResCode content:[NSString //stringWithFormat:@"%@", iTags.allObjects] andSeq:seq];
    //} seq:seq];
    
    /*[JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        registrationID_ = registrationID;
        NSLog(@"====resCode : %d,registrationID: %@",resCode,registrationID);
        if(!self->_current_account) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                AccountConfig *accountConfig = [[AccountConfig alloc] init];
                accountConfig.username = @"1008";
                accountConfig.password = @"2345";
                accountConfig.server = @"120.24.192.241";
                accountConfig.proxy = @"120.24.192.241";
                accountConfig.trans_type = kTCP;
                accountConfig.usePushNotification = TRUE;
                accountConfig.display_name = @"1008";
                accountConfig.pn_providers = @"apns";
                accountConfig.pn_prid = @"1008";
                accountConfig.pn_param = @"default";
                
                self->_current_account = [[SipEngineManager instance] registerSipAccount:accountConfig];
                //[[SipEngineManager instance] sendMessage:@"1006" //withLocalUri:@"1005" withMessage:@"UNLOCk"];
           });
        }
    }];*/
    
    //if(!self->_current_account) {
    //}
    
    return YES;
}

- (void)register:(NSNotification *)notification
{
        //if([SipEngineManager instance]) {
        NSLog(@"AppDelegate ======= Initialize register");
        //[[SipEngineManager instance] Initialize];
        //[[SipEngineManager instance] startSipEngine];
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              AccountConfig *accountConfig = [[AccountConfig alloc] init];
              accountConfig.username = @"1004";
              accountConfig.password = @"2345";
              accountConfig.server = @"8.135.43.47";
              accountConfig.proxy = @"8.135.43.47";
              accountConfig.trans_type = kTCP;
              accountConfig.usePushNotification = NO;
              accountConfig.display_name = @"1004";
              accountConfig.pn_providers = @"apns";
              accountConfig.pn_prid = @"1004";
              accountConfig.pn_param = @"default";
              //self->_current_account = [[SipEngineManager instance] //registerSipAccount:accountConfig];
       });
    //}
}

- (void)unregister:(NSNotification *)notification
{
    if ([SipEngineManager instance]) {
        NSLog(@"AppDelegate ======= stop SipEngineManager unregister");
        //[[SipEngineManager instance] Terminate];
        //self.current_account  = nil;
    }
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  /// Required - 注册 DeviceToken
  [JPUSHService registerDeviceToken:deviceToken];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"==========applicationDidEnterBackground========:");
    if(![[SipEngineManager instance] InCalling]) {
        [[SipEngineManager instance] setNetworkReachable:NO];
    }
    self.backgroundTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        //RCLogError("[RCDevice unlisten], Forcing background stop");
        NSLog(@"backgroundTimeRemaining:%f",application.backgroundTimeRemaining);
        [self handleSignlingBackgroundTimeout];
    }];
    
    /*if(![[SipEngineManager instance] InCalling]) {
       if(self->_current_account)
       {
          [_current_account unregister];
          self->_current_account = nil;
       }
       //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [[SipEngineManager instance] stopSipEngine];
       //});
    }*/
}

- (void)handleSignlingBackgroundTimeout
{
    if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskId];
        self.backgroundTaskId = UIBackgroundTaskInvalid;
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"==========applicationWillEnterForeground========:");
    if(![[SipEngineManager instance] InCalling]) {
        [[SipEngineManager instance] Initialize];
        [[SipEngineManager instance] setNetworkReachable:YES];
        
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"==========applicationDidBecomeActive========:");
    [[SipEngineManager instance] Initialize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"becomeActive" object:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AccountConfig *accountConfig = [[AccountConfig alloc] init];
        accountConfig.username = @"1102";
        accountConfig.password = @"2345";
        accountConfig.server = @"116.205.240.196";
        accountConfig.proxy = @"116.205.240.196";
        accountConfig.trans_type = kTCP;
        accountConfig.usePushNotification = NO;
        accountConfig.display_name = @"1102";
        accountConfig.pn_providers = @"apns";
        accountConfig.pn_prid = @"1102";
        accountConfig.pn_param = @"default";
        self->_current_account = [[SipEngineManager instance] registerSipAccount:accountConfig];
   });
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    if([[SipEngineManager instance] InCalling])
    {
        [[SipEngineManager instance] hanupAllCall];
    }
}

# pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//从通知界面直接进入应用
} else {
//从通知设置界面进入应用
}
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
// Required
NSDictionary * userInfo = notification.request.content.userInfo;
NSLog(@"==========willPresentNotification========:%@", userInfo);
if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
[JPUSHService handleRemoteNotification:userInfo];
    if(_current_account != Nil)
        [_current_account refreshRegister];
    else {
        AccountConfig *accountConfig = [[AccountConfig alloc] init];
        accountConfig.username = @"1102";
        accountConfig.password = @"2345";
        accountConfig.server = @"116.205.240.196";
        accountConfig.proxy = @"116.205.240.196";
        accountConfig.trans_type = kTCP;
        accountConfig.usePushNotification = NO;
        accountConfig.display_name = @"1102";
        accountConfig.pn_providers = @"apns";
        accountConfig.pn_prid = @"1102";
        accountConfig.pn_param = @"default";
    }
}
completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
    /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AccountConfig *accountConfig = [[AccountConfig alloc] init];
        accountConfig.username = @"1008";
        accountConfig.password = @"2345";
        accountConfig.server = @"120.24.192.241";
        accountConfig.proxy = @"120.24.192.241";
        accountConfig.trans_type = kTCP;
        accountConfig.usePushNotification = TRUE;
        accountConfig.display_name = @"1008";
        accountConfig.pn_providers = @"apns";
        accountConfig.pn_prid = @"1008";
        accountConfig.pn_param = @"default";
        
        self->_current_account = [[SipEngineManager instance] registerSipAccount:accountConfig];
   });*/
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
// Required
    NSLog(@"==========didReceiveNotificationResponse========:");
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
     }
     completionHandler();    //系统要求执行这个方法
}

- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info {
    NSLog(@"==========jpushNotificationAuthorization========:");
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

     // Required, iOS 7 Support
    NSLog(@"==========didReceiveRemoteNotification====7====:");
     [JPUSHService handleRemoteNotification:userInfo];
     completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

// Required, For systems with less than or equal to iOS 6
    NSLog(@"==========didReceiveRemoteNotification===6=====:");
[JPUSHService handleRemoteNotification:userInfo];
}


@end
