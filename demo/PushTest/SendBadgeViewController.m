//
//  SendBadgeViewController.m
//  PushSDK
//
//  Created by 张庆贺 on 14-7-31.
//
//

#import "SendBadgeViewController.h"
#include "JPUSHService.h"

@interface SendBadgeViewController () {
  CGRect _frame;
}
@end

@implementation SendBadgeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  int fixLength;
#ifdef __IPHONE_7_0
  if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
    fixLength = 0;
  } else {
    fixLength = 20;
  }
#else
  fixLength = 20;
#endif
  _frame =
      CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - fixLength,
                 self.view.frame.size.width, self.view.frame.size.height);

  [_sendBadgeButton addTarget:self
                       action:@selector(onClick)
             forControlEvents:UIControlEventTouchUpInside];

  // Do any additional setup after loading the view from its nib.
}

- (IBAction)View_TouchDown:(id)sender {
  // 发送resignFirstResponder.
  [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                             to:nil
                                           from:nil
                                       forEvent:nil];
  _backgroundView.frame = _frame;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
- (void)onClick {
  NSString *stringBadge = _sendBadgeText.text;
  int value = [stringBadge intValue];
     [JPUSHService setBadge:value];
  NSLog(@"send badge:%d to jpush server", value);
    
    //crash code
//    id a = nil;
//    NSArray *test = @[@"aa",a];

}
- (IBAction)clickCompletionHandle6007:(id)sender {
    NSMutableSet *tagsSet= [NSMutableSet set];
    for (int i=0; i<101; i++) {
        [tagsSet addObject:[NSString stringWithFormat:@"BlockTag_%d", i]];
    }
    [JPUSHService setTags:tagsSet alias:(@"别名block") fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
        NSLog(@"clickCompletionHandle6007 rescode: %d, \ntags:%@, \nalias:%@\n",iResCode,iTags,iAlias);
    }];
}
- (IBAction)clickCompletionHandleTag100:(id)sender {
    NSMutableSet *tagsSet= [NSMutableSet set];
    for (int i=1; i<101; i++) {
        [tagsSet addObject:[NSString stringWithFormat:@"B100Tag_%d", i]];
    }
    [JPUSHService setTags:tagsSet alias:(@"别名block_100tag") fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
        NSLog(@"clickCompletionHandle 100个tag rescode: %d, \ntags:%@, \nalias:%@\n",iResCode,iTags,iAlias);
    }];

}
- (IBAction)clickCompletionHandle1000bTag:(id)sender {
    NSMutableSet *tagsSet= [NSMutableSet set];
    for (int i=86; i<112; i++) {
        [tagsSet addObject:[NSString stringWithFormat:@"Block1000B1234567890123456789012345a%d", i]];//tag 1001byte
    }
    [JPUSHService setTags:tagsSet alias:(@"alias_inBlock1000bTag") fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
        NSLog(@"clickCompletionHandle 1000字节Tag rescode: %d, \ntags:%@, \nalias:%@\n",iResCode,iTags,iAlias);
    }];

}

- (IBAction)clickCompletionHandle6008:(id)sender {
    NSMutableSet *tagsSet= [NSMutableSet set];
    for (int i=87; i<113; i++) {
        [tagsSet addObject:[NSString stringWithFormat:@"Block6008_1234567890123456789012345a%d", i]];//tag 1001byte
    }
    [JPUSHService setTags:tagsSet alias:(@"alias_inBlock") fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
        NSLog(@"clickCompletionHandle 6008 1000b  rescode: %d, \ntags:%@, \nalias:%@\n",iResCode,iTags,iAlias);
    }];
}

- (IBAction)clickInBackground6007:(id)sender {
    NSMutableSet *tagsSet= [NSMutableSet set];
    for (int i=0; i<101; i++) {
        [tagsSet addObject:[NSString stringWithFormat:@"bacKtag_%d", i]];
    }
    [JPUSHService setTags:tagsSet aliasInbackground:@"alias_inBackgroud"];
}
- (IBAction)clickInBackgroud100tag:(id)sender {
    NSMutableSet *tagsSet= [NSMutableSet set];
    for (int i=1; i<101; i++) {
        [tagsSet addObject:[NSString stringWithFormat:@"b100tag_%d", i]];
    }
    [JPUSHService setTags:tagsSet aliasInbackground:@"alias_inBackgroudTag100"];
}
- (IBAction)clickInBackground1000b:(id)sender {
    NSMutableSet *tagsSet= [NSMutableSet set];
    for (int i=86; i<112; i++) {
        [tagsSet addObject:[NSString stringWithFormat:@"back_1000b1234567890123456789012345a%d", i]];
    }
    
    [JPUSHService setTags:tagsSet aliasInbackground:@"back567890123456789012345678901tag_1000b"];
}

- (IBAction)clickInBackground6008:(id)sender {
    NSMutableSet *tagsSet= [NSMutableSet set];
    for (int i=87; i<113; i++) {
        [tagsSet addObject:[NSString stringWithFormat:@"back6008_01234567890123456789012345a%d", i]];
    }

    [JPUSHService setTags:tagsSet aliasInbackground:@"back5678901234567890123456789012345_6008"];
}
- (IBAction)clickNor6007:(id)sender {
    NSMutableSet *tagsSet= [NSMutableSet set];
    for (int i=0; i<101; i++) {
        [tagsSet addObject:[NSString stringWithFormat:@"NorTag_%d", i]];
    }
    [JPUSHService setTags:tagsSet alias:@"alias_Nor6007" callbackSelector:@selector(tagsAliasCallback: tags: alias:) target:self];
}
- (IBAction)clickNor100tag:(id)sender {
    NSMutableSet *tagsSet= [NSMutableSet set];
    for (int i=1; i<101; i++) {
        [tagsSet addObject:[NSString stringWithFormat:@"N100Tag%d", i]];
    }
    [JPUSHService setTags:tagsSet alias:@"alias_Nor100tag" callbackSelector:@selector(tagsAliasCallback: tags: alias:) target:self];

}
- (IBAction)clickNorTag1000b:(id)sender {
    NSMutableSet *tagsSet= [NSMutableSet set];
    for (int i=86; i<112; i++) {
        [tagsSet addObject:[NSString stringWithFormat:@"clickNor1000_4567890123456789012345a%d", i]];
    }
    [JPUSHService setTags:tagsSet alias:@"alias_NorTag1000b" callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
}

- (IBAction)clickNor6008:(id)sender {
    NSMutableSet *tagsSet= [NSMutableSet set];
    for (int i=87; i<113; i++) {
        [tagsSet addObject:[NSString stringWithFormat:@"clickNor6008_4567890123456789012345a%d", i]];
    }
    [JPUSHService setTags:tagsSet alias:@"alias_Nor6008" callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
}
//callback
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"普通接口 rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


@end
