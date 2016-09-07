//
//  QYApplicationCell.h
//  QYBaseProject
//
//  Created by 田 on 15/6/13.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYApplicationModel.h"


@protocol QYApplicationCellDelegate <NSObject>


@optional
- (void)collectionViewCellAction:(long)cellIndex;


@required


@end



@interface QYApplicationCell : UICollectionViewCell


@property (nonatomic,assign) id<QYApplicationCellDelegate>delegae;


@property (nonatomic,strong) QYApplicationModel *applicationModel;

@property (nonatomic,assign) long itemIndex;

@property (nonatomic,assign) long modelCount;

@end
