//
//  QYIndivCenterViewModel.m
//  QYBaseProject
//
//  Created by 田 on 15/6/9.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYIndivCenterViewModel.h"
#import "QYAccountService.h"
#import "QYIndivCenterModel.h"
#import "QYMoreNetworkApi.h"
#import "QYABIconGengerator.h"


#import <QYAddressBook/QYABDb.h>
#import <QYAddressBook/QYABUserModel.h>
//#import "QYABDb.h"
//#import "QYABUserModel.h"


@implementation QYIndivCenterViewModel

- (NSArray *)assembleData
{
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    //NSLog(@"======dzq===%@",NSHomeDirectory());
    
    //从数据库
    QYABUserModel *userModel = [QYABDb userWithUserId:account.userId];
   
//    0:女  1:男
    QYABIconGengerator *generator = [[QYABIconGengerator alloc] init];
    UIImage *headImage = [generator getHeaderIconFromName:userModel.userName];
    NSString *sex;
    if ([userModel.sex boolValue] == YES)
    {
//        headImage = [UIImage imageNamed:@"more_photoMan"];
        sex = @"男";
    }
    else
    {
//        headImage = [UIImage imageNamed:@"more_photoWom"];
        sex = @"女";
    }
    NSArray *oneSectionArray =
  @[[QYIndivCenterModel configureAvatarCellModelOfLeftString:@"头像" imageUrl:@"" defaultImage:headImage],
    [QYIndivCenterModel configureDefaultCellModelOfLeftString:@"姓名" rightString:userModel.userName],
    [QYIndivCenterModel configureDefaultCellModelOfLeftString:@"性别" rightString:sex],
     [QYIndivCenterModel configureDefaultCellModelOfLeftString:@"个性签名" rightString:userModel.signName]];
    
    NSArray *twoSectionArray =
  @[[QYIndivCenterModel configureDefaultCellModelOfLeftString:@"单位" rightString:account.companyName],
      [QYIndivCenterModel configureDefaultCellModelOfLeftString:@"部门" rightString:account.groupName],
      [QYIndivCenterModel configureDefaultCellModelOfLeftString:@"职务" rightString:userModel.job]];
    NSArray *threeSectionArray =
  @[[QYIndivCenterModel configureDefaultCellModelOfLeftString:@"手机号（登录）" rightString:userModel.phone]];
    
    return @[oneSectionArray,twoSectionArray,threeSectionArray];
}


//上传图片
-(void)uploadPhotoActionSuccess:(void (^)(NSString *alert , NSString *attachFile))success
                        failure:(void (^)(NSString *alert))failure
{
    //NSLog(@"111111111111");
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    if (!_photoImage)
    {
        [QYDialogTool showDlg:@"图片不能为空！"];
        return;
    }
    
    [QYMoreNetworkApi uploadUserPhoto:_photoImage userId:account.userId fileName:@"fileupload" success:^(NSString *responseString)
    {
        /*
        {"isDelete":"0","id":"11020220","attachName":"fileupload.png","createTime":"2015-07-03 15:36:34","attachFile":"07/03/347b87c0-dadb-42fb-9102-6a867943c4cf.png","attachSize":"1278977","compyId":"31146","createUserId":"11020220"}
         */
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&error];
        //通讯录集成修改
        //更新头像到数据库 (attachFile 头像名)
        if ([QYABDb updateSelfPhoto:[dic objectForKey:@"attachFile"]] == YES)
        {
            success(@"上传成功",[dic objectForKey:@"attachFile"]);
        }
    }
    failure:^(NSString *alert)
    {
        failure(alert);
    }];
}
-(void)uploadDone
{
   
}

//更新性别
-(void)uploadSexActionSuccess:(void (^)(NSString *alert))success
                      failure:(void (^)(NSString *alert))failure
{
    QYAccount *account = [[QYAccountService shared] defaultAccount];

    [QYMoreNetworkApi updateUserSex:_sex userId:account.userId success:^(NSString *responseString)
    {
        //更新数据库性别
        if ([QYABDb updateSelfSex:_sex] == YES)
        {
            success(@"更新成功");
        }
    }
    failure:^(NSString *alert)
    {
        failure(alert);
    }];
}

-(void)updateUserSexDone
{
    [[QYAccountService shared] setDefaultAccountSex:_sex];
}

//更新个性签名
-(void)uploadSignActionSuccess:(void (^)(NSString *alert))success
                       failure:(void (^)(NSString *alert))failure
{
    QYAccount *account = [[QYAccountService shared] defaultAccount];

    //更新请求
    [QYMoreNetworkApi updateSign:_sign userId:account.userId
                         success:^(NSString *responseString)
    {
        [self updateUserSignDone];
        //更新本地数据库个性签名
//        [[QYUpdateBasicData sharedInstance] updateIndividualitySignature:self.sign];
        
        //NSLog(@"self.sign===%@",self.sign);
        
        [QYABDb updateSelfSign:self.sign];
        success(@"更新成功");
    }
    failure:^(NSString *alert)
    {
        failure(alert);
    }];
}


-(void)updateUserSignDone
{
    [[QYAccountService shared] setDefaultAccountSign:_sign];
}


/**
 *  保证上传头像为正方形
 *
 *  @param image   上传的图片
 *  @param newSize 处理图片的大小
 *
 *  @return 处理后的图片
 */
- (UIImage *)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


@end
