//
//  QYNetworkProtocol.h
//  QYBaseProject
//
//  Created by 田 on 15/6/12.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYNetworkResult.h"

@protocol QYNetworkProtocol <NSObject>

- (QYNetworkResult *)convertResultData:(NSData*)resultData
                            resultType:(NetworkResultType)resultType;
@end
