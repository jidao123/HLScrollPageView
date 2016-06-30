//
//  GuoHeadVideoSDKError.h
//  GuoHeadSDKProject-master
//
//  Created by 刘园园 on 2/16/16.
//  Copyright © 2016 keith.liu. All rights reserved.
//

#ifndef GuoHeadVideoSDKError_h
#define GuoHeadVideoSDKError_h


typedef NS_ENUM(NSUInteger, GuoHeadErrorCode) {
    GuoHeadErrorCode_NetworkError = 2001, // 客户端请求网络问题
    GuoHeadErrorCode_DataException,       // 请求数据异常问题
    GuoHeadErrorCode_IOError,             // 客户端文件读写问题
};


#endif /* GuoHeadVideoSDKError_h */
