//
//  QYRedDotModel.h
//  QYBaseProject
//
//  Created by 田 on 15/12/2.
//  Copyright © 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QYRedPointType) {
    QYRedPointTypeNumbers   = 0,    //数字
    QYRedPointTypeRedDot    = 1,    //红点
    QYRedPointTypeDelete    = 2
};


@interface QYRedDotModel : NSObject
/**
 *  未读数
 */
@property(nonatomic,assign)NSInteger redPointNum;
/**
 *  红点类型
 */
@property(nonatomic,assign)QYRedPointType type;
/**
 *  模块标识
 */
@property(nonatomic,copy)NSString *moduleCode;
/**
 *  父模块标识
 */
@property(nonatomic,copy)NSString *parentCode;

@end
