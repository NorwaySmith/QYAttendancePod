//
//  YUDatePicker.m
//  YUDatePicker
//
//  Created by yuzhx on 15/4/26.
//  Copyright (c) 2015年 BruceYu. All rights reserved.
//

#import "YUDatePicker.h"
#import "YUToolBar.h"

#define YU_NUMBEROFROWS 16384
#define YU_ROSE_NUMBER 99
#define YU_PICKERHIGHR  216
#define YU_TOOLBARHIGHT 44

@interface YUDatePicker()<UIPickerViewDelegate,UIPickerViewDataSource,YUToolBarDelegate>
{
    UIPickerView *PickerView;
}

@property (nonatomic) NSInteger yearIndex;
@property (nonatomic) NSInteger monthIndex;
@property (nonatomic) NSInteger dayIndex;
@property (nonatomic) NSInteger hourIndex;
@property (nonatomic) NSInteger minuteIndex;
@property (nonatomic) NSInteger secondIndex;

@property (nonatomic, strong) NSArray           *amPmArray;
@property (nonatomic, strong) NSMutableArray    *yearArray;
@property (nonatomic, strong) NSMutableArray    *monthArray;
@property (nonatomic, strong) NSMutableArray    *dayArray;
@property (nonatomic, strong) NSMutableArray    *hourArray;
@property (nonatomic, strong) NSMutableArray    *minuteArray;
@property (nonatomic, strong) NSDate            *currentDate;
@property (nonatomic, strong) UIToolbar         *actionToolbar;

@property (nonatomic, strong) YUToolBar         *toolBar;

@end

@implementation YUDatePicker

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        if (self.frame.size.height < 216 || self.frame.size.width < 320)
        {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, YU_PICKERHIGHR);
        }
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 0, YU_PICKERHIGHR);
    }
    return self;
}

-(NSDate *)date {
    NSString *ds = [NSString stringWithFormat:YU_FORMATSTR,
                    self.yearArray[self.yearIndex],
                    self.monthArray[self.monthIndex],
                    self.dayArray[self.dayIndex],
                    self.hourArray[self.hourIndex],
                    self.minuteArray[self.minuteIndex]
                    ];
    NSDate *date = [NSDate dateFromString:ds withFormat:YU_FORMAT];
    return date;
}

-(NSString *)dateStr {
    NSString *ds = [NSString stringWithFormat:YU_DATESTR,
                    self.yearArray[self.yearIndex],
                    self.monthArray[self.monthIndex],
                    self.dayArray[self.dayIndex],
                    self.hourArray[self.hourIndex],
                    self.minuteArray[self.minuteIndex]
                    ];
    return ds;
}

-(NSInteger)febNumber {
    NSInteger day = [NSDate daysfromYear:[self.yearArray[self.yearIndex] integerValue] andMonth:[self.monthArray[self.monthIndex] integerValue]];
    return day;
}

-(void)setMinimumDate:(NSDate *)minimumDate {
    if (!minimumDate) {
        _minimumDate = [NSDate dateWithYea:YU_PICKER_MINDATE];
    }else{
        _minimumDate = minimumDate;
    }
}

-(void)setMaximumDate:(NSDate *)maximumDate {
    if (!_maximumDate) {
        _maximumDate = [NSDate dateWithYea:YU_PICKER_MAXDATE];
    }else{
        _maximumDate = maximumDate;
    }
}

