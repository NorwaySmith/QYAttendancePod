//
//  QYPhotoPickerHelper.h
//  QYBaseProject
//
//  Created by 田 on 15/8/6.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYPhotoPickerHelper : NSObject
+ (QYPhotoPickerHelper *)shared;


/*!
 * @brief 选择图片或者拍照完成选择使用拍照的图片后，会调用此block
 * @param image 选择的图片或者拍照后选择使用的图片
 */
typedef void (^QYPickerCompelitionBlock)(UIImage *image);
/*!
 * @brief 用户点击取消时的回调block
 */
typedef void (^QYPickerCancelBlock)();

/*!
 * @brief 此方法为调起选择图片或者拍照的入口，当选择图片或者拍照后选择使用图片后，回调completion，
 *        当用户点击取消后，回调cancelBlock
 * @param inView UIActionSheet呈现到inView这个视图上
 * @param fromController 用于呈现UIImagePickerController的控制器
 * @param completion 当选择图片或者拍照后选择使用图片后，回调completion
 * @param cancelBlock 当用户点击取消后，回调cancelBlock
 */
- (void)showActionSheetInView:(UIView *)inView
               fromController:(UIViewController *)fromController
                   completion:(QYPickerCompelitionBlock)completion
                  cancelBlock:(QYPickerCancelBlock)cancelBlock;
@end
