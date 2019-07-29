//
//  CXTools.h
//  BaseAppV2
//
//  Created by LITi on 2018/11/30.
//  Copyright © 2018 Dawnpro. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXTools : NSObject

#pragma mark - 

/**
 *  检测字符串是否为空串
 *
 *  @param string 要检测的字符串
 *
 *  @return YES 为空串，NO 非空串
 */
+ (BOOL)isBlankString:(NSString *)string;

// 验证手机号
+ (BOOL)validateMobile:(NSString *)mobileNum;

// 验证邮箱
+ (BOOL) validateEmail:(NSString *)email;

// 验证身份证
+ (BOOL) validateCard:(NSString *)card;

#pragma mark -
//简单的警告框封装
+ (void)showAlertTitle:(NSString*)title message:(NSString*)message sure:(NSString*)sure cancel:(NSString*)cancel blockSure:(void(^)(UIAlertAction * _Nonnull action))blockSure blockCancel:(void(^)(UIAlertAction * _Nonnull action))blockCancel;
#pragma mark -
+ (NSString *)UrlEncodedString:(NSString *)sourceText;


#pragma mark -

// 获取App的全部版本信息，App版本，基座版本，门户版本，能力列表版本
+ (NSDictionary *)getAppVersionInfo;

//将大小转化为格式,B,L,M,G之间的转换
+ (NSString *)convertFloatSizeToString:(float)size;

#pragma mark -
// 将时间转化为昨天/刚刚等样式提示
+ (NSString *)convertTime2FriendlyPrompt:(NSTimeInterval)time;
//将时间以给定的样式展示
+ (NSString*)stringFromTime:(NSTimeInterval)time withFormatter:(NSString*)formatter;

// 截屏并保存到系统相册
+ (void)snapshotScreenWithView:(UIView *)sView completeHandler:(void(^)(BOOL success, NSString *msg, UIImage* img, NSString* imageID))handler;

// 根据图片ID从相册获取图片
+ (void)getImageFromPhotosAlbumWithID:(NSString *)imgID completeHandler:(void(^)(BOOL success, UIImage* img))handle;

#pragma mark -
//拨打电话
+ (void)callPhoneNumber:(NSString*)tel;


/**
 把带方向的UIImage旋转并重置方向信息
 */
+ (UIImage*)fixOrientation:(UIImage*)aImage;


@end

NS_ASSUME_NONNULL_END
