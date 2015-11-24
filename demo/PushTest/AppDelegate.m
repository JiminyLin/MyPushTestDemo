//	            __    __                ________
//	| |    | |  \ \  / /  | |    | |   / _______|
//	| |____| |   \ \/ /   | |____| |  / /
//	| |____| |    \  /    | |____| |  | |   _____
//	| |    | |    /  \    | |    | |  | |  |____ |
//  | |    | |   / /\ \   | |    | |  \ \______| |
//  | |    | |  /_/  \_\  | |    | |   \_________|
//
//	Copyright (c) 2012年 HXHG. All rights reserved.
//	http://www.jpush.cn
//  Created by Zhanghao
//

#import "AppDelegate.h"
#import "JPUSHService.h"
#import "RootViewController.h"
NSString * dateString;
@implementation AppDelegate {
  RootViewController *rootViewController;
}

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.
  if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
      
      NSMutableSet *categories = [NSMutableSet set];
      
      UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
      
      category.identifier = @"identifier";
      
      UIMutableUserNotificationAction *action = [[UIMutableUserNotificationAction alloc] init];
      
      action.identifier = @"test2";
      
      action.title = @"test";
      
      action.activationMode = UIUserNotificationActivationModeBackground;
      
      action.authenticationRequired = YES;
      
      action.destructive = NO;
      
      NSArray *actions = @[ action ];
      
      [category setActions:actions forContext:UIUserNotificationActionContextMinimal];
      
      [categories addObject:category];
      //可以添加自定义categories
      [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound |
                                                        UIUserNotificationTypeAlert)
                                            categories:nil];
  } else {
      //categories 必须为nil
      [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                        UIRemoteNotificationTypeSound |
                                                        UIRemoteNotificationTypeAlert)
                                            categories:nil];
  }
    
//    [JPUSHService setupWithOption:launchOptions];

  [JPUSHService setupWithOption:launchOptions appKey:appKey
                        channel:channel apsForProduction:isProduction];

    

  [[NSBundle mainBundle] loadNibNamed:@"JpushTabBarViewController"
                                owner:self
                              options:nil];
  self.window.rootViewController = self.rootController;
  [self.window makeKeyAndVisible];
  rootViewController = (RootViewController *)
      [self.rootController.viewControllers objectAtIndex:0];

    //注册LocationManager
    _currentLoaction = [[CLLocationManager alloc] init];
    _currentLoaction.delegate = self;
#ifdef __IPHONE_8_0
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [_currentLoaction requestAlwaysAuthorization];
        NSLog(@"地理位置服务－－[UIDevice currentDevice].systemVersion floatValue] >= 8.0");
        
    }
#endif
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"您的设备的［设置］－［隐私］－［定位］已开启");
        [_currentLoaction startUpdatingLocation];//开始更新地理位置信息
    }
    else{
        NSLog(@"您的设备的［设置］－［隐私］－［定位］尚未开启");
    }
    
        [JPUSHService crashLogON];
  return YES;
}

#ifdef __IPHONE_6_0 //ios6及以上的系统，每次（切换wifi和3g）使地理位置变化，这个方法都会被调用更新此到上报地理位置的包里面（累加）当上报时间到后上报。
    - (void)locationManager:(CLLocationManager *)manager
didUpdateLocations:(NSArray *)locations {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        CLLocation *newLocation = [locations lastObject];
        float longtitude = newLocation.coordinate.longitude;
        float latitude = newLocation.coordinate.latitude;
        NSLog(@"当前获取到的地理位置信息：%@",newLocation);
              [JPUSHService setLocation:newLocation];//添加地理位置到上报包
              //[APService setLatitude:latitude longitude:longtitude];
              [manager stopUpdatingLocation];//停止地理位置上报
              NSLog(@"      >=6.0  [manager stopUpdatingLocation];");
              }
              }
#endif
              //ios6以下的系统，每次（切换wifi和3g）使地理位置变化，这个方法都会被调用更新此到上报地理位置的包里面（累加）当上报时间到后上报。
              - (void)locationManager:(CLLocationManager *)manager
              didUpdateToLocation:(CLLocation *)newLocation
              fromLocation:(CLLocation *)oldLocation {
                  if ([[UIDevice currentDevice].systemVersion floatValue] < 6.0) {
                      float longtitude = newLocation.coordinate.longitude;
                      float latitude = newLocation.coordinate.latitude;
                      NSLog(@"当前地理位置信息：%@",newLocation);
                      [JPUSHService setLocation:newLocation];//update localtion
                      [manager stopUpdatingLocation];//stop update localtion
                      NSLog(@"    <6.0    [manager stopUpdatingLocation];");
                  }
              }
              
              - (void)locationManager:(CLLocationManager *)manager
              didFailWithError:(NSError *)error{
                  //获取地理位置错误处理
              }
    
- (void)applicationWillResignActive:(UIApplication *)application {
  //    [APService stopLogPageView:@"aa"];
  // Sent when the application is about to move from active to inactive state.
  // This can occur for certain types of temporary interruptions (such as an
  // incoming phone call or SMS message) or when the user quits the application
  // and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down
  // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.

  //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];

  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [self curTime];
    NSLog(@"进入后台： %@",dateString);

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  [application setApplicationIconBadgeNumber:0];
  [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
    NSLog(@"进入前台： %@",dateString);

}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  rootViewController.deviceTokenValueLabel.text =
      [NSString stringWithFormat:@"%@", deviceToken];
  rootViewController.deviceTokenValueLabel.textColor =
      [UIColor colorWithRed:0.0 / 255
                      green:122.0 / 255
                       blue:255.0 / 255
                      alpha:1];
  NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
  [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
    didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
  NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
    didRegisterUserNotificationSettings:
        (UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
    handleActionWithIdentifier:(NSString *)identifier
          forLocalNotification:(UILocalNotification *)notification
             completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
    handleActionWithIdentifier:(NSString *)identifier
         forRemoteNotification:(NSDictionary *)userInfo
             completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo {
  [JPUSHService handleRemoteNotification:userInfo];
  NSLog(@"收到通知:%@", [self logDic:userInfo]);
  [rootViewController addNotificationCount];
}

- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo
          fetchCompletionHandler:
              (void (^)(UIBackgroundFetchResult))completionHandler {
  [JPUSHService handleRemoteNotification:userInfo];
  NSLog(@"收到通知:%@", [self logDic:userInfo]);
  [rootViewController addNotificationCount];

  completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
    didReceiveLocalNotification:(UILocalNotification *)notification {
  [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
  if (![dic count]) {
    return nil;
  }
  NSString *tempStr1 =
      [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                   withString:@"\\U"];
  NSString *tempStr2 =
      [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
  NSString *tempStr3 =
      [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
  NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
  NSString *str =
      [NSPropertyListSerialization propertyListFromData:tempData
                                       mutabilityOption:NSPropertyListImmutable
                                                 format:NULL
                                       errorDescription:NULL];
  return str;
}
-(void)curTime{
    
    NSDate *date = [NSDate date] ;
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy年MM月dd日 HH小时mm分ss秒"];
    dateString = [df stringFromDate:date];
    
}

@end
