//
//  UploadOptions.h
//
//  Created by huamulou on 15-1-13.
//  Copyright (c) 2015年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFEUploadPolicy.h"

@class TFEUploadRemoteCall;

@interface TFEUploadParameters : NSObject


/**
*  上传策略
*/
@property(nonatomic, strong) TFEUploadPolicy *policy;
//文件的路径，上传文件才有。上传流或者data无
@property(nonatomic, strong, readonly) NSString *fileLocalPath;

//系统图库的url
@property(nonatomic, strong, readonly) NSURL *assetUrl;

@property(nonatomic, strong, readonly) NSData *data;
//由tae sdk返回的url，上传成功之后有
@property(nonatomic, strong, readonly) NSString *url;

//文件在服务器上的名称，不可以重复
@property(nonatomic, readonly, strong) NSString *fileName;
//文件在服务器上的文件夹地址，不可以重复
@property(nonatomic, readonly, strong) NSString *dir;


- (instancetype)init NS_UNAVAILABLE;

+ (TFEUploadParameters *)paramsWithAssertUrl:(NSURL *)assertUrl space:(NSString *)space fileName:(NSString *)fileName dir:(NSString *)url;

+ (TFEUploadParameters *)paramsWithData:(NSData *)data space:(NSString *)space fileName:(NSString *)fileName dir:(NSString *)url;

+ (TFEUploadParameters *)paramsWithFilePath:(NSString *)filePath space:(NSString *)space fileName:(NSString *)fileName dir:(NSString *)url;

+ (TFEUploadParameters *)paramsWithAssertUrl:(NSURL *)assertUrl policy:(TFEUploadPolicy *)policy;

+ (TFEUploadParameters *)paramsWithData:(NSData *)data policy:(TFEUploadPolicy *)policy;

+ (TFEUploadParameters *)paramsWithFilePath:(NSString *)filePath policy:(TFEUploadPolicy *)policy;



/**
*
* @brief 上传策略字段 -> policy.namespace 用户空间名
*
*/
@property(nonatomic, strong) NSString *space;

/**
*
* @brief 上传策略字段 -> policy.sizeLimit 上传文件大小限制
*
*/
- (void)setSizeLimit:(int)sizeLimit;
/**
*
* @brief 上传策略字段 -> policy.remoteCall 远程回调设置
*
*/
- (void)setRemoteCall:(TFEUploadRemoteCall *)remoteCall;

/**
* @brief 上传策略字段 -> policy.insertOnly
*/
- (void)setInsertOnly:(BOOL)insertOnly;

/**
*  用户自定义的meta
*/
@property(nonatomic, strong) NSDictionary *customMetas;
/**
*  用户自定义的参数
*/
@property(nonatomic, strong) NSDictionary *customParms;

/**
*
* @brief 上传策略字段 -> policy.customPolicies
*
*  用户自定义的policy参数
*/
@property(nonatomic, strong) NSDictionary *customPolicies;

//服务端是否做md5校验
@property(nonatomic, assign) BOOL needMd5Verify;


@end
