

#import "YLPopViewController.h"
#import "UITextView+YLTextView.h"
#import "QYTheme.h"
#import "Masonry.h"
@interface YLPopViewController ()<UITextViewDelegate>

//标题
@property (nonatomic,strong) UILabel *titleLabel;

//取消
@property (nonatomic,strong) UIButton *noButton;

//确定
@property (nonatomic,strong) UIButton *yesButton;

//占位字符
@property (nonatomic,strong) UILabel *placeHolderLabel;

//字数
@property (nonatomic,strong) UILabel *wordCountLabel;

//打卡时间和打卡地点上的view
@property (nonatomic,strong) UIView *grayView;

//时间 单行
@property (nonatomic,strong) UILabel *timeLabel;

//坐标 非单行
@property (nonatomic,strong) UILabel *locationLabel;

//time标示
@property (nonatomic,strong) UILabel *assignTimeLabel;

//location标示
@property (nonatomic,strong) UILabel *assignLocationLabel;

//线
@property (nonatomic,strong) UIView *lineView;
@end

@implementation YLPopViewController

#pragma mark - define

#define BTN_MARGIN_BOTOOM 10 //按钮底部边距
#define BTN_MARGIN_LR 10 //按钮左右边距
#define BTN_MARGIN_MIDDLE 20 //按钮中间边距
#define BTN_HEIGHT 35 //按钮高度

#pragma mark - 懒加载初始化

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 控件创建