-(NSArray *)setDays:(NSInteger)num {
    if ([_dayArray count]) {
        [_dayArray removeAllObjects];
    }
    for (int i = 1; i <= num; i++) {
        [_dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
    return _dayArray;
}

-(void)setCurrentDate:(NSDate *)currentDate {
    if (currentDate) {
        _currentDate = currentDate;
        NSDateComponents *dateComponents = [NSDate dateComponentsFromDate:_currentDate];
        self.yearIndex = dateComponents.year - YU_PICKER_MINDATE;
        self.monthIndex = dateComponents.month - 1;
        self.dayIndex = dateComponents.day - 1;
        self.hourIndex = dateComponents.hour;
        self.minuteIndex = dateComponents.minute;
        self.secondIndex = dateComponents.second;
    }
}

#pragma mark - 初始化赋值操作
-(void)initData {
    self.yearArray   = [NSMutableArray array];
    self.monthArray  = [NSMutableArray array];
    self.dayArray    = [NSMutableArray array];
    self.hourArray   = [NSMutableArray array];
    self.minuteArray = [NSMutableArray array];
    self.amPmArray = @[@"AM",@"PM"];
    
    for (int i = 0; i < YU_PICKER_MINUTE; i++) {
        NSString *num = [NSString stringWithFormat:@"%02d",i];
        if (0 < i && i <= YU_PICKER_MONTH)
            [self.monthArray addObject:num];
        if (0 < i && i <= YU_PICKER_DAY)
            [self.dayArray addObject:num];
        if (i < YU_PICKER_HOUR)
            [self.hourArray addObject:num];
        [self.minuteArray addObject:num];
    }
    
    for (int i = YU_PICKER_MINDATE; i < YU_PICKER_MAXDATE; i++) {
        NSString *num = [NSString stringWithFormat:@"%d",i];
        [self.yearArray addObject:num];
    }
    self.currentDate = _date;
}

-(void)initUI {
    if (self.datePickerMode >=  UIYUDatePickerModeDateYYYYMM ) {
        if (!PickerView) {
            PickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, YU_TOOLBARHIGHT - 22, self.frame.size.width, YU_PICKERHIGHR)];
            PickerView.showsSelectionIndicator = YES;
//            PickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            PickerView.backgroundColor = [UIColor clearColor];
            PickerView.delegate = self;
            PickerView.dataSource = self;
            [self addSubview:PickerView];
        }
        [self revertRow:_date animated:NO];
        
    }else{
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,YU_TOOLBARHIGHT - 22,self.frame.size.width,YU_PICKERHIGHR-YU_TOOLBARHIGHT)];
        datePicker.datePickerMode = (UIDatePickerMode)self.datePickerMode;
        datePicker.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        [datePicker setLocale:self.locale ? self.locale : [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        datePicker.calendar = self.calendar;
        datePicker.timeZone = self.timeZone;
        datePicker.date = _date;
        datePicker.minimumDate = self.minimumDate;
        datePicker.maximumDate = self.maximumDate;
        datePicker.minuteInterval = self.minuteInterval;
        datePicker.countDownDuration = self.countDownDuration;
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        [self addSubview:datePicker];
    }
    
    if (self.showToolbar) {
//        _actionToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, YU_TOOLBARHIGHT)];
//        _actionToolbar.barStyle = UIBarStyleDefault;
//        [_actionToolbar sizeToFit];
//        _actionToolbar.layer.borderWidth = 0.35f;
//        _actionToolbar.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
//
//        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionCancel:)];
//        
//        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    
//        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionDone:)];
//        
//        [_actionToolbar setItems:[NSArray arrayWithObjects:cancelButton,space,doneBtn, nil] animated:YES];
//        [self addSubview:_actionToolbar];
        _toolBar = [[YUToolBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, YU_TOOLBARHIGHT)];
        _toolBar.delegate = self;
        [self addSubview:_toolBar];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self initData];
    
    [self initUI];
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    if (self.datePickerMode == UIYUDatePickerModeDateYYYYMM) {
        return 2;
    }
    if (self.datePickerMode == UIYUDatePickerModeDateYYYYMMDDHHmm){
        return 5;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return YU_NUMBEROFROWS;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    switch (self.datePickerMode) {
            
        case UIYUDatePickerModeDateYYYYMM:{
            return 100;
        }
            break;
        case UIYUDatePickerModeDateYYYYMMDDHHmm:{
            if (component == 0) {
                return 75;
            }
            return 55;
        }
            break;
        
        default:
            break;
    }
    return 50;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 30;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSInteger count = 0;
    switch (self.datePickerMode) {
            
        case UIYUDatePickerModeDateYYYYMM:{
            if (component == 0) {
                self.yearIndex = row % (count = self.yearArray.count);
            }
            if (component == 1) {
                self.monthIndex = row % (count = self.monthArray.count);
//                [self setDays:self.febNumber];
//                [pickerView selectRow:self.dayIndex + self.dayArray.count * YU_ROSE_NUMBER inComponent:2 animated:NO];
            }
        }
            break;
        case UIYUDatePickerModeDateYYYYMMDDHHmm: {
            if (component == 0) {
                self.yearIndex = row % (count = self.yearArray.count);
            }
            if (component == 1) {
                self.monthIndex = row % (count = self.monthArray.count);
                [self setDays:self.febNumber];
                [pickerView selectRow:self.dayIndex + self.dayArray.count * YU_ROSE_NUMBER inComponent:2 animated:NO];
            }
            if (component == 2) {
                self.dayIndex = row % (count = self.dayArray.count);
            }
            if (component == 3) {
                self.hourIndex = row % (count = self.hourArray.count);
            }
            if (component == 4) {
                self.minuteIndex = row % (count = self.minuteArray.count);
            }
        }
            break;
            
        default:
            break;
    }
    
    //选中的时间
    [self selectDid:component];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self revertRow:self.date animated:NO];
    });
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *dateLabel = (UILabel *)view;
    if (!dateLabel) {
        dateLabel = [[UILabel alloc] init];
        dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    dateLabel.backgroundColor = [UIColor clearColor];
    [dateLabel setFont:[UIFont systemFontOfSize:22]];
    UIColor *textColor = [UIColor blackColor];
    NSString *title;
    
    switch (self.datePickerMode) {
            
        case UIYUDatePickerModeDateYYYYMM:{
            if (component == 0) {
                title = [NSString stringWithFormat:@"%@年",self.yearArray[row%self.yearArray.count]];
                textColor = [self yearColorRow:row];
            }
            if (component == 1) {
                title = [NSString stringWithFormat:@"%@月",self.monthArray[row%self.monthArray.count]];
                textColor = [self monthColorRow:row];
            }
        }
            break;
    
        case UIYUDatePickerModeDateYYYYMMDDHHmm:{
            if (component == 0) {
                title = [NSString stringWithFormat:@"%@年",self.yearArray[row%self.yearArray.count]];
                textColor = [self yearColorRow:row];
            }
            if (component == 1) {
                title = [NSString stringWithFormat:@"%@月",self.monthArray[row%self.monthArray.count]];
                textColor = [self monthColorRow:row];
            }
            if (component == 2) {
                title = [NSString stringWithFormat:@"%@日",self.dayArray[row%self.dayArray.count]];
                textColor = [self dayColorRow:row];
            }
            if (component == 3) {
                title = [NSString stringWithFormat:@"%@时",self.hourArray[row%self.hourArray.count]];
                textColor = [self hourColorRow:row];
            }
            if (component == 4) {
                title = [NSString stringWithFormat:@"%@分",self.minuteArray[row%self.minuteArray.count]];
                textColor = [self minuteColorRow:row];
            }
        }
            break;
            
        default:
            break;
    }
    dateLabel.text = title;
    dateLabel.textColor = textColor;
    return dateLabel;
}

