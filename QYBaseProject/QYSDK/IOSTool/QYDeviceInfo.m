//
//  QYDeviceInfo.m
//  IOSToolDemo
//
//  Created by 田 on 15/5/5.
//  Copyright (c) 2015年 田. All rights reserved.
//
#define MB (1024*1024)
#define GB (MB*1024)
#import "QYDeviceInfo.h"
#import <sys/utsname.h>

@implementation QYDeviceInfo
// Model of Device
+ (NSString *)deviceModel {
    // Get the device model
    if ([[UIDevice currentDevice] respondsToSelector:@selector(model)]) {
        // Make a string for the device model
        NSString *deviceModel = [[UIDevice currentDevice] model];
        // Set the output to the device model
        return deviceModel;
    } else {
        // Device model not found
        return nil;
    }
}
// System Version
+ (CGFloat)systemVersion {
    // Get the current system version
    if ([[UIDevice currentDevice] respondsToSelector:@selector(systemVersion)]) {
        // Make a string for the system version
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        // Set the output to the system version
        return [systemVersion  floatValue];
    } else {
        // System version not found
        return -1.0;
    }
}
// Get the Screen Width (X)
+ (NSInteger)screenWidth {
    // Get the screen width
    @try {
        // Screen bounds
        CGRect Rect = [[UIScreen mainScreen] bounds];
        // Find the width (X)
        NSInteger Width = Rect.size.width;
        // Verify validity
        if (Width <= 0) {
            // Invalid Width
            return -1;
        }
        
        // Successful
        return Width;
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
}
// Get the Screen Height (Y)
+ (NSInteger)screenHeight {
    // Get the screen height
    @try {
        // Screen bounds
        CGRect Rect = [[UIScreen mainScreen] bounds];
        // Find the Height (Y)
        NSInteger Height = Rect.size.height;
        // Verify validity
        if (Height <= 0) {
            // Invalid Height
            return -1;
        }
        
        // Successful
        return Height;
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
}

// System Device Type (iPhone1,0) (Formatted = iPhone 1)
+ (NSString *)systemDeviceTypeFormatted:(BOOL)formatted {
    // Set up a Device Type String
    NSString *DeviceType;
    
    // Check if it should be formatted
    if (formatted) {
        // Formatted
        @try {
            // Set up a new Device Type String
            NSString *NewDeviceType;
            // Set up a struct
            struct utsname DT;
            // Get the system information
            uname(&DT);
            // Set the device type to the machine type
            DeviceType = [NSString stringWithFormat:@"%s", DT.machine];
            
            if ([DeviceType isEqualToString:@"i386"])
                NewDeviceType = @"iPhone Simulator";
            else if ([DeviceType isEqualToString:@"iPhone1,1"])
                NewDeviceType = @"iPhone";
            else if ([DeviceType isEqualToString:@"iPhone1,2"])
                NewDeviceType = @"iPhone 3G";
            else if ([DeviceType isEqualToString:@"iPhone2,1"])
                NewDeviceType = @"iPhone 3GS";
            else if ([DeviceType isEqualToString:@"iPhone3,1"])
                NewDeviceType = @"iPhone 4";
            else if ([DeviceType isEqualToString:@"iPhone4,1"])
                NewDeviceType = @"iPhone 4S";
            else if ([DeviceType isEqualToString:@"iPhone5,1"])
                NewDeviceType = @"iPhone 5";
            else if ([DeviceType isEqualToString:@"iPod1,1"])
                NewDeviceType = @"1st Gen iPod";
            else if ([DeviceType isEqualToString:@"iPod2,1"])
                NewDeviceType = @"2nd Gen iPod";
            else if ([DeviceType isEqualToString:@"iPod3,1"])
                NewDeviceType = @"3rd Gen iPod";
            else if ([DeviceType isEqualToString:@"iPad1,1"])
                NewDeviceType = @"iPad";
            else if ([DeviceType isEqualToString:@"iPad2,2"])
                NewDeviceType = @"iPad 2";
            else if ([DeviceType isEqualToString:@"iPad3,3"])
                NewDeviceType = @"New iPad";
            else if ([DeviceType isEqualToString:@"iPad4,4"])
                NewDeviceType = @"iPad 4";
            else if ([DeviceType hasPrefix:@"iPad"])
                NewDeviceType = @"iPad";
            
            // Return the new device type
            return NewDeviceType;
        }
        @catch (NSException *exception) {
            // Error
            return nil;
        }
    } else {
        // Unformatted
        @try {
            // Set up a struct
            struct utsname DT;
            // Get the system information
            uname(&DT);
            // Set the device type to the machine type
            DeviceType = [NSString stringWithFormat:@"%s", DT.machine];
            
            // Return the device type
            return DeviceType;
        }
        @catch (NSException *exception) {
            // Error
            return nil;
        }
    }
}

// Disk Information

// Total Disk Space
+ (NSString *)diskSpace {
    // Get the total disk space
    @try {
        // Get the long total disk space
        long long Space = [self longDiskSpace];
        
        // Check to make sure it's valid
        if (Space <= 0) {
            // Error, no disk space found
            return nil;
        }
        
        // Turn that long long into a string
        NSString *DiskSpace = [self formatMemory:Space];
        
        // Check to make sure it's valid
        if (DiskSpace == nil || DiskSpace.length <= 0) {
            // Error, diskspace not given
            return nil;
        }
        
        // Return successful
        return DiskSpace;
    }
    @catch (NSException * ex) {
        // Error
        return nil;
    }
}

// Total Free Disk Space
+ (NSString *)freeDiskSpace:(BOOL)inPercent {
    // Get the total free disk space
    @try {
        // Get the long size of free space
        long long Space = [self longFreeDiskSpace];
        
        // Check to make sure it's valid
        if (Space <= 0) {
            // Error, no disk space found
            return nil;
        }
        
        // Set up the string output variable
        NSString *DiskSpace;
        
        // If the user wants the output in percentage
        if (inPercent) {
            // Get the total amount of space
            long long TotalSpace = [self longDiskSpace];
            // Make a float to get the percent of those values
            float PercentDiskSpace = (Space * 100) / TotalSpace;
            // Check it to make sure it's okay
            if (PercentDiskSpace <= 0) {
                // Error, invalid percent
                return nil;
            }
            // Convert that float to a string
            DiskSpace = [NSString stringWithFormat:@"%.f%%", PercentDiskSpace];
        } else {
            // Turn that long long into a string
            DiskSpace = [self formatMemory:Space];
        }
        
        // Check to make sure it's valid
        if (DiskSpace == nil || DiskSpace.length <= 0) {
            // Error, diskspace not given
            return nil;
        }
        
        // Return successful
        return DiskSpace;
    }
    @catch (NSException * ex) {
        // Error
        return nil;
    }
}

// Total Used Disk Space
+ (NSString *)usedDiskSpace:(BOOL)inPercent {
    // Get the total used disk space
    @try {
        // Make a variable to hold the Used Disk Space
        long long UDS;
        // Get the long total disk space
        long long TDS = [self longDiskSpace];
        // Get the long free disk space
        long long FDS = [self longFreeDiskSpace];
        
        // Make sure they're valid
        if (TDS <= 0 || FDS <= 0) {
            // Error, invalid values
            return nil;
        }
        
        // Now subtract the free space from the total space
        UDS = TDS - FDS;
        
        // Make sure it's valid
        if (UDS <= 0) {
            // Error, invalid value
            return nil;
        }
        
        // Set up the string output variable
        NSString *UsedDiskSpace;
        
        // If the user wants the output in percentage
        if (inPercent) {
            // Make a float to get the percent of those values
            float PercentUsedDiskSpace = (UDS * 100) / TDS;
            // Check it to make sure it's okay
            if (PercentUsedDiskSpace <= 0) {
                // Error, invalid percent
                return nil;
            }
            // Convert that float to a string
            UsedDiskSpace = [NSString stringWithFormat:@"%.f%%", PercentUsedDiskSpace];
        } else {
            // Turn that long long into a string
            UsedDiskSpace = [self formatMemory:UDS];
        }
        
        // Check to make sure it's valid
        if (UsedDiskSpace == nil || UsedDiskSpace.length <= 0) {
            // Error, diskspace not given
            return nil;
        }
        
        // Return successful
        return UsedDiskSpace;
        
        // Now convert that to a string
    }
    @catch (NSException *exception) {
        // Error
        return nil;
    }
}

#pragma mark - Disk Information Long Values

// Get the total disk space in long format
+ (long long)longDiskSpace {
    // Get the long long disk space
    @try {
        // Set up variables
        long long DiskSpace = 0L;
        NSError *Error = nil;
        NSDictionary *FileAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&Error];
        
        // Get the file attributes of the home directory assuming no errors
        if (Error == nil) {
            // Get the size of the filesystem
            DiskSpace = [[FileAttributes objectForKey:NSFileSystemSize] longLongValue];
        } else {
            // Error, return nil
            return -1;
        }
        
        // Check to make sure it's a valid size
        if (DiskSpace <= 0) {
            // Invalid size
            return -1;
        }
        
        // Successful
        return DiskSpace;
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
}

// Get the total free disk space in long format
+ (long long)longFreeDiskSpace {
    // Get the long total free disk space
    @try {
        // Set up the variables
        long long FreeDiskSpace = 0L;
        NSError *Error = nil;
        NSDictionary *FileAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&Error];
        
        // Get the file attributes of the home directory assuming no errors
        if (Error == nil) {
            FreeDiskSpace = [[FileAttributes objectForKey:NSFileSystemFreeSize] longLongValue];
        } else {
            // There was an error
            return -1;
        }
        
        // Check for valid size
        if (FreeDiskSpace <= 0) {
            // Invalid size
            return -1;
        }
        
        // Successful
        return FreeDiskSpace;
    }
    @catch (NSException *exception) {
        // Error
        return -1;
    }
}

#pragma mark - Memory Value Formatting

// Format the memory to a string in GB, MB, or Bytes
+ (NSString *)formatMemory:(long long)Space {
    // Format the long long disk space
    @try {
        // Set up the string
        NSString *FormattedBytes = nil;
        
        // Get the bytes, megabytes, and gigabytes
        double NumberBytes = 1.0 * Space;
        double TotalGB = NumberBytes / GB;
        double TotalMB = NumberBytes / MB;
        
        // Display them appropriately
        if (TotalGB >= 1.0) {
            FormattedBytes = [NSString stringWithFormat:@"%.2f GB", TotalGB];
        } else if (TotalMB >= 1)
            FormattedBytes = [NSString stringWithFormat:@"%.2f MB", TotalMB];
        else {
            FormattedBytes = [self formattedMemory:Space];
            FormattedBytes = [FormattedBytes stringByAppendingString:@" bytes"];
        }
        
        // Check for errors
        if (FormattedBytes == nil || FormattedBytes.length <= 0) {
            // Error, invalid string
            return nil;
        }
        
        // Completed Successfully
        return FormattedBytes;
    }
    @catch (NSException *exception) {
        // Error
        return nil;
    }
}

// Format bytes to a string
+ (NSString *)formattedMemory:(unsigned long long)Space {
    // Format for bytes
    @try {
        // Set up the string variable
        NSString *FormattedBytes = nil;
        
        // Set up the format variable
        NSNumberFormatter *Formatter = [[NSNumberFormatter alloc] init];
        
        // Format the bytes
        [Formatter setPositiveFormat:@"###,###,###,###"];
        
        // Get the bytes
        NSNumber * theNumber = [NSNumber numberWithLongLong:Space];
        
        // Format the bytes appropriately
        FormattedBytes = [Formatter stringFromNumber:theNumber];
        
        // Check for errors
        if (FormattedBytes == nil || FormattedBytes.length <= 0) {
            // Error, invalid value
            return nil;
        }
        
        // Completed Successfully
        return FormattedBytes;
    }
    @catch (NSException *exception) {
        // Error
        return nil;
    }
}

@end
