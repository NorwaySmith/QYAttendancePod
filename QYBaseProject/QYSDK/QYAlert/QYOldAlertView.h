//
//  QYOldAlertView.h
//  ConferenceCall
//
//  Created by 田 on 13-5-28.
//  Copyright (c) 2013年 田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYOldAlertView : UIAlertView
{
}
@property(nonatomic,copy)void(^didSelectIndex)(int);

@end
