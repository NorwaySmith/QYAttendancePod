//
//  QYLaunchScreenViewController.h
//  QYBaseProject
//
//  Created by lin on 16/3/29.
//  Copyright © 2016年 田. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QYLaunchScreenUpdataType) {
    QYLaunchScreenUpdataText       = 0,        //更换闪屏的文字
    QYLaunchScreenUpdataImage      = 1,        //更换闪屏的图片
};

@class QYLaunchScreenViewController;
@protocol QYLaunchScreenViewControllerDelegate <NSObject>
@optional
/**
 *  闪屏将要出现
 */
- (void)launchScreenViewControllerViewWillAppear;
/**
 *  闪屏已经出现
 */
- (void)launchScreenViewControllerViewDidAppear;
/**
 *  闪屏将要消失
 */
- (void)launchScreenViewControllerViewWillDisappear;
/**
 *  闪屏已经消失
 */
- (void)launchScreenViewControllerViewDidDisappearWithLaunchOptions:(NSDictionary *)launchOptions;

@end

@interface QYLaunchScreenViewController : UIViewController

/**
 *  初始化更新闪屏的VC
 *
 *  @param launchOptions          配置的资源
 *  @param duration               闪屏显示的最长时间
 *  @param launchScreenUpdataType 更新的类型
 */
- (id)initWithLaunchOptions:(NSDictionary *)launchOptions
                   duration:(NSInteger)duration
     launchScreenUpdataType:(QYLaunchScreenUpdataType)launchScreenUpdataType;

@property (assign) id<QYLaunchScreenViewControllerDelegate> delegate;

@end