#pragma mark - getter / setter
- (void)addContentView {

    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    self.contentView.center = self.view.center;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 5;
    [self.view addSubview:self.contentView];

/*
 *  底部按钮
 */
    self.noButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.noButton setTitleColor:[UIColor colorWithRed:86.0/255.0 green:183.0/255.0 blue:164.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [self.noButton setBackgroundColor:[UIColor colorWithRed:240/255. green:240/255. blue:240/255. alpha:1.]];
    self.noButton.titleLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:18];
    
    self.yesButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.yesButton setTitleColor:[UIColor colorWithRed:86.0/255.0 green:183.0/255.0 blue:164.0/255.0 alpha:1.0f] forState:UIControlStateNormal];
    [self.yesButton setBackgroundColor:[UIColor colorWithRed:240/255. green:240/255. blue:240/255. alpha:1.]];
    self.yesButton.titleLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:18];

    [self.noButton addTarget:self action:@selector(hidden:) forControlEvents:UIControlEventTouchUpInside];
    [self.yesButton addTarget:self action:@selector(touchYes:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.textViewText) {
        [self.contentView addSubview:self.noButton];
        [self.noButton setTitle:@"关闭" forState:UIControlStateNormal];
    }else{
        [self.contentView addSubview:self.noButton];
        [self.contentView addSubview:self.yesButton];
        [self.noButton setTitle:@"取消" forState:UIControlStateNormal];
        [self.yesButton setTitle:@"打卡" forState:UIControlStateNormal];
    }

    /*
     *  顶部label
     */


    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.center = self.contentView.center;
    self.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    if (self.Title) {
        self.titleLabel.text = self.Title;
    }else {
        self.titleLabel.text = @"提示";
    }

    [self.contentView addSubview:self.titleLabel];
    
    
    self.grayView = [[UIView alloc] init];
    self.grayView.backgroundColor=[UIColor colorWithRed:228.0/255.0 green:244.0/255.0 blue:240.0/255.0 alpha:1.0f];
    [self.contentView addSubview:self.grayView];
    
    _assignTimeLabel = [[UILabel alloc] init];
    _assignTimeLabel.textColor=[UIColor baseTextGreyLight];
    _assignTimeLabel.text=@"时间：";
    _assignTimeLabel.textAlignment=NSTextAlignmentRight;
    _assignTimeLabel.font=[UIFont systemFontOfSize:16.0];
    [self.grayView addSubview:_assignTimeLabel];
    
    _assignLocationLabel = [[UILabel alloc] init];
    _assignLocationLabel.textColor=[UIColor baseTextGreyLight];
    _assignLocationLabel.text=@"地点：";
    _assignLocationLabel.textAlignment=NSTextAlignmentRight;
    _assignLocationLabel.font=[UIFont systemFontOfSize:16.0];
    [self.grayView addSubview:_assignLocationLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font=[UIFont systemFontOfSize:16.0];
    _timeLabel.textColor=[UIColor blackColor];
    _timeLabel.text=@"17:21";
    [self.grayView addSubview:_timeLabel];
 
    _locationLabel = [[UILabel alloc] init];
    _locationLabel.font=[UIFont systemFontOfSize:16.0];
    _locationLabel.textColor=[UIColor blackColor];
    _locationLabel.text=@"花园路东风路交叉口向西二百米路东";
//    _locationLabel.numberOfLines=0;
    [self.grayView addSubview:_locationLabel];

    /*
     *  中间textView
     */
    self.textView = [[UITextView alloc] init];
    self.textView.font=[UIFont systemFontOfSize:16.0];
    self.textView.backgroundColor = [UIColor colorWithRed:255/255. green:255/255. blue:255/255. alpha:1.];
    self.textView.delegate = self;
    if (self.wordCount) {
        /**
         *  使用分类限制字数。此分类可以单独拿出去使用
         *  分类使用runtime完美解决字数限制。（包括难以解决的词语联想）
         */
        self.textView.limitLength = @(self.wordCount);
    }
    [self.contentView addSubview:self.textView];

    if (self.textViewText) {
        self.textView.text = self.textViewText;
        self.textView.editable=NO;
    }

    /*
     *  占位字符
     */
    self.placeHolderLabel = [[UILabel alloc] init];
    self.placeHolderLabel.hidden = NO;
    self.placeHolderLabel.font = [UIFont systemFontOfSize:15.0];
    self.placeHolderLabel.textColor = [UIColor lightGrayColor];
    [self.textView addSubview:self.placeHolderLabel];

    if (self.placeHolder) {
        self.placeHolderLabel.text = self.placeHolder;
    }else {
        self.placeHolderLabel.text = @"请在此处输入内容";
    }
    
    /*
     *  字数记录
     */
    self.wordCountLabel = [[UILabel alloc] init];

    if (self.wordCount) {
        self.wordCountLabel.text = [NSString stringWithFormat:@"0/%ld",self.wordCount];
    }else {
        self.wordCountLabel.hidden = YES;
    }
    
    //隐藏
    self.wordCountLabel.hidden = YES;

    self.wordCountLabel.font = [UIFont systemFontOfSize:14.0];
    self.wordCountLabel.textAlignment = NSTextAlignmentCenter;
    self.wordCountLabel.textColor = [UIColor lightGrayColor];
    [self.textView addSubview:self.wordCountLabel];

    if (_timeString) {
        _timeLabel.text=_timeString;
    }else{
        _timeLabel.text=[self getNowTime];
    }

    if (_location) {
        _locationLabel.text=_location;
    }
    /*
     *  出现的动画
     */

    _lineView  =[[UIView alloc] init];
    _lineView.backgroundColor=[UIColor baseTextGreyLight];
    [self.contentView addSubview:_lineView];

    [self setAnimation];
}

//出现的动画
- (void)setAnimation {
    
//    [UIView animateWithDuration:0.3 animations:^{
//        self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
//        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.view.mas_centerX);
//            make.centerY.equalTo(self.view.mas_centerY);
//            make.width.equalTo(@(self.contentViewSize.width));
//            make.height.equalTo(@(self.contentViewSize.height));
//        }];
//        
//        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.equalTo(@(10));
//            make.width.equalTo(@(self.contentViewSize.width - 20));
//            make.height.equalTo(@(60));
//        }];
//
//    } completion:^(BOOL finished) {
//        [self.grayView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@(0));
//            make.top.equalTo(self.titleLabel.mas_bottom);
//            make.width.equalTo(@(self.contentViewSize.width));
//            make.height.equalTo(@(80));
//        }];
//        
//        [self.assignTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.grayView.mas_left).offset(10);
//            make.top.equalTo(self.grayView.mas_top).offset(10);
//            make.width.equalTo(@(75));
//            make.height.equalTo(@(20));
//        }];
//        
//        [self.assignLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.grayView.mas_left).offset(10);
//            make.top.equalTo(self.assignTimeLabel.mas_bottom);
//            make.width.equalTo(@(75));
//            make.height.equalTo(@(20));
//        }];
//        
//        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_assignTimeLabel.mas_right);
//            make.top.equalTo(self.grayView.mas_top).offset(10);
//            make.width.equalTo(@(150));
//            make.height.equalTo(@(20));
//        }];
//        
//        [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_assignLocationLabel.mas_right);
//            make.top.equalTo(_assignTimeLabel.mas_bottom).offset(2);
//            make.width.equalTo(@(175));
//            make.bottom.lessThanOrEqualTo(self.grayView.mas_bottom).offset(-5);
//        }];
//
//        if (self.textViewText) {
//            [self.noButton mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.contentView.mas_left);
//                make.bottom.equalTo(self.contentView.mas_bottom);
//                make.right.equalTo(self.contentView.mas_right);
//                make.height.equalTo(@(44));
//            }];
//        }else{
//            [self.noButton mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.contentView.mas_left);
//                make.bottom.equalTo(self.contentView.mas_bottom);
//                make.right.equalTo(self.contentView.mas_centerX).offset(-1);
//                make.height.equalTo(@(44));
//            }];
//            [self.yesButton mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.contentView.mas_centerX);
//                make.bottom.equalTo(self.contentView.mas_bottom);
//                make.right.equalTo(self.contentView.mas_right);
//                make.height.equalTo(@(44));
//            }];
//
//            [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(self.noButton.mas_right);
//                make.bottom.equalTo(self.contentView.mas_bottom);
//                make.width.equalTo(@(1));
//                make.height.equalTo(@(44));
//            }];
//        }
//        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView.mas_left).offset(10);
//            make.top.equalTo(self.grayView.mas_bottom);
//            make.right.equalTo(self.contentView.mas_right).offset(-10);
//            make.bottom.equalTo(self.noButton.mas_top);
//        }];
//        [self.placeHolderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.textView.mas_left).offset(5);
//            make.top.equalTo(self.textView.mas_top).offset(5);
//            make.right.equalTo(self.textView.mas_right).offset(-5);
//            make.height.equalTo(@(20));
//        }];'=
//
//    }];
//    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, 0, self.contentViewSize.width, self.contentViewSize.height);
        self.contentView.center = self.view.center;
        self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
//    } completion:^(BOOL finished) {
        self.titleLabel.frame = CGRectMake(10, 10, self.contentViewSize.width - 20, 60);
        self.grayView.frame=CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), self.contentViewSize.width, 80);
        self.assignTimeLabel.frame=CGRectMake(12, 10, 50, 20);
        self.assignLocationLabel.frame=CGRectMake(12, CGRectGetMaxY(_assignTimeLabel.frame), 50, 20);
        self.timeLabel.frame=CGRectMake(CGRectGetMaxX(_assignTimeLabel.frame), 10, self.contentViewSize.width-70, 20);
    CGFloat height;
    if (_location.length>12) {
        height=40;
        self.locationLabel.numberOfLines=2;
        self.grayView.frame=CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), self.contentViewSize.width, 75);
        self.locationLabel.frame=CGRectMake(CGRectGetMaxX(_assignLocationLabel.frame), CGRectGetMaxY(_assignTimeLabel.frame)+1, self.contentViewSize.width-70, height);

    }else{
        height=20;
        self.locationLabel.numberOfLines=1;
        self.grayView.frame=CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), self.contentViewSize.width, 60);
        self.locationLabel.frame=CGRectMake(CGRectGetMaxX(_assignLocationLabel.frame), CGRectGetMaxY(_assignTimeLabel.frame)+1, self.contentViewSize.width-70, height);

    }
