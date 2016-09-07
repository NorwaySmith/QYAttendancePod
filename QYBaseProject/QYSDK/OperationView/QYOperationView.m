//
//  QYOperationView.m
//  NewAssistant
//
//  Created by wialliams on 14-4-29.
//  Copyright (c) 2014年 ZhangPengHai. All rights reserved.
//
#define wholeRowHeight 44

#import "QYOperationView.h"
#import "QYOperationTouchableView.h"
#import "QYOperationCell.h"

@interface QYOperationView()<UITableViewDataSource,UITableViewDelegate,QYOperationTouchableViewDelegate>

@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) QYOperationTouchableView *operationTouchableView;
@property (nonatomic, strong) UIView *backView;         //特殊处理，阴影
@property (nonatomic, copy) NSArray *passthroughViews;
@property (nonatomic, strong) NSMutableArray *items;    //按钮标题
@property (nonatomic, assign) NSInteger index;

@end

@implementation QYOperationView

/**
 * @brief    初始化控件
 * @param   frame 控件的坐标    index  选项卡index  0 已到  1 未到    titleArr  按钮的标题
 * @return
 */
- (id)initWithItems:(NSMutableArray *)items
{
    self = [super init];
    if (self)
    {
        self.scrollEnabled = NO;
        self.bounces = NO;
        self.items = items;
        self.dataSource = self;
        self.delegate = self;
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-126, 64, 116, wholeRowHeight * [_items count]);
        self.layer.borderColor = [UIColor colorWithRed:199/255.0 green:197/255.0 blue:204/255.0 alpha:1].CGColor;
        self.layer.borderWidth = 0.3;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 10.0;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        if ([self respondsToSelector:@selector(setSeparatorInset:)])
        {
            [self setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([self respondsToSelector:@selector(setLayoutMargins:)])
        {
            [self setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    
    return self;
}


-(void)presentPopoverInView:(UIView *)theView
{
    self.passthroughViews = [NSArray arrayWithObject:self];
	UIView *keyView = [self keyViewForView:theView];
    self.operationTouchableView = [[QYOperationTouchableView alloc] initWithFrame:keyView.bounds];
	self.operationTouchableView.contentMode = UIViewContentModeScaleToFill;
	self.operationTouchableView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth |
									   UIViewAutoresizingFlexibleHeight);
	self.operationTouchableView.backgroundColor = [UIColor clearColor];
	self.operationTouchableView.delegate = self;
	self.operationTouchableView.userInteractionEnabled = YES;
	[keyView addSubview:self.operationTouchableView];
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _backView.backgroundColor = [UIColor blackColor];
    
//    _backView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
//    _backView.layer.shadowOffset = CGSizeMake(-4,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//    _backView.layer.shadowOpacity = 0.2;//阴影透明度，默认0
//    _backView.layer.shadowRadius = 4;//阴影半径，默认3
    
    _backView.layer.shadowColor = [UIColor blackColor].CGColor;     //shadowColor阴影颜色
    _backView.layer.shadowOffset = CGSizeMake(0,0);                 //shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    _backView.layer.shadowOpacity = 0.3;                            //阴影透明度，默认0
    _backView.layer.shadowRadius = 3;                               //阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    float width = _backView.bounds.size.width;
    float height = _backView.bounds.size.height;
    float x = _backView.bounds.origin.x;
    float y = _backView.bounds.origin.y;
    float addWH = 4;
    CGPoint topLeft = _backView.bounds.origin;
    CGPoint topMiddle = CGPointMake(x+(width/2),y-addWH);
    CGPoint topRight     = CGPointMake(x+width,y);
    CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
    CGPoint bottomRight  = CGPointMake(x+width,y+height);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft   = CGPointMake(x,y+height);
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    [path moveToPoint:topLeft];
    
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];  
    //设置阴影路径  
    _backView.layer.shadowPath = path.CGPath;
    
    [keyView addSubview:_backView];
    
    [keyView addSubview:self];
    [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:self];
}

- (void)viewWasTouched:(QYOperationTouchableView *)view
{
    [self dismissPopover];
}
-(void)dismissPopover
{
    [self.operationTouchableView removeFromSuperview];
    [self.backView removeFromSuperview];
    [self removeFromSuperview];
}
- (UIView *)keyViewForView:(UIView *)theView
{
    if (self.parentView)
    {
        return self.parentView;
    }
    else
    {
        UIWindow *w = nil;
        if (theView.window)
        {
            w = theView.window;
        }
        else
        {
            w = [[UIApplication sharedApplication] keyWindow];
        }
        if (w.subviews.count > 0 && (theView == nil || [self isView:theView inSameHierarchyAsView:[w.subviews objectAtIndex:0]]))
        {
            return [w.subviews objectAtIndex:0];
        }
        else
        {
            return w;
        }
    }
}
- (BOOL)isView:(UIView *)v1 inSameHierarchyAsView:(UIView *)v2
{
    BOOL inViewHierarchy = NO;
    while (v1 != nil)
    {
        if (v1 == v2)
        {
            inViewHierarchy = YES;
            break;
        }
        v1 = v1.superview;
    }
    return inViewHierarchy;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    return [_items count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *operationCell = @"operationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:operationCell];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:operationCell];
    }
    id item = _items[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    /**
     *  后来添加的。...................
     */
    cell.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    
    if ([item isKindOfClass:[QYOperationMenu class]])
    {
        QYOperationMenu *menu = item;
        cell.textLabel.text = menu.title;
    }
    else
    {
        NSDictionary *muDic = item;
        cell.textLabel.text = muDic[@"title"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedItem)
    {
        _selectedItem((int)indexPath.row);
    }
    [self dismissPopover];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
