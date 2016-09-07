//
//  QYUMSocialHelper.h
//  QYBaseProject
//
//  Created by 田 on 15/6/26.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMSocial.h"

@interface QYUMSocialHelper : NSObject

+ (QYUMSocialHelper *)shared;

-(void)configUMSocial;

//-(void)umengTrack;

@end
