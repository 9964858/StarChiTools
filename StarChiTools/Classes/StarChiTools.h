#import "CXTools.h"
#import "CXDatePickView.h"
#import "CXSwitchView.h"
#import "TextViewAlertView.h"



// 获取系统状态栏高度
#define kNormalStatusBar [[UIApplication sharedApplication] statusBarFrame].size.height

//#define kNormalStatusBar 20
//#define kSpecialStatusBar 34 // 刘海屏的StatusBar高度


// 获取当前设备的类型 iPhone 或 iPad
#define kDeviceModel [UIDevice currentDevice].model

#define IS_IPHONE [kDeviceModel isEqualToString:@"iPhone"]
#define IS_IPAD [kDeviceModel isEqualToString:@"iPad"]

// 颜色转换工具函数
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 获取当前设备物理高度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
// 获取当前设备物理宽度
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
// 获取当前系统版本
#define kIOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

// 获取当前应用版本
#define kCurrentAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey]

// 获取当前应用版本名称
#define kCurrentAppVersionName [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleVersion"]





// 判断是iPhone机型 https://blog.csdn.net/walkerwqp/article/details/79607575
// 根据屏幕适配机型  https://www.jianshu.com/p/d40d701889a6
/**
 * iPhone 屏幕系列
 *
 * 4 / 4s                               3.5英寸   像素分辨率：960  * 640    330ppi  480 * 320
 * 5 / 5s / SE                          4英寸     像素分辨率：1136 * 640    326ppi  568 * 320
 * 6 / 6s / 7 / 8                       4.7英寸   像素分辨率：1334 * 750    326 ppi 667 * 375
 * 6 Plus / 6s Plus / 7 Plus / 8 Plus   5.5英寸   像素分辨率：1920 * 1080   401 ppi 640 * 360
 * X / Xs                               5.8英寸   像素分辨率：2436 * 1125   458 ppi
 * Xs Max                               6.5英寸   像素分辨率：2688 * 1242   458 ppi
 * Xr                                   6.1英寸   像素分辨率：1792 * 828    326 ppi
 */

// 4 4s
#define IS_IPHONE_4 [UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : \
NO

// 5 5s SE
#define IS_IPHONE_5 [UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : \
NO

// 6 6s 7 8
#define IS_IPHONE_6 [UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : \
NO

// [6 Plus] [6s Plus] [7 Plus] [8 Plus]
#define IS_IPHONE_6P [UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(1080, 1920), [[UIScreen mainScreen] currentMode].size) : \
NO

// X Xs
#define IS_IPHONE_X [UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : \
NO

// [Xs Max]
#define IS_IPHONE_Xs_MAX [UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : \
NO

// Xr
#define IS_IPHONE_Xr [UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : \
NO


//==============================
// 公文管理

//获取当前设备物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//获取当前设备物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