#pragma mark -
#pragma mark - Private
- (void)selectDid:(NSInteger)component {
    
    if ([self exceedMin:self.date]) {
        [self revertRow:self.minimumDate animated:YES];
    }else if ([self exceedMax:self.date]) {
        [self revertRow:self.maximumDate animated:YES];
    }
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

-(void)revertRow:(NSDate *)date animated:(BOOL)animated {
    
    NSArray *array = [self getNowDateArry:date];
    NSInteger row = 1;
    for (int i = 0; i < array.count; i++) {
        if (i % 2) {
            [PickerView selectRow:[array[i]integerValue] + row inComponent:i/2 animated:animated];
        }else{
            row = [array[i]integerValue] * YU_ROSE_NUMBER;
        }
    }
}

- (NSArray *)getNowDateArry:(NSDate *)date {
    
    NSArray *iArray = nil;
    self.currentDate = date;
    
    if (self.datePickerMode == UIYUDatePickerModeDateYYYYMM){
        iArray = @[I2S(self.yearArray.count),I2S(self.yearIndex),
                 I2S(self.monthArray.count),I2S(self.monthIndex),];
    }
    
    if (self.datePickerMode == UIYUDatePickerModeDateYYYYMMDDHHmm){
        iArray = @[I2S(self.yearArray.count),I2S(self.yearIndex),
                 I2S(self.monthArray.count),I2S(self.monthIndex),
                 I2S(self.dayArray.count),I2S(self.dayIndex),
                 I2S(self.hourArray.count),I2S(self.hourIndex),
                 I2S(self.minuteArray.count),I2S(self.minuteIndex)];
    }
    
    iArray ? 0 :(iArray = [NSArray array]);
    return iArray;
}

-(UIColor *)rowColor:(NSDate *)date {
    
    if ([self exceedDate:date]) {
        return YU_LIGHTGRAY;
    }
    return YU_BLACK;
}

-(UIColor *)yearColorRow:(NSInteger)row {
    
    NSString *ds = [NSString stringWithFormat:YU_DATESTR,
                    self.yearArray[row % self.yearArray.count],
                    self.monthArray[self.monthIndex],
                    self.dayArray[self.dayIndex],
                    self.hourArray[self.hourIndex],
                    self.minuteArray[self.minuteIndex]
                    ];
    NSDate *date = [NSDate dateFromString:ds withFormat:YU_FORMAT];
    return [self rowColor:date];
}

-(UIColor *)monthColorRow:(NSInteger)row {
    NSString *ds = [NSString stringWithFormat:YU_DATESTR,
                    self.yearArray[self.yearIndex],
                    self.monthArray[row % self.monthArray.count],
                    self.dayArray[self.dayIndex],
                    self.hourArray[self.hourIndex],
                    self.minuteArray[self.minuteIndex]
                    ];
    NSDate *date = [NSDate dateFromString:ds withFormat:YU_FORMAT];
    return [self rowColor:date];
}

-(UIColor *)dayColorRow:(NSInteger)row {
    
    NSString *ds = [NSString stringWithFormat:YU_DATESTR,
                    self.yearArray[self.yearIndex],
                    self.monthArray[self.monthIndex],
                    self.dayArray[row % self.dayArray.count],
                    self.hourArray[self.hourIndex],
                    self.minuteArray[self.minuteIndex]
                    ];
    NSDate *date = [NSDate dateFromString:ds withFormat:YU_FORMAT];
    return [self rowColor:date];
}

-(UIColor * )hourColorRow:(NSInteger)row {
    
    NSString *ds = [NSString stringWithFormat:YU_DATESTR,
                    self.yearArray[self.yearIndex],
                    self.monthArray[self.monthIndex],
                    self.dayArray[self.dayIndex],
                    self.hourArray[row % self.hourArray.count],
                    self.minuteArray[self.minuteIndex]
                    ];
    NSDate *date = [NSDate dateFromString:ds withFormat:YU_FORMAT];
    return [self rowColor:date];
}

-(UIColor*)minuteColorRow:(NSInteger)row {
    NSString *ds = [NSString stringWithFormat:YU_DATESTR,
                    self.yearArray[self.yearIndex],
                    self.monthArray[self.monthIndex],
                    self.dayArray[self.dayIndex],
                    self.hourArray[self.hourIndex],
                    self.minuteArray[row % self.minuteArray.count]
                    ];
    NSDate *date = [NSDate dateFromString:ds withFormat:YU_FORMAT];
    return [self rowColor:date];
}

-(BOOL)exceedMin:(NSDate*)date {
    
    if ([date compare:self.minimumDate] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

-(BOOL)exceedMax:(NSDate*)date {
    
    if ([date compare:self.maximumDate] == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

-(BOOL)exceedDate:(NSDate*)date {
    
    BOOL exD = NO;
    if ([self exceedMin:date]) {
        exD = YES;
    }else{
        if ([self exceedMax:date]) {
            exD = YES;
        }
    }
    return exD;
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated {
    self.currentDate = date;
    [self revertRow:date animated:YES];
}

-(void)dateChanged:(UIDatePicker *)sender {
    self.currentDate = sender.date;
    self.date = sender.date;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


- (void)actionCancel:(id)sender {
    [self hidden];
}

- (void)actionDone:(id)sender {
    [self hidden];
    _datePickerChangeBlock(self.date);
}

#pragma mark ---  YUToolBarDelegate
- (void)cancelActionDelegate {
    [self hidden];
    _datePickerCancelBlock();
}

- (void)doneActionDelegate {
    [self hidden];
    
    _datePickerChangeBlock(self.date);
}


@end

@implementation YUDatePicker(YU)

-(void)showInView:(UIView *)view block:(dateBlock)dateBlock {
    if (self.superview) {
        [self removeFromSuperview];
    }
    
    [self setFrame:CGRectMake(0,
                              view.frame.size.height + YU_PICKERHIGHR,
                              view.frame.size.width,
                              YU_PICKERHIGHR)];
    
    [UIView animateWithDuration:0.35 animations:^{
        [self setFrame:CGRectMake(
                                  CGRectGetMinX(self.frame),
                                  CGRectGetHeight(view.frame) - YU_PICKERHIGHR,
                                  view.frame.size.width,
                                  YU_PICKERHIGHR)];
    }];
    [view addSubview:self];
    
    if (dateBlock) {
        dateBlock(self);
    }
}

-(void)Dismiss {
    [UIView animateWithDuration:0.35  animations:^ {
        [self setFrame:CGRectMake(0, 800+ self.frame.size.height, self.frame.size.width, YU_PICKERHIGHR)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)hidden {
    if (!self.superview) {
        return;
    }
    [self Dismiss];
}

@end