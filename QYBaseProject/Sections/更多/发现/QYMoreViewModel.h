//
//  QYMoreViewModel.h
//  QYBaseProject
//
//  Created by 田 on 15/6/8.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol QYMoreViewModelDelegate<NSObject>
/**
 *  更多需要刷新
 */
-(void)moreViewNeedReload;
@end
@interface QYMoreViewModel : NSObject
@property(nonatomic,weak)id <QYMoreViewModelDelegate>delegate;
//是否有新版本
@property(nonatomic,assign)BOOL isHaveNewVersion;
-(NSArray*)assembleData;

@end
