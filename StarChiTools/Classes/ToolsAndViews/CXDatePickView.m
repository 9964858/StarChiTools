//
//  CXAlertView.m
//  BaseAppV3
//
//  Created by 池鑫 on 2019/5/22.
//  Copyright © 2019 Dawnpro. All rights reserved.
//

#import "CXDatePickView.h"
@interface CXDatePickView()
@property (nonatomic,strong)UIDatePicker* picker;
@property (nonatomic,strong)void(^completionBlock)(NSDate* date);
@property (nonatomic,strong)UIButton* backBtn;
@property (nonatomic,strong)UIWindow* window;
@property (nonatomic,strong)UIView* contentView;
@end
@implementation CXDatePickView
+(instancetype)showDatePickCompletion:(void (^)(NSDate * _Nonnull))completion{
    CXDatePickView* pickView = [[CXDatePickView alloc]init];
    pickView.completionBlock = completion;
    [pickView show];
    return pickView;
}
- (void)setDate:(NSDate *)date{
    self.picker.date = date;
}
-(void)setMinDate:(NSDate *)date{
    self.picker.minimumDate = date;
}
-(void)setMaxDate:(NSDate *)date{
    self.picker.maximumDate = date;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        CGFloat sWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat sHeight = [UIScreen mainScreen].bounds.size.height;
        
        self.frame = CGRectMake(0, 0, sWidth, sHeight);
        self.backgroundColor = [UIColor clearColor];
        
        self.backBtn = [[UIButton alloc]initWithFrame:self.bounds];
        [self.backBtn setBackgroundColor:[UIColor clearColor]];
        [self.backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backBtn];
        
        self.picker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 50, sWidth, 250)];
        self.picker.datePickerMode = UIDatePickerModeDate;
//        self.picker.locale = [NSLocale systemLocale];
        UIButton* cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [cancel setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [cancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [cancel setTitle:@"取消" forState:UIControlStateNormal];
        
        UIButton* sure = [[UIButton alloc]initWithFrame:CGRectMake(sWidth - 50, 0, 50, 50)];
        [sure addTarget:self action:@selector(pickDate) forControlEvents:UIControlEventTouchUpInside];
        [sure setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [sure setTitle:@"确定" forState:UIControlStateNormal];
        
        self.contentView = [[UIView alloc]initWithFrame:CGRectMake(0, sHeight, sWidth, 300)];
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.picker];
        [self.contentView addSubview:cancel];
        [self.contentView addSubview:sure];
        
        [self addSubview:self.contentView];
        
    }
    return self;
}
-(void)pickDate{
    self.completionBlock(self.picker.date);
    [self dismiss];
}

-(void)show{
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.hidden = NO;
    [self.window addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.contentView.frame;
        frame.origin.y = self.frame.size.height-self.contentView.frame.size.height;
        self.contentView.frame = frame;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    }];
}
-(void)dismiss{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.contentView.frame;
        frame.origin.y = self.frame.size.height;
        self.contentView.frame = frame;
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.window = nil;
        self.completionBlock = nil;
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)dealloc{
    NSLog(@"---%@-已释放",NSStringFromClass([self class]));
}
@end
