//
//  AppDelegate.h
//  PushTest
//
//  Created by LiDong on 12-8-15.
//  Copyright (c) 2012年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *appKey = @"98f67476b10c3bf6690559a9";//98f67476b10c3bf6690559a9
static NSString *channel = @"210-151013lingz";
static BOOL isProduction = FALSE;

#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : NSObject<UIApplicationDelegate,CLLocationManagerDelegate>{
  UILabel *_infoLabel;
  UILabel *_tokenLabel;
  UILabel *_udidLabel;
}
@property(strong, nonatomic) IBOutlet UITabBarController *rootController;
@property(nonatomic, strong) CLLocationManager *currentLoaction;
@property(retain, nonatomic) UIWindow *window;

@end
