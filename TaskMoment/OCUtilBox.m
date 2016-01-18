//
//  OCUtilBox.m
//  TaskMoment
//
//  Created by 梁浩 on 16/1/13.
//  Copyright © 2016年 LeungHowell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "OCUtilBox.h"

@implementation OCUtilBox

//@end
//@implementation NSString (md5String)

/** md5 加密 */
+ (NSString *)md5String:(NSString *)str {
    
    const char *myPasswd = [str UTF8String];
    
    unsigned char mdc[16];
    
    CC_MD5(myPasswd, (CC_LONG)strlen(myPasswd), mdc);
    
    NSMutableString *md5String = [NSMutableString string];
    
    for (int i = 0; i< 16; i++) {
        [md5String appendFormat:@"%02x",mdc[i]];
    }

    return md5String;
}
@end
