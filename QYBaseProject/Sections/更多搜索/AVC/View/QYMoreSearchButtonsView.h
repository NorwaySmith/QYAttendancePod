//
//  QYMoreSearchButtonsView.h
//  QYBaseProject
//
//  Created by lin on 15/6/24.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYMoreSearchButtonsView : UIView

@property(nonatomic,copy)void (^searchButtonClick)(NSString *searchString);

@end
