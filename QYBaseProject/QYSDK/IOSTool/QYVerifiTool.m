//
//  QYVerifiTool.m
//  IOSToolDemo
//
//  Created by 田 on 15/5/5.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYVerifiTool.h"

@implementation QYVerifiTool
int getIndex (char ch);
BOOL isNumber (char ch);

int getIndex (char ch) {
    if ((ch >= '0'&& ch <= '9')||(ch >= 'a'&& ch <= 'z')||
        (ch >= 'A' && ch <= 'Z')|| ch == '_') {
        return 0;
    }
    if (ch == '@') {
        return 1;
    }
    if (ch == '.') {
        return 2;
    }
    return -1;
}

BOOL isNumber (char ch)
{
    if (!(ch >= '0' && ch <= '9')) {
        return FALSE;
    }
    return TRUE;
}


+ (BOOL) validateEmail:(NSString *)candidate
{
    NSArray *array = [candidate componentsSeparatedByString:@"."];
    if ([array count] >= 4) {
        return FALSE;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

+ (BOOL) isValidNumber:(NSString*)value{
    const char *cvalue = [value UTF8String];
    NSInteger len = strlen(cvalue);
    for (int i = 0; i < len; i++) {
        if(!isNumber(cvalue[i])){
            return FALSE;
        }
    }
    return TRUE;
}

+ (BOOL) validPhone:(NSString*)mobileNum {
//    NSString *regex = @"[235689][0-9]{6}([0-9]{3})?";
//    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    return [test evaluateWithObject:self];
    if ([mobileNum length] == 0) {
        
        //        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"手机号码为空", nil) message:NSLocalizedString(@"请输入手机号码", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //
        //        [alert show];
        return NO;
        
    }
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,147,150,151,152,157,158,159,182,183,184,187,188
     * 联通：130,131,132,145,152,155,156,185,186
     * 电信：133,1349,153,180,181,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,147,150,151,152,157,158,159,182,183,184,187,188
     12         */
    NSString * CM = @"^1(34[0-9]|(3[5-9]|5[0127-9]|8[23478])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,145,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|4[5]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,181,189
     22         */
    NSString * CT = @"^1((33|349|53|8[019])[0-9]|349)\\d{7}$";
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
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        
        return YES;
    }
    else
    {
        //        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        //
        //        [alert show];
        
        return NO;
    }
}


+ (BOOL) isValidString:(NSString*)value
{
    return value && [value length];
}
+ (BOOL)validUrl
{
    NSString *regex =@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}
@end
