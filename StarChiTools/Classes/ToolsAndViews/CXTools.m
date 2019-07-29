//
//  CXTools.m
//  BaseAppV2
//
//  Created by LITi on 2018/11/30.
//  Copyright © 2018 Dawnpro. All rights reserved.
//

#import "CXTools.h"
//#import "SSZipArchive.h"
// 使用截屏的功能
#import <QuartzCore/QuartzCore.h>

// 将截图保存到系统相册
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PHAssetChangeRequest.h>
#import <Photos/PHImageManager.h>

@implementation CXTools

#pragma mark -

/*
 *验证手机号
 */
+ (BOOL)validateMobile:(NSString *)mobileNum {
    /**
     * 手机号码
     * 移动：134[0-8], 135, 136, 137, 138, 139, 150, 151, 157, 158, 159, 182, 187, 188
     * 联通：130, 131, 132, 152, 155, 156, 185, 186
     * 电信：133, 1349, 153, 180, 189
     */
    NSString * MOBILE = @"^1[3-9]\\d{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    if(([regextestmobile evaluateWithObject:mobileNum] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

//邮箱
+ (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 验证身份证
+ (BOOL)validateCard:(NSString *)card {
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *cardTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [cardTest evaluateWithObject:card];
}

// 检测字符串是否为空串
+ (BOOL)isBlankString:(NSString *)string {
    
    if(string == nil || string == NULL) {
        return YES;
    }
    
    if([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    
    return NO;
}

#pragma mark -

+(void)showAlertTitle:(NSString *)title message:(NSString *)message sure:(NSString *)sure cancel:(NSString *)cancel blockSure:(void (^)(UIAlertAction * _Nonnull))blockSure blockCancel:(void (^)(UIAlertAction * _Nonnull))blockCancel{
    if (sure == nil && cancel == nil) {
        return;
    }
    UIAlertController* alertCtr = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (sure) {
        UIAlertAction* sureBtn = [UIAlertAction actionWithTitle:sure style:UIAlertActionStyleDefault handler:blockSure];
        [alertCtr addAction:sureBtn];
    }
    if (cancel) {
        UIAlertAction* cancelBtn = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:blockCancel];
        [alertCtr addAction:cancelBtn];
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertCtr animated:YES completion:nil];
}

#pragma mark -

// http url中特殊字符转换
+ (NSString *)UrlEncodedString:(NSString *)sourceText {
//    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)sourceText ,NULL ,CFSTR("!*'();:@&=+$,/?%#[]") ,kCFStringEncodingUTF8));
    
    NSString *result =  [sourceText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return result;
}


#pragma mark -

+ (NSString *)createCUID { // https://www.jianshu.com/p/855baa1ea5e6
    NSString *result;
    CFUUIDRef uuid;
    CFStringRef uuidStr;
    uuid = CFUUIDCreate(NULL);
    uuidStr = CFUUIDCreateString(NULL, uuid);
    result = [NSString stringWithString:(__bridge NSString *)uuidStr];
    CFRelease(uuidStr);
    CFRelease(uuid);
    return result;
}




#pragma mark -

//将大小转化为格式,B,L,M,G之间的转换
+ (NSString *)convertFloatSizeToString:(float)size {
    if(size < 1024L) {
        return [NSString stringWithFormat:@"%fB", size];
    }else if(size < 1024L * 1024L) {
        return [NSString stringWithFormat:@"%1.2fK", (float)size / 1024.0];
    }else if(size < 1024L * 1024L * 1024L) {
        return [NSString stringWithFormat:@"%1.2fM", (float)size / 1024.0 / 1024.0];
    }else{
        return [NSString stringWithFormat:@"%1.2fG", (float)size / 1024.0 / 1024.0 / 1024.0];
    }
}

#pragma mark -

+ (NSURL *)itmsServicesURLWithString:(NSString *)string {
    //    itms-services://?action=download-manifest&url=https://dn-dp.qbox.me/ios/baseapp.plist
    return [NSURL URLWithString:[NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",string]];
}


#pragma mark - 将时间转化为友好提示

+ (NSString *)convertTime2FriendlyPrompt:(NSTimeInterval)time {
    NSTimeInterval t = [[NSDate date] timeIntervalSince1970];
//    NSLog(@"time : %lf -- t: %lf", time , t);
    
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:time];
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate:d];
//    NSDate *localeDate = [d dateByAddingTimeInterval:interval];
    
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSString *str = [f stringFromDate:d];
//    NSLog(@"time - %lf - %@", time, str);
    
    double de = t - time;
    int oneDay = 60 * 60 * 24;
    
    if (de < oneDay) { // 一天以内，显示时间
        return [str substringWithRange:NSMakeRange(10, 5)];
    } else if (de < oneDay * 2) {
        return @"昨天";
    } else if (de <= oneDay * 3) {
        return @"前天";
    } else {
        return [str substringWithRange:NSMakeRange(5, 5)];
    }
}

#pragma mark -
+ (NSString*)stringFromTime:(NSTimeInterval)time withFormatter:(NSString*)formatter{
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    NSString* timeStirng = [NSString stringWithFormat:@"%ld",(long)time];
    NSString* nowString = [NSString stringWithFormat:@"%ld",(long)nowTime];
    if (timeStirng.length>nowString.length) {
        time /= 1000;
    }
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = formatter;
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
    return [dateFormatter stringFromDate:date];
}


#pragma mark - 截屏功能

// 实现截屏并保存到相册 https://www.jianshu.com/p/58ab831642e3
// http://www.cnblogs.com/eagle927183/p/3476209.html
+ (void)snapshotScreenWithView:(UIView *)sView completeHandler:(void(^)(BOOL success, NSString *msg, UIImage* img, NSString* imageID))handler {
    NSLog(@"截屏功能");
    
    UIGraphicsBeginImageContextWithOptions(sView.frame.size, NO, [UIScreen mainScreen].scale);
    [sView drawViewHierarchyInRect:sView.frame afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // 保存到相册 http://www.cnblogs.com/KiVen2015/p/7090342.html
    // 第一个参数是要保存到相册的图片对象
    // 第二个参数是保存完成后回调的目标对象
    // 第三个参数就是保存完成后回调到目标对象的哪个方法中，方法的声明要如代码中所示的：
    //   - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
    // 第四个参数在保存完成后，会原封不动地传回到回调方法的contextInfo参数中。
    //    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    
    //相册权限
    // 权限管理 https://blog.csdn.net/qq_24702189/article/details/79345381
    PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthorStatus == PHAuthorizationStatusNotDetermined){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                NSLog(@"同意授权访问相册---");
                [CXTools saveImageFinished:image completeHandler:^(BOOL success, NSString* imageID) {
                    if(success) {
                        handler(YES, nil, image, imageID);
                    } else {
                        handler(NO, @"保存截图到相册失败。", image, imageID);
                    }
                }];
            } else {
                NSLog(@"禁止使用相册");
                handler(NO, @"没用权限访问相册，请前往【设置】修改权限。", image, nil);
            }
        }];
    } else if (photoAuthorStatus == PHAuthorizationStatusAuthorized) {
        NSLog(@"已授权访问相册----");
        [CXTools saveImageFinished:image completeHandler:^(BOOL success, NSString* imageID) {
            if(success) {
                handler(YES, nil, image, imageID);
            } else {
                handler(NO, @"保存截图到相册失败。", image, imageID);
            }
        }];
    } else {
        NSLog(@"已拒绝授权访问相册----，请前往【设置】修改App权限");
        handler(NO, @"没用权限访问相册，请前往【设置】修改权限。", image, nil);
    }
}


// https://www.jianshu.com/p/d1883255b62b (保存图片，获取图片)
+ (void)saveImageFinished:(UIImage *)image completeHandler:(void(^)(BOOL success, NSString* imageID))handle {
    
    __block NSString *asserID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^ {
        // 写入图片到相册
        PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        NSLog(@"保存的相片 %@", req.placeholderForCreatedAsset.localIdentifier);
        asserID = req.placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"success = %d, error = %@", success, error);
        handle(success, asserID);
    }];
}

+ (void)getImageFromPhotosAlbumWithID:(NSString *)imgID completeHandler:(void(^)(BOOL success, UIImage* img))handle {
    // 获取保存的图片
    PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[imgID] options:nil].firstObject;
    
    // 基本配置 链接：https://www.jianshu.com/p/f5dd51fe6c83
    //    CGFloat scale = [UIScreen mainScreen].scale;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode   = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    //        CGSize size = CGSizeMake(asset.pixelWidth / scale, asset.pixelHeight / scale);
    CGSize size = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    // 获取图片
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        NSLog(@"获取到图片了");
        NSLog(@"info -> %@", info);
        handle(YES, result);
    }];
}

#pragma mark - Call Telphone
+(void)callPhoneNumber:(NSString *)tel{
    NSString* string = [NSString stringWithFormat:@"telprompt:%@",tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string] options:@{} completionHandler:nil];
}

#pragma mark - Fix image Orientation
+ (UIImage*)fixOrientation:(UIImage*)aImage
{
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage* img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
