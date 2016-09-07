//
//  NSString+StringOperation.m
//  QYNSStringOperationViewController
//
//  Created by wialliams on 14-6-19.
//  Copyright (c) 2014年 QYIOS. All rights reserved.
//

#import "NSString+StringOperation.h"
//#import "QYFMDBOperation.h"
//#import "QYLocationForCall.h"

@implementation NSString (StringOperation)
//是否为空
-(BOOL)isNull{
    if ([self isEqualToString:@""]) {
        return YES;
    }
    if (self==nil) {
        return YES;
    }
    if (self==NULL) {
        return YES;
    }
    if ([self isEqualToString:@"(null)"]) {
        return YES;
    }
    return NO;
}
/**
 * @brief    判断电话号码的正确性
 * @param    
 * @return
 */
- (BOOL)isMobileNumber
{
    if ([self length] == 0) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"手机号码为空", nil) message:NSLocalizedString(@"请输入手机号码", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
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
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES))
    {
        
        return YES;
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
        return NO;
    }
}

/**
 * @brief    判断邮箱的正确性
 * @param
 * @return
 */
- (BOOL)isValidateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/**
 * @brief    判断密码的合法性
 * @param
 * @return
 */
- (BOOL)isValidatePassword
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    
    if ([passWordPredicate evaluateWithObject:self]) {
        return YES;
    }
    else
    {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"密码不合法", nil) message:NSLocalizedString(@"请重新输入密码", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return NO;
        
    }
    return NO;
}

/**
 * @brief    获得doucument下的一个路径
 * @param
 * @return
 */
- (NSString *)dataFilePath{
    NSString *filePaths=@"";
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    filePaths=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",self]];
    
    return filePaths;
}

/**
 * @brief 截取字符串 去掉字符串第一个字符或者去掉最后一个字符
 * @param
 * @return 返回截取后字符串
 */
-(NSString*)removeTheComma{
    
    if (self&&![self isEqualToString:@""]) {
        NSRange r;
        r.location = 0;
        r.length = self.length-1;
        return  [self substringWithRange:r];
        
    }
    
    return @"";
}
-(NSString*)removeTwoComma{
    if (self&&![self isEqualToString:@""]) {
        NSRange r;
        r.location = 1;
        r.length = self.length-1;
        return  [self substringWithRange:r];
        
    }
    
    return @"";
    
}

/**
 * @brief 得到string的Size
 * @param aFont  这个字符串的font
 * @param aString  需要返回大小的在字符串
 * @param maxSize  划定一个最大区域
 * @return 返回字符串的大小
 */
-(CGSize)getStringSizeForFont:(UIFont*)aFont maxSize:(CGSize)maxSize
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        CGFloat maxWidth = maxSize.width;
        CGFloat maxHeight = maxSize.height;
        CGRect stringRect = [self boundingRectWithSize:CGSizeMake(maxWidth, maxHeight)
                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesFontLeading
                                            attributes:@{ NSFontAttributeName :aFont }
                                               context:nil];

        return stringRect.size;
    }
    else
    {
       return [self sizeWithFont:aFont constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping];
    }
  
}

/**
 * @brief 处理HTML字符串中的特殊字符
 * @param
 * @return 返回截取后字符串
 */
-(NSString *)flattenHTML {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:self];
    NSString *str = @"";
    while ([theScanner isAtEnd] == NO) {
        
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        NSRange range = [text rangeOfString:@"<" options:NSBackwardsSearch];
        if (range.location != 0) {
            text = [text substringFromIndex:range.location];
        }
        
        str = [self stringByReplacingOccurrencesOfString:
                [ NSString stringWithFormat:@"%@>", text]
                                               withString:@" "];
        
    } // while //
    
    return str;
    
}

//归属地专用
- (BOOL)isMobileNumber1
{
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

-(NSString *)thePhoneForPath
{
    if ([self isEqualToString:@"(null)"] || self==nil || [self isEqualToString:@""]) {
        return @"";
    }
    
    NSString *string1 = [self stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    NSString *string2 = [string1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *string3 = [string2 stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSString *tableString = @"";
    NSString *value = @"";
    NSString *string5 = @"";
    
    if ([string3 hasPrefix:@"0"]) {
        tableString = @"tel_location";
        value = @"location";
        
        NSString *string4 = [string3 stringByReplacingOccurrencesOfString:@"0" withString:@""];
        if ([string4 hasPrefix:@"1"] || [string4 hasPrefix:@"2"]) {
            string5 = [string4 substringWithRange:NSMakeRange(1, 2)];
        }else {
            string5 = [string4 substringWithRange:NSMakeRange(1, 3)];
        }
    }else {
        tableString = @"phone_location";
        value = @"area";
        if ([string3 isMobileNumber1]) {
            string5 = [string3 substringWithRange:NSMakeRange(0, 7)];
        }else {
            return @"";
        }
        
    }
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"location" ofType:@"sqlite"];
    NSMutableArray *muArray=[[NSMutableArray alloc] init];
    NSString *sqlString=[NSString stringWithFormat:@"select *from %@ where _id= '%@'",tableString,string5];
    //NSLog(@"sqlString:%@",sqlString);
    //        通讯录集成修改
//    [QYFMDBOperation getContactsFromDb:sqlString
//                             filePaths:dbPath
//                            searchData:^(FMResultSet *contactRs) {
//                                
//                                int idValue= [contactRs intForColumn:@"_id"];
//                                NSString *area= [contactRs stringForColumn:value];
//                                
//                                QYLocationForCall *locationForCall = [[QYLocationForCall alloc] init];
//                                locationForCall._id = idValue;
//                                locationForCall.location = area;
//                                
//                                [muArray addObject:locationForCall];
//                                
//                            }];
//
//    if ([muArray count] > 0) {
//        QYLocationForCall *locationForCall = [muArray objectAtIndex:0];
//        NSString *str = [locationForCall.location stringByReplacingOccurrencesOfString:@"[" withString:@" "];
//        str = [str stringByReplacingOccurrencesOfString:@"]" withString:@" "];
//        return str;
//    }
    return @"";
}

//判断URL链接的合法性
- (BOOL)isUrlLink
{
    NSString *regex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isValid = [predicate evaluateWithObject:[self lowercaseString]];
    if (isValid) {
        return YES;
    }
    
    return NO;
}

//对URL进行编码
- (NSString *)encodeToPercentEscapeString
{
    NSString *outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                             
                                                                             NULL, /* allocator */
                                                                             
                                                                             (__bridge CFStringRef)self,
                                                                             
                                                                             NULL, /* charactersToLeaveUnescaped */
                                                                             
                                                                             (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                             
                                                                             kCFStringEncodingUTF8);
    
    
    return outputStr;
}

@end
