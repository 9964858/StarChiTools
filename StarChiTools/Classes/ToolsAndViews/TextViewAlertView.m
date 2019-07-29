//
//  TextViewAlertView.m
//  test
//
//  Created by jacky.lee on 15/1/29.
//  Copyright (c) 2015年 bill.lin. All rights reserved.
//

#import "TextViewAlertView.h"

@interface TextViewAlertView () <UITextViewDelegate>
{
    // 记录alertView的高度
    float _height;
    UIView* _backgroundMaskView;
}

@end

@implementation TextViewAlertView

#define COLOR(R, G, B, al) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:al]
#define IOS7 ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0 ? YES : NO)

#define WINDOW_FRAME [UIScreen mainScreen].bounds
#define AlertViewX 25
#define AlertViewY ((WINDOW_FRAME.size.height-203)/2-104.0f)
#define AlertViewWidth (WINDOW_FRAME.size.width-50)
#define AlertViewHeight 203

#define TOP 20
#define TitleLabel_width AlertViewWidth
#define TitleLabel_height 16

#define MessageLabel_X 15
#define MessageLabel_Y (TOP + TitleLabel_height + 5)
#define MessageLabel_width (AlertViewWidth - 30)

#define TextView_X 15
#define TextView_Y(height) (height + MessageLabel_Y + 15)
#define TextView_width (AlertViewWidth - 30)


#define TITLE_FONT_SIZE 16.0f
#define MESSAGE_FONT_SIZE 13.0f

// 最大行数
#define MAX_ROWS 5

- (void)dealloc
{
    _titleLabel = nil;
    _messageLabel = nil;
    _textView = nil;
    _cancelBtn = nil;
    _sureBtn = nil;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message clickSureBlock:(void (^)(TextViewAlertView *))clickSureBlock
{
    self = [super initWithFrame:CGRectMake(AlertViewX, AlertViewY, AlertViewWidth, AlertViewHeight)];;
    if (self) {
        _clickSureBlock = clickSureBlock;
        self.layer.cornerRadius = 6.0f;
        self.layer.masksToBounds = YES;
        self.backgroundColor = COLOR(238, 238, 238, 1);
        
        // 标题Label
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, TOP, TitleLabel_width, TitleLabel_height)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:TITLE_FONT_SIZE];
        _titleLabel.textColor = COLOR(18, 18, 18, 1);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = title;
        [self addSubview:_titleLabel];
        
        
        // messageLabel
        if (message.length) {
            _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(MessageLabel_X, MessageLabel_Y, MessageLabel_width, [self getHeightWithString:message])];
            _messageLabel.text = message;
            _messageLabel.font = [UIFont systemFontOfSize:MESSAGE_FONT_SIZE];
            _messageLabel.textColor = COLOR(18, 18, 18, 1);
            _messageLabel.numberOfLines = 0;
            _messageLabel.textAlignment = NSTextAlignmentCenter;
            _messageLabel.backgroundColor = [UIColor redColor];
            [self addSubview:_messageLabel];
        }
        
        
        // 输入框
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(TextView_X, TextView_Y(_messageLabel.frame.size.height), TextView_width, 25)];
        _textView.layer.borderWidth = 0.3f;
        _textView.layer.borderColor = [COLOR(18, 18, 18, 1) CGColor];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.delegate = self;
        [_textView becomeFirstResponder];
        [self addSubview:_textView];
        
        
        // 取消按钮
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(-1, _textView.frame.size.height + _textView.frame.origin.y + 10, AlertViewWidth / 2 + 3, 47)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:COLOR(23, 126, 251, 1) forState:UIControlStateNormal];
        _cancelBtn.layer.borderColor = [COLOR(210, 210, 210, 1) CGColor];
        _cancelBtn.layer.borderWidth = 0.5f;
        [_cancelBtn addTarget:self action:@selector(onClickCancelBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelBtn];
        
        
        // 确定按钮
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cancelBtn.frame), CGRectGetMinY(_cancelBtn.frame), AlertViewWidth / 2, 47)];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:COLOR(23, 126, 251, 1) forState:UIControlStateNormal];
        _sureBtn.layer.borderColor = [COLOR(210, 210, 210, 1) CGColor];
        _sureBtn.layer.borderWidth = 0.5f;
        [_sureBtn addTarget:self action:@selector(onClickSureBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sureBtn];
        
        
        CGRect rect = self.frame;
        rect.size.height = _cancelBtn.frame.size.height + _cancelBtn.frame.origin.y - 1;
        _height = rect.size.height;
        self.frame = rect;
    }
    return self;
}

// 获取message高度
- (float)getHeightWithString:(NSString *)message
{
    float w = 0;
    if (IOS7) {
        w = [message sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:MESSAGE_FONT_SIZE] forKey:NSFontAttributeName]].width;
    } else {
        w = [message sizeWithFont:[UIFont systemFontOfSize:MESSAGE_FONT_SIZE] constrainedToSize:CGSizeMake(100, MessageLabel_width)].width;
    }
    
    // ceilf(); 向上取整
    return ceilf(w / MessageLabel_width) * MESSAGE_FONT_SIZE + 10;
}

// 取消按钮
- (void)onClickCancelBtn:(UIButton *)btn
{
    [self dismissView];
}
// 确定按钮
- (void)onClickSureBtn:(UIButton*)btn
{
    [self dismissView];
    if (_clickSureBlock) {
        _clickSureBlock(self);
        _clickSureBlock = nil;
    }
}

// 展示alertView和背景
- (void)showInView:(UIView *)view
{
    _backgroundMaskView = [[UIView alloc] initWithFrame:view.frame];
    _backgroundMaskView.backgroundColor = COLOR(99, 98 ,96 , 0.5);
    [view addSubview:_backgroundMaskView];
    [view addSubview:self];
    self.alpha = 0;
    _backgroundMaskView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
        self->_backgroundMaskView.alpha = 1;
    } completion:nil];
}
// 销毁alertView和背景
- (void)dismissView
{
    __weak typeof(self) weakSelf = self;
    [weakSelf.textView resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        self->_backgroundMaskView.alpha = 0;
    } completion:^(BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_backgroundMaskView removeFromSuperview];
            [weakSelf removeFromSuperview];
        });
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.markedTextRange == nil) { // 输入汉字时，防止英语还没转变成汉字
        int rows = (int)(textView.contentSize.height - textView.textContainerInset.top - textView.textContainerInset.bottom) / textView.font.lineHeight;
        [self setTextViewHeight:rows];
    }
}
// 重新计算alertView以及其子控件的高度
- (void)setTextViewHeight:(int)row
{
    if (row > MAX_ROWS) {
        row = MAX_ROWS;
    }
    
    CGRect rect = _textView.frame;
    rect.size.height = row * 16 + 10;
    _textView.frame = rect;
    
    rect = self.frame;
    rect.size.height = _height + (row - 1) * 16;
    self.frame = rect;
    
    CGRect rect1 = _cancelBtn.frame;
    rect1.origin.y = rect.size.height - 47;
    _cancelBtn.frame = rect1;
    
    rect1 = _sureBtn.frame;
    rect1.origin.y = _cancelBtn.frame.origin.y;
    _sureBtn.frame = rect1;
}


@end
