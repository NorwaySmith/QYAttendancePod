//
//  QYIconGengerator.m
//  QYIconGeneration
//
//  Created by opera on 15/9/25.
//  Copyright (c) 2015年 qytx. All rights reserved.
//

#import "QYABIconGengerator.h"
#import <CommonCrypto/CommonDigest.h>

/**
 *  The path of system documents folder.
 */
#define kDocumentsFolder                    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0]
/**
 *  The path of header icon folder.
 */
#define kHeaderIconFolder                   [kDocumentsFolder stringByAppendingPathComponent:@"DefaultHeaderIcon"]
/**
 *  The format of header icon file.
 */
#define kHeaderIconFormat                   @"png"
/**
 *  The length of header icon file need to be cutted.
 */
#define kHeaderIconNameLength                   2
/**
 *  The size of header icon.
 */
#define kHeaderIconSize                     200.0f
/**
 *  The corner radius of header icon.
 */
#define kHeaderIconRaidus                   5.0f
/**
 *  The font size of header icon.
 */
#define kHeaderIconFontSize                 60.0f
/**
 *  The collection of background color can be set.
 */
#define kHeaderIconColors                   @[@"#47c1a8", @"#e3b79a", @"#3a7ea5", @"#acb0d5", @"#f79cad", @"#da557c", @"#e1c347", @"#91adb9", @"#38b7ea", @"#f26432"]

@implementation QYABIconGengerator

#pragma mark - Public Interface Implement

/**
 *  得到一个字符串的md5值
 *
 *  @param key 字符串
 *
 *  @return md5
 */
- (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = [key UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return filename;
}
/**
 *  Get header image use user name.
 *
 *  @param name user name
 *
 *  @return the header image corresponding to the user name.
 */
- (UIImage *)getHeaderIconFromName: (NSString *)name
{
    if (![self headerIconFolderExists])
    {
        [self createHeaderIconFolder];
    }
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *_name = [self substringName:name];
    NSString *filePath = [self getFilePathFromName:_name];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
        return image;
    }
    else
    {
        UIImage *image = [self generateIconFromName:_name
                                    backgroundColor:[self getColorByName:_name]
                                          textColor:[UIColor whiteColor]
                                               size:CGSizeMake(kHeaderIconSize, kHeaderIconSize)
                                             radius:kHeaderIconRaidus];
        [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
        return image;
    }
}

#pragma mark - Private Interface Implement

/**
 *  Check the header folder is empty or not.
 *
 *  @return the directory exist status.
 */
- (BOOL)headerIconFolderExists
{
    return [[NSFileManager defaultManager] fileExistsAtPath:kHeaderIconFolder];
}

/**
 *  Create the header folder in documents.
 */
- (void)createHeaderIconFolder
{
    if (![self headerIconFolderExists])
    {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:kHeaderIconFolder withIntermediateDirectories:YES attributes:nil error:&error];
    }
}

/**
 *  Get file path from user name.
 *
 *  @param name approriate name
 *
 *  @return The path corresponding to the user name.
 */
- (NSString *)getFilePathFromName: (NSString *)name
{
    if (name.length > 0)
    {
        NSString *fileNameMD5=[self cachedFileNameForKey:name];
        // generate file path from user after user name convert to pinyin
        return [[kHeaderIconFolder stringByAppendingPathComponent:fileNameMD5] stringByAppendingPathExtension:kHeaderIconFormat];
    }
    else
    {
        return nil;
    }
}

/**
 *  Get the random background color for icon.
 *  @param name appropriate name
 *  @return the random color.
 */
- (UIColor *)getColorByName: (NSString *)name
{
    NSUInteger num = 0;
    if (name != nil && name.length > 0)
    {
        for (NSUInteger i = 0; i < name.length; i++)
        {
            num += [name characterAtIndex:i];
        }
    }
    UIColor *color = [self colorWithHexString:[kHeaderIconColors objectAtIndex:(num % 10)] alpha:1.0];
    return color;
}

/**
 *  Get the appropriate name from user name.
 *
 *  @param name user name
 *
 *  @return the appropriate name.
 */
- (NSString *)substringName: (NSString *)name
{
    if (name.length > kHeaderIconNameLength)
    {
        return [name substringWithRange:NSMakeRange(name.length - kHeaderIconNameLength, kHeaderIconNameLength)];
    }
    else
    {
        return name;
    }
}

/**
 *  Generate a new header image.
 *
 *  @param name            appropriate name
 *  @param backgroundColor image background color
 *  @param textColor       image text color
 *  @param size            iamge size
 *  @param radius          image corner radius
 *
 *  @return a new header image
 */
- (UIImage *)generateIconFromName:(NSString *)name
                  backgroundColor:(UIColor *)backgroundColor
                        textColor:(UIColor *)textColor
                             size:(CGSize)size
                           radius:(CGFloat)radius
{
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = [self createRoundedRectForRect:CGRectMake(0, 0, size.width, size.height) radius:radius];
    CGContextAddPath(context, path);
    [backgroundColor setFill];
    CGContextDrawPath(context, kCGPathFill);
    
    if([name length] > 0)
    {
        UIFont *textFont = [UIFont boldSystemFontOfSize:kHeaderIconFontSize];
        CGSize textSize = [name sizeWithAttributes:@{NSFontAttributeName:textFont}];
        
        [name drawAtPoint:CGPointMake((size.width/2.0f - textSize.width/2.0f),
                                                (size.height/2.0f - textSize.height/2.0f))
           withAttributes:@{NSFontAttributeName:textFont, NSForegroundColorAttributeName: textColor}];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  Generate a header image path to draw.
 *
 *  @param rect   the maximum range to draw
 *  @param radius the corner radius to draw
 *
 *  @return the header image path.
 */
- (CGMutablePathRef)createRoundedRectForRect: (CGRect)rect
                                      radius:(CGFloat)radius
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMaxY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMinY(rect), radius);
    CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMinY(rect), radius);
    CGPathCloseSubpath(path);
    
    return path;
}

/**
 *  Convert hex string to rgb.
 *
 *  @param color hex string
 *  @param alpha color alpha
 *
 *  @return color object.
 */
- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha
{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}


/**
 *  删除所有根据名字生成的图片
 *
 *  @return 是否删除成功
 */
- (BOOL)clearDiskCaches{
    NSError *error=nil;
    BOOL success=[[NSFileManager defaultManager] removeItemAtPath:kHeaderIconFolder error:&error];
    if (success&&!error) {
        return YES;
    }
    return NO;
}
@end