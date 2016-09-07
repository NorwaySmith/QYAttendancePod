//
//  QYOperationView.h
//  NewAssistant
//
//  Created by wialliams on 14-4-29.
//  Copyright (c) 2014年 ZhangPengHai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYOperationMenu.h"

@interface QYOperationView : UITableView

@property (nonatomic , strong) void (^selectedItem)(int index);
/**
*  初始化menu
*
*  @param items QYOperationMenu数组
*
*  @return
*/
- (id)initWithItems:(NSMutableArray *)items;
- (void)presentPopoverInView:(UIView *)view;
//解除弹出层
-(void)dismissPopover;
@end
