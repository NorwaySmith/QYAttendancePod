//
//  QYLocationHelper.m
//  QYBaseProject
//
//  Created by lin on 15/11/9.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYLocationHelper.h"
#import "QYDBHelper.h"

@implementation QYLocationHelper

+ (QYLocationHelper *)shared{
    static dispatch_once_t pred;
    static QYLocationHelper *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/**
 * @brief    判断邮箱的正确性
 * @param
 * @return
 */
- (BOOL)isValidateEmailWithString:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/**
 * @brief    判断电话号码的正确性
 * @param
 * @return
 */
- (BOOL)isMobileNumberWithPhone:(NSString *)phone
{
    if ([phone length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"手机号码为空", nil) message:NSLocalizedString(@"请输入手机号码", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,147,150,151,152,157,158,159,182,183,184,187,188
     * 联通：130,131,132,145,152,155,156,185,186
     * 电信：133,1349,153,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,147,150,151,152,157,158,159,182,183,184,187,188
     12         */
    NSString *CM = @"^1(34[0-9]|(3[5-9]|5[0127-9]|8[23478])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,145,152,155,156,185,186
     17         */
    NSString *CU = @"^1(3[0-2]|4[5]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,181,189
     22         */
    NSString *CT = @"^1((33|349|53|8[019])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    
    //条件查询或过滤
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        
        return YES;
    }
    else
    {
        
        return NO;
    }
}


/**
 * @brief    获得doucument下的一个路径
 * @param
 * @return
 */
- (NSString *)dataFilePath
{
    NSString *filePaths = @"";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    filePaths = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",self]];
    
    return filePaths;
}

//归属地专用
- (BOOL)isMobileNumber1WithString:(NSString *)string
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,147,150,151,152,157,158,159,182,183,184,187,188
     * 联通：130,131,132,145,152,155,156,185,186
     * 电信：133,1349,153,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,147,150,151,152,157,158,159,182,183,184,187,188
     12         */
    NSString *CM = @"^1(34[0-9]|(3[5-9]|5[0127-9]|8[23478])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,145,152,155,156,185,186
     17         */
    NSString *CU = @"^1(3[0-2]|4[5]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,181,189
     22         */
    NSString *CT = @"^1((33|349|53|8[019])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    
    //条件查询或过滤
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:string] == YES)
        || ([regextestcm evaluateWithObject:string] == YES)
        || ([regextestct evaluateWithObject:string] == YES)
        || ([regextestcu evaluateWithObject:string] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSString *)thePhoneForPathWithPhone:(NSString *)phone
{
    if ([phone isEqualToString:@"(null)"] || phone==nil || [phone isEqualToString:@""])
    {
        return @"";
    }
    
    NSString *string1 = [phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    NSString *string2 = [string1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *string3 = [string2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *tableString = @"";
    NSString *value = @"";
    NSString *string5 = @"";
    
    if ([string3 hasPrefix:@"0"])
    {
        tableString = @"tel_location";
        value = @"location";
        
        NSString *string4 = [string3 substringFromIndex:1];
        if ([string4 hasPrefix:@"1"] || [string4 hasPrefix:@"2"]) {
            if (string4.length>=3) {
                string5 = [string4 substringWithRange:NSMakeRange(0, 2)];
            }
        }else {
            if (string4.length>=4) {
                string5 = [string4 substringWithRange:NSMakeRange(0, 3)];
            }
        }
    }
    else
    {
        tableString = @"phone_location";
        value = @"area";
        if ([self isMobileNumber1WithString:string3])
        {
            if(string3.length>=7){
                string5 = [string3 substringWithRange:NSMakeRange(0, 7)];
            }
        }
        else
        {
            return @"";
        }
    }
    
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"location" ofType:@"sqlite"];
    NSString *sqlString = [NSString stringWithFormat:@"select *from %@ where _id= '%@'",tableString,string5];
    
    NSArray *categoryArray = [[QYDBHelper shared] searchSql:sqlString dbPath:dbPath];
    
    if ([categoryArray count] > 0)
    {
        NSDictionary *locationDic = [categoryArray objectAtIndex:0];
        NSString *str = [[locationDic objectForKey:value] stringByReplacingOccurrencesOfString:@"[" withString:@" "];
        str = [str stringByReplacingOccurrencesOfString:@"]" withString:@" "];
        return str;
    }
    return @"";
}

@end
