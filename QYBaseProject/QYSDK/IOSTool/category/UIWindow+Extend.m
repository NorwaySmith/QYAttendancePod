//
//  UIWindow+Extend.m
//  QYBaseProject
//
//  Created by 田 on 16/4/25.
//  Copyright © 2016年 田. All rights reserved.
//

#import "UIWindow+Extend.h"

@implementation UIWindow (Extend)
- (UIViewController *)visibleViewController {
  UIViewController *rootViewController = self.rootViewController;
  return [UIWindow getVisibleViewControllerFrom:rootViewController];
}

+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)vc {
  if ([vc isKindOfClass:[UINavigationController class]]) {
    return
        [UIWindow getVisibleViewControllerFrom:[((UINavigationController *)vc)
                                                   visibleViewController]];
  } else if ([vc isKindOfClass:[UITabBarController class]]) {
    return [UIWindow getVisibleViewControllerFrom:[((UITabBarController *)vc)
                                                      selectedViewController]];
  } else {
    if (vc.presentedViewController) {
      return [UIWindow getVisibleViewControllerFrom:vc.presentedViewController];
    } else {
      return vc;
    }
  }
}
@end
