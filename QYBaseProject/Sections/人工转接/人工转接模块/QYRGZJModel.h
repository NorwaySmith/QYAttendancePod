//
//  QYRGZJModel.h
//  QYBaseProject
//
//  Created by zhaotengfei on 15/6/15.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYRGZJModel : NSObject

//接口需要通过这些操作与判断给我返回一个urlString1
//if (isWenJianFuWuQi) {
//    urlString1 = PersonPhotoUrlStringYYTZ1;
//}else {
//    urlString1 = [QYJieKouOperation getJieKouOperation:@"ydzjMobile" WithUrlKey:@"headPictureView" WithLocalUrl:PhotoURLString];
//}
//
//if (isWenJianFuWuQi) {
//    [_logoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",urlString1,logoImageString]] placeholderImage:[UIImage imageNamed:@"HumanRelayWork_logo"]];
//}else {
//    [_logoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@_clientType=wap&filePath=%@",urlString1,logoImageString]] placeholderImage:[UIImage imageNamed:@"HumanRelayWork_logo"]];
//}
@property (nonatomic,strong)NSString *urlString1;//imageUrlString
@end
