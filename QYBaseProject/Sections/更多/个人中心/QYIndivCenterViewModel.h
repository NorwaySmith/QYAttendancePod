//
//  QYIndivCenterViewModel.h
//  QYBaseProject
//
//  Created by 田 on 15/6/9.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYIndivCenterViewModel : NSObject
//头像
@property(nonatomic,strong)UIImage *photoImage;
//性别，NO、女  YES、男
@property(nonatomic,assign)BOOL sex;

@property(nonatomic,strong)NSString *sign;

//组装数据
-(NSArray*)assembleData;


/**
 *  登录按钮点击事件
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)uploadPhotoActionSuccess:(void (^)(NSString *alert , NSString *attachFile))success
                        failure:(void (^)(NSString *alert))failure;
/**
 *  登录按钮点击事件
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)uploadSexActionSuccess:(void (^)(NSString *alert))success
                        failure:(void (^)(NSString *alert))failure;
/**
 *  登录按钮点击事件
 *
 *  @param success 成功回调
 *  @param failure 失败回调
 */
-(void)uploadSignActionSuccess:(void (^)(NSString *alert))success
                      failure:(void (^)(NSString *alert))failure;



/**
 *  保证上传头像为正方形
 *
 *  @param image   上传的图片
 *  @param newSize 处理图片的大小
 *
 *  @return 处理后的图片
 */
- (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;



@end
