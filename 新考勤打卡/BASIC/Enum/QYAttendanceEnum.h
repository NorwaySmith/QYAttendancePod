//
//  QYAttendanceEnum.h
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/6.
//  Copyright © 2016年 田. All rights reserved.
//

#ifndef QYAttendanceEnum_h
#define QYAttendanceEnum_h

//签到签退的枚举类型 ;//打卡类型 ( 10上午上班签到   11下午上班签到   20上午下班签退 21下午下班签退)
typedef NS_ENUM(NSInteger,QYUSerSignState){
    QYUSerSignStateSignIn = 0,
    QYUSerSignStateSignOut = 1,
};

//详情cell的枚举类型,
typedef NS_ENUM(NSInteger,QYAttendanceDetailOnCellViewType){
    QYAttendanceDetailOnCellViewTypeHeader = 0,
    QYAttendanceDetailOnCellViewTypeCell = 1,
};

typedef NS_ENUM(NSInteger,QYAttedanceListDataType) {
    //未设置考勤方案
    QYAttedanceListDataTypeNotSetTheProgram = 0,
    
    //无打卡记录
    QYAttedanceListDataTypeNoRecord = 1,
};

/**
 *  签到时的状态 （外勤，迟到，早退）
 */
typedef NS_ENUM(NSInteger, QYSignType) {
    /**
     *  外勤
     */
     QYSignTypeOut = 0,
    /**
     *  迟到
     */
     QYSignTypeLate = 1,
    /**
     *  早退
     */
     QYSignTypeEarly = 2,
    /**
     *  早退
     */
    QYSignTypeNormal = 3,

};
/**
 *  解析地理位置坐标时的类型
 */
typedef NS_ENUM(NSInteger, QYReverseGeoCodeType) {
    /**
     *  解析头部定位
     */
    QYReverseGeoCodeTypeHeader = 0,
    /**
     *  解析打卡弹出view
     */
    QYReverseGeoCodeTypePopView =1,
};
#endif /* QYAttendanceEnum_h */