//        [self.locationLabel sizeToFit];
    
        if (self.textViewText){
            self.noButton.frame = CGRectMake(0, CGRectGetHeight(self.contentView.frame)-44, CGRectGetWidth(self.contentView.frame), 44);
         }else{
            self.noButton.frame = CGRectMake(0, CGRectGetHeight(self.contentView.frame) - 44, CGRectGetWidth(self.contentView.frame) / 2-1 , 44);
            
            self.yesButton.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) / 2 , CGRectGetHeight(self.contentView.frame) - 44, CGRectGetWidth(self.contentView.frame) / 2 , 44);
             _lineView.frame= CGRectMake(CGRectGetWidth(self.contentView.frame) / 2-0.5, CGRectGetHeight(self.contentView.frame) - 44, 0.5, 44);
        }

        self.textView.frame = CGRectMake(10, CGRectGetMaxY(_grayView.frame), self.contentViewSize.width-10*2 , self.contentViewSize.height-44-CGRectGetMaxY(_grayView.frame));

        self.placeHolderLabel.frame = CGRectMake(5, 5, CGRectGetWidth(self.textView.frame), 20);

        self.wordCountLabel.frame = CGRectMake(CGRectGetWidth(self.textView.frame) - 60, CGRectGetHeight(self.textView.frame) - 20, 60, 20);
    NSLog(@"4444");

    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
    NSLog(@"5555");

