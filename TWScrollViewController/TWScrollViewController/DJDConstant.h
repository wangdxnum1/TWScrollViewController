//
//  DJDConstant.h
//  DjdApp
//
//  Created by HaKim on 16/2/29.
//  Copyright © 2016年 haKim. All rights reserved.
//

#ifndef DJDConstant_h
#define DJDConstant_h

//device
#define iPhone4 ([UIScreen mainScreen].bounds.size.height == 480)
#define iPhone5 ([UIScreen mainScreen].bounds.size.height == 568)
#define iPhone6 ([UIScreen mainScreen].bounds.size.height == 667)
#define iPhone6p ([UIScreen mainScreen].bounds.size.height > 667)

//------------------------------------系统版本-------------------------------------------
#define IOS_VERSION          [[[UIDevice currentDevice] systemVersion] floatValue]

#define IS_IOS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IS_IOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_IOS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_IOS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_IOS_7_OR_PREVIOUS ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)

//device screen size
#define kScreenWidth               [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight              [[UIScreen mainScreen] bounds].size.height
#define kIphone5Height              (568)

#define kStandWidth                (375.0)
#define kStandHeight               (667.0)

#define kTabBarHeight              (49.0)
#define kNavigationBarHeight       (64.0)

#define WeakSelf(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define kOnePixLine         (1.0/[UIScreen mainScreen].scale)

#define kDJDAuthReturnUrl        @"objcdjd://AuthCallback"

#define AppVersion  [DJDCommonUtils getCurrentAppVersion]

#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define DLog(...);
#endif

#endif /* DJDConstant_h */
