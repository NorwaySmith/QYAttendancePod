//
//  QYArtificialTransferringView.h
//  QYBaseProject
//
//  Created by dzq on 15/7/30.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYAccount.h"

@interface QYArtificialTransferringView : UIView


@property (nonatomic,strong) QYAccount *account;


@property (nonatomic,strong) UIImageView *headImgaeView;    //公司头像
@property (nonatomic,strong) UILabel *companyName;          //公司名称

@property (nonatomic,strong) UILabel *companySlogan;        //公司标语

@property (nonatomic,strong) UILabel *arrtificialTransferrNum;  //人工转接 号码

@end
