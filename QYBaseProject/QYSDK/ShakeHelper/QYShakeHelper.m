//
//  QYShakeHelper.m
//  QYBaseProject
//
//  Created by 田 on 15/12/22.
//  Copyright © 2015年 田. All rights reserved.
//

#import "QYShakeHelper.h"
#import "AudioToolbox/AudioToolbox.h"
#import <QYDIDIReminCBB/QYDiDiShakeViewController.h>
#import "QYAccountService.h"
#import "QYNavigationViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "QYShakeView.h"
#import "QYAccountService.h"

//保存摇一摇状态的key
#define ShakeOpenOrCloseKey(userId) [NSString stringWithFormat:@"shakeOpenOrCloseKey_%@",userId]

/**
 *  摇一摇类型
 */
typedef NS_ENUM(NSInteger,QYShakeType) {
    //摇嘀嘀
    QYShakeTypeDidi = 0,
};

@interface QYShakeHelper()

/**
 *  摇一摇类型
 */
@property(nonatomic,assign)QYShakeType shakeType;

/**
 * 是否播放声音
 */
@property(nonatomic,assign)BOOL isPlaySound;

/**
 *  响应摇一摇事件的view
 */
@property(nonatomic,strong)QYShakeView *shakeView;

/**
 *  是否关闭响应摇一摇事件
 */
@property(nonatomic,assign)BOOL isCloseShake;

@end


@implementation QYShakeHelper

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  单例
 *
 *  @return QYShakeHelper对象
 */
+ (QYShakeHelper *)shared
{
    static dispatch_once_t pred;
    static QYShakeHelper *sharedInstance = nil;
    dispatch_once(&pred, ^ {
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/**
 *  初始化震动
 */
-(void)initShake {
    self.shakeView = [[QYShakeView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:_shakeView];
    [_shakeView becomeFirstResponder];
    
    //监听textField监听事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
   
    
    //监听textView结束编辑事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidEndEditingNotification) name:UITextViewTextDidEndEditingNotification object:nil];
}
/**
 *  检测所有textField将要取消第一响应
 */
-(void)textFieldTextDidEndEditing:(id)sender {
    [self becomeFirstResponder];
}


/**
 *  检测所有textView将要取消第一响应
 */
-(void)textViewTextDidEndEditingNotification {
    [self becomeFirstResponder];
}

/**
 *  关闭摇一摇
 */
-(void)closeShake {
    _isCloseShake = YES;
    QYAccount *account =[[QYAccountService shared] defaultAccount];
    [[NSUserDefaults standardUserDefaults] setBool:_isCloseShake forKey:ShakeOpenOrCloseKey(account.userId)];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  开启摇一摇
 */
-(void)openShake {
    _isCloseShake = NO;
    QYAccount *account = [[QYAccountService shared] defaultAccount];

    [[NSUserDefaults standardUserDefaults] setBool:_isCloseShake forKey:ShakeOpenOrCloseKey(account.userId)];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  当前是否关闭摇一摇
 */
-(BOOL)isCloseShake {
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    BOOL isCloseShake = [[NSUserDefaults standardUserDefaults] boolForKey:ShakeOpenOrCloseKey(account.userId)];
    _isCloseShake = isCloseShake;
    return isCloseShake;
}

/**
 *  摇一摇view变为第一响应
 */
-(void)becomeFirstResponder {
    [_shakeView becomeFirstResponder];
}

/**
 *  开始晃动
 */
-(void)motionBegan {
    if (!_isCloseShake) {
         _isPlaySound=YES;
    }
}

/**
 *  取消晃动
 */
-(void)motionCancelled {
    
}

/**
 *  晃动结束
 */
-(void)motionEnded {
    if (!_isCloseShake) {
        [self dealWithMotion];
        _isPlaySound = NO;
    }
}

/**
 *  晃动后需要处理的类型
 *
 *  @return 晃动类型
 */
-(QYShakeType)shakeType {
    return QYShakeTypeDidi;
}

/**
 *  处理晃动
 */
-(void)dealWithMotion {
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    UIViewController *rootViewController = [self appRootViewController];
    if (!account) {
        return;
    }
    //判断当前显示的是否摇一摇
    if ([rootViewController isKindOfClass:[QYNavigationViewController class]]) {
        QYNavigationViewController *navViewController = (QYNavigationViewController*)rootViewController;
        if ([navViewController.viewControllers[0] isKindOfClass:[QYDiDiShakeViewController class]]) {
            return;
        }
    }
    if (_isPlaySound) {
        [self playShake];
    }
    switch (self.shakeType) {
        case QYShakeTypeDidi:
        {
            QYDiDiShakeViewController *shakeDiDiViewController=[[QYDiDiShakeViewController alloc] init];
            shakeDiDiViewController.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
            QYNavigationViewController *navViewController=[[QYNavigationViewController alloc] initWithRootViewController:shakeDiDiViewController];
            
            [rootViewController presentViewController:navViewController animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

/**
 *  得到当前显示的ViewController
 *
 *  @return 当前显示的ViewController
 */
- (UIViewController *)appRootViewController {
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

/**
 *  手机震动
 */
-(void)playShake {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    //    SystemSoundID soundID = [self loadSound:@"shake_sound_male.wav"];
    //    /*开始播放*/
    //    AudioServicesPlaySystemSound(soundID);
    //    CFRunLoopRun();
}

/**
 *  加载音效
 *
 *  @param soundFileName 声音文件名
 *
 *  @return SystemSoundID
 */
- (SystemSoundID)loadSound:(NSString *)soundFileName
{
    // 1. 需要指定声音的文件路径，这个方法需要加载不同的音效
    NSString *path = [[NSBundle mainBundle]pathForResource:soundFileName ofType:nil];
    // 2. 将路径字符串转换成url
    NSURL *url = [NSURL fileURLWithPath:path];
    
    // 3. 初始化音效
    // 3.1 url => CFURLRef
    // 3.2 SystemSoundID
    SystemSoundID soundId;
    // url先写个错的，然后让xcode帮我们智能修订，这里的方法不要硬记！
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundId);
    
    return soundId;
}


@end
