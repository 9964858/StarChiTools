//
//  CXAlertView.h
//  BaseAppV3
//
//  Created by 池鑫 on 2019/5/22.
//  Copyright © 2019 Dawnpro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXDatePickView : UIView

+(instancetype)showDatePickCompletion:(void(^)(NSDate* date))completion;
-(void)setDate:(NSDate*)date;
-(void)setMinDate:(NSDate*)date;
-(void)setMaxDate:(NSDate*)date;
@end

NS_ASSUME_NONNULL_END
