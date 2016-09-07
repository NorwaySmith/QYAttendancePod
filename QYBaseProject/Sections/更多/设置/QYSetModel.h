//
//  QYSetModel.h
//  QYBaseProject
//
//  Created by 田 on 16/1/19.
//  Copyright © 2016年 田. All rights reserved.
//
/**
 *  设置数据模型
 */
#import <Foundation/Foundation.h>

/**
 *  设置cell类型
 */
typedef NS_ENUM(NSInteger,QYSetCellType){
    /**
     *  默认cell，左侧label，右侧箭头
     */
    QYSetCellTypeDefault = 0,
    /**
     *  左侧label，右侧label
     */
    QYSetCellTypeRightLabel = 1,
    /**
     *  左侧label，右侧UISwitch
     */
    QYSetCellTypeRightSwitch = 2,

};

@interface QYSetModel : NSObject
/**
 *  cell类型
 */
@property(nonatomic,assign)QYSetCellType cellType;
/**
 *  左侧文字
 */
@property(nonatomic,copy)NSString *leftText;
/**
 *  右侧值，QYSetCellTypeDefault rightValue为空，QYSetCellTypeRightLabel rightValue为NSString，QYSetCellTypeRightSwitch rightValue为NSNumber类型的bool值
 */
@property(nonatomic,strong)id rightValue;
/**
 *  是否显示红点
 */
@property (nonatomic, assign) BOOL isShowBadge;
@end
