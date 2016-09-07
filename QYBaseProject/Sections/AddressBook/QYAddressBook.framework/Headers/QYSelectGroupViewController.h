//
//  QYSelectGroupViewController.h
//  QYBaseProject
//
//  Created by zhaotengfei on 15/8/19.
//  Copyright (c) 2015年 田. All rights reserved.
//
/**
 *  选择群组
 */
#import "QYViewController.h"
@interface QYSelectGroupViewController : QYViewController
/**
 *  弹出选择群组
 *
 *  @param array 默认选中的群组，可以为NSString类型的，也可以为QYABGroupModel类型
 *  @param isSigle 单选多选 yes单选，no多选
 *  @param finishSelectArray 完成选择时选择的数组，成员为QYABGroupModel类型
 *  @return
 */

-(instancetype)initWithSelectGropuArray:(NSArray *)array
                         inSingleChoose:(BOOL)isSigle
                     finishSelectArrays:(void (^)(NSArray *finishSelectArray))finish
                           cancelSelect:(void(^)(NSString *))cancel;

@end