//    }];
}

#pragma mark - 消息触发事件
///键盘显示事件
- (void)keyboardWillShow:(NSNotification *)notification {

    //获取键盘高度，在不同设备上，以及中英文下是不同的

    CGFloat kbHeight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;

    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯

    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    float boudsHeight = [UIScreen mainScreen].bounds.size.height;
    //contentView底边距离键盘顶端的距离（有可能为负有可能为正）
    float margin = boudsHeight - CGRectGetMaxY(self.contentView.frame) - kbHeight;

    //将视图上移计算好的偏移
    //NSLog(@"margin - %f",margin);
    if(margin < 0) {
        [UIView animateWithDuration:duration animations:^{
            CGRect newRect = CGRectMake(CGRectGetMinX(self.contentView.frame), CGRectGetMinY(self.contentView.frame) + margin, self.contentViewSize.width, self.contentViewSize.height);
            self.contentView.frame = newRect;
        }];
    }
}

///键盘消失事件
- (void)keyboardWillHide:(NSNotification *)notify {

    // 键盘动画时间

    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //视图下沉恢复原状

    [UIView animateWithDuration:duration animations:^{

        CGRect origionRect = self.contentView.frame;
        CGRect newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y, self.contentViewSize.width, self.contentViewSize.height);
        self.contentView.frame = newRect;
        self.contentView.center = self.view.center;
    }];
}

//消失动画
- (void)hidden {
    self.textView.text = @"";
    [UIView animateWithDuration:0.3 animations:^{
//        CGRect origionRect = self.contentView.frame;
//        CGRect newRect = CGRectMake(origionRect.origin.x, origionRect.origin.y, 0, 0);
//        self.contentView.frame = newRect;
//        self.contentView.alpha = 0;
//        self.contentView.center = self.view.center;
//
//        [self.yesButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [self.noButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
//        self.noButton.frame = CGRectZero;
//        self.yesButton.frame = CGRectZero;
//        self.noButton.alpha = 0;
//        self.yesButton.alpha = 0;
//
//        [self.titleLabel removeFromSuperview];
//        [self.placeHolderLabel removeFromSuperview];
//        [self.wordCountLabel removeFromSuperview];
//        self.textView.alpha = 0;

    } completion:^(BOOL finished) {
        //删除整个视图
        [self.view removeFromSuperview];

    }];
}
#pragma mark - 点击事件
//取消
-(void)hidden:(UIButton *)button {
    //消失动画
    [self hidden];
}
//确认
- (void)touchYes:(UIButton *)button {
    [self.textView resignFirstResponder];
    __typeof (self)weakSelf = self;
    if (self.confirmBlock) {
        weakSelf.confirmBlock(weakSelf.textView.text);
    }
    [self hidden];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textView resignFirstResponder];
}

#pragma mark - 原生控件代理  TextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    self.placeHolderLabel.hidden = YES;
    if (textView.text.length == 1 && text.length == 0) {
        self.placeHolderLabel.hidden = NO;
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    self.placeHolderLabel.hidden = YES;
    if (textView.text.length == 0 ) {
        self.placeHolderLabel.hidden = NO;
    }

    if (self.wordCount) {
        NSInteger wordCount = textView.text.length;
        if (wordCount > self.wordCount) {
            wordCount = self.wordCount;
        }
        self.wordCountLabel.text = [NSString stringWithFormat:@"%ld/%lu",wordCount,self.wordCount];
    }
}

-(NSString *)getNowTime{
    
    NSDate* now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps =[calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit|NSSecondCalendarUnit) fromDate:now];
         int hour = [comps hour];
    int minute = [comps minute];
      NSString *newMinute;
    if (minute<10) {
        newMinute = [NSString stringWithFormat:@"0%d",minute];
    }else{
        newMinute = [NSString stringWithFormat:@"%d",minute];
    }
    return [NSString stringWithFormat:@"%d:%@",hour,newMinute];
    
}
@end
