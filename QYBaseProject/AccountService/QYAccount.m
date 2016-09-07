//
//  QYAccount.m
//  QYBaseProject
//
//  Created by 田 on 15/6/3.
//  Copyright (c) 2015年 田. All rights reserved.
//
#import "QYAccount.h"

#import <objc/runtime.h>
/*
@implementation QYModuleRoleMap
//+(JSONKeyMapper*)keyMapper
//{
//    //uOpen,
//    //cOpen,
//    //groups,
//    //menu
//    return [[JSONKeyMapper alloc] initWithDictionary:@{@"uOpen":@NO,@"cOpen":@NO,@"groups":@"",@"menu":@NO}];
//}
- (void)encodeWithCoder:(NSCoder*)coder
{
    Class clazz = [self class];
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    
    
    for (NSString *name in propertyArray)
    {
        id value = [self valueForKey:name];
        [coder encodeObject:value forKey:name];
    }
}

- (id)initWithCoder:(NSCoder*)decoder
{
    
    
    if (self = [super init])
    {
        if (decoder == nil)
        {
            return self;
        }
        
        Class clazz = [self class];
        u_int count;
        
        objc_property_t* properties = class_copyPropertyList(clazz, &count);
        NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count ; i++)
        {
            const char* propertyName = property_getName(properties[i]);
            [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        }
        free(properties);
        
        
        for (NSString *name in propertyArray)
        {
            id value = [decoder decodeObjectForKey:name];
            [self setValue:value forKey:name];
        }
    }
    return self;
}
@end
 */
/*
@implementation QYUserRoleMap
- (void)encodeWithCoder:(NSCoder*)coder
{
    Class clazz = [self class];
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    
    
    for (NSString *name in propertyArray)
    {
        id value = [self valueForKey:name];
        [coder encodeObject:value forKey:name];
    }
}

- (id)initWithCoder:(NSCoder*)decoder
{
    
    
    if (self = [super init])
    {
        if (decoder == nil)
        {
            return self;
        }
        
        Class clazz = [self class];
        u_int count;
        
        objc_property_t* properties = class_copyPropertyList(clazz, &count);
        NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count ; i++)
        {
            const char* propertyName = property_getName(properties[i]);
            [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        }
        free(properties);
        
        
        for (NSString *name in propertyArray)
        {
            id value = [decoder decodeObjectForKey:name];
            [self setValue:value forKey:name];
        }
    }
    return self;
}
@end
 */
@implementation QYAccount
- (void)encodeWithCoder:(NSCoder*)coder
{
    Class clazz = [self class];
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    
    
    for (NSString *name in propertyArray)
    {
        id value = [self valueForKey:name];
        [coder encodeObject:value forKey:name];
    }
}

- (id)initWithCoder:(NSCoder*)decoder
{
    
    
    if (self = [super init])
    {
        if (decoder == nil)
        {
            return self;
        }
        
        Class clazz = [self class];
        u_int count;
        
        objc_property_t* properties = class_copyPropertyList(clazz, &count);
        NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i < count ; i++)
        {
            const char* propertyName = property_getName(properties[i]);
            [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        }
        free(properties);
        
        
        for (NSString *name in propertyArray)
        {
            id value = [decoder decodeObjectForKey:name];
            [self setValue:value forKey:name];
        }
    }
    return self;
}
@end
