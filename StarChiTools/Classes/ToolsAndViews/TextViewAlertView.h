//
//  TextViewAlertView.h
//  test
//
//  Created by jacky.lee on 15/1/29.
//  Copyright (c) 2015年 bill.lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewAlertView : UIView

@property (strong, nonatomic)UILabel *titleLabel;
@property (strong, nonatomic)UILabel *messageLabel;
@property (strong, nonatomic)UITextView *textView;
@property (strong, nonatomic)UIButton *cancelBtn;
@property (strong, nonatomic)UIButton *sureBtn;

@property (strong, nonatomic)NSIndexPath* fromIndexPath;

@property (nonatomic,copy)void(^clickSureBlock)(TextViewAlertView* alertView);


- (id)initWithTitle:(NSString *)title message:(NSString *)message clickSureBlock:(void (^)(TextViewAlertView *))clickSureBlock;

- (void)showInView:(UIView *)view;

@end
