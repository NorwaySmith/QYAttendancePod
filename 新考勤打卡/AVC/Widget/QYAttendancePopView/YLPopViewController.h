
#import <UIKit/UIKit.h>
typedef void (^block)(NSString *contentText);
@interface YLPopViewController: UIViewController
    /**
 *  内容视图
 */
@property (nonatomic,strong) UIView *contentView;
/**
 *  contentViewSize 必须设置
 *  内容视图的大小
 */
@property (nonatomic,assign) CGSize contentViewSize;
/**
 *  提示标题
 */
@property (nonatomic,strong) NSString *Title;
/**
 *  占位符
 */
@property (nonatomic,strong) NSString *placeHolder;
/**
 *  字数限制 默认无
 */
@property (nonatomic,assign) unsigned long wordCount;
/**
 *  点击确定回调的block
 */

//textview
@property (nonatomic,strong) UITextView *textView;


/**
 *  textview显示的内容
 */
@property (nonatomic, copy)NSString *textViewText;

/**
 *  地理位置
 */
@property (nonatomic, copy)NSString *location;

/**
 *  打卡时间，如果未设置，取系统当前时间，如果设置，取设置时间
 */
@property (nonatomic, copy)NSString *timeString;

@property (nonatomic,copy) block confirmBlock;

/**
 *  创建主视图后调用此方法初始化contentView
 */
- (void)addContentView;

/**
 *  此方法移除视图
 *  此方法尽量不要在 confirmBlock 内部调用，如果需要请参考如下调用方法避免循环引用

       __typeof(popView)weakPopView = popView;
        popView.confirmBlock = ^(NSString *text) {
        //NSLog(@"输入text:%@",text);
        [weakPopView hidden];
        };
 
 */
- (void)hidden;



/**
 **使用方法  注释掉的可以不实现。

 YLPopViewController *popView = [[YLPopViewController alloc] init];
 popView.contentViewSize = CGSizeMake(240, 280);
 //    popView.Title = @"这是一个标题";
 //    popView.placeHolder = @"这是一个占位符";
 //    popView.wordCount = 20;
 //必须设置完成之后调用
 [popView addContentView];

 popView.confirmBlock = ^(NSString *text) {

 //NSLog(@"输入text:%@",text);
 };
 [popView hidden];

 */



@end
