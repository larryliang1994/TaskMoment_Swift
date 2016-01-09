//
// Created by huamulou on 15-1-20.
// Copyright (c) 2015 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TFEUploadOptions : NSObject


@property(nonatomic) int connectionTimeout;

//用户的自定义数据，如果设置了，可以在TFEUploadSession中获取
@property(nonatomic, strong) id userInfo;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)optionsWithUserInfo:(id)userInfo connectionTimeout:(int)connectionTimeout;

+ (instancetype)optionsWithUserInfo:(id)userInfo;




@end