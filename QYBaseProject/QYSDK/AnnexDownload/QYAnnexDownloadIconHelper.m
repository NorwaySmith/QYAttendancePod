//
//  QYAnnexDownloadIconHelper.m
//  QYBaseProject
//
//  Created by 田 on 15/8/3.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYAnnexDownloadIconHelper.h"

@implementation QYAnnexDownloadIconHelper
+(UIImage *)iconWithAnnexName:(NSString*)annexName{
    NSString *type=[[annexName pathExtension] lowercaseString];
    if ([type isEqualToString:@"xls"] || [type isEqualToString:@"xlsx"])
    {
        return [UIImage imageNamed:@"Notice_Tzgg_xls"];
    }
    else  if ([type isEqualToString:@"docx"]||[type isEqualToString:@"doc"]||[type isEqualToString:@"dot"]) {
        return [UIImage imageNamed:@"Notice_Tzgg_Word"];
    }else if ([type isEqualToString:@"txt"]||[type isEqualToString:@"text"]) {
        return [UIImage imageNamed:@"Notice_Tzgg_txt"];
    }
    else if ([type isEqualToString:@"rar"]) {
        return [UIImage imageNamed:@"Notice_Tzgg_rar"];
    }
    else if ([type isEqualToString:@"ppt"]||[type isEqualToString:@"pptx"]) {
        return [UIImage imageNamed:@"Notice_Tzgg_Ppt"];
    }
    else if ([type isEqualToString:@"png"]||[type isEqualToString:@"psd"]) {
        return [UIImage imageNamed:@"Notice_Tzgg_Png"];
    }
    else if ([type isEqualToString:@"pdf"]) {
        return [UIImage imageNamed:@"Notice_Tzgg_Pdf"];
    }
    else if ([type isEqualToString:@"jpg"]||[type isEqualToString:@"jpeg"]){
        return [UIImage imageNamed:@"Notice_Tzgg_Jpg"];
    }
    else if([type isEqualToString:@"gif"]){
        return [UIImage imageNamed:@"Notice_Tzgg_Gif"];
    }else {
        return [UIImage imageNamed:@"Notice_Tzgg_Common"];
    }
    
}

+(UIImage *)bigIconWithAnnexName:(NSString*)annexName{
    NSString *type=[[annexName pathExtension] lowercaseString];
    if ([type isEqualToString:@"xls"] || [type isEqualToString:@"xlsx"])
    {
        return [UIImage imageNamed:@"Notice_Tzgg_xls"];
    }
    else  if ([type isEqualToString:@"docx"]||[type isEqualToString:@"doc"]||[type isEqualToString:@"dot"]) {
        return [UIImage imageNamed:@"Notice_Tzgg_Word"];
    }else if ([type isEqualToString:@"txt"]||[type isEqualToString:@"text"]) {
        return [UIImage imageNamed:@"Notice_Tzgg_txt"];
    }
    else if ([type isEqualToString:@"rar"]) {
        return [UIImage imageNamed:@"Notice_Tzgg_rar"];
    }
    else if ([type isEqualToString:@"ppt"]||[type isEqualToString:@"pptx"]) {
        return [UIImage imageNamed:@"Notice_Tzgg_Ppt"];
    }
    else if ([type isEqualToString:@"png"]||[type isEqualToString:@"psd"]) {
        return [UIImage imageNamed:@"Notice_Tzgg_Png"];
    }
    else if ([type isEqualToString:@"pdf"]) {
        return [UIImage imageNamed:@"Notice_Tzgg_Pdf"];
    }
    else if ([type isEqualToString:@"jpg"]||[type isEqualToString:@"jpeg"]){
        return [UIImage imageNamed:@"Notice_Tzgg_Jpg"];
    }
    else if([type isEqualToString:@"gif"]){
        return [UIImage imageNamed:@"Notice_Tzgg_Gif"];
    }else {
        return [UIImage imageNamed:@"Notice_Tzgg_Common"];
    }
    
}
@end
