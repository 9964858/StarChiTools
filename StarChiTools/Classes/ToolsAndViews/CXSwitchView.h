//
//  CXSwitchView.h
//  FirstApp
//
//  Created by 池鑫 on 2019/5/17.
//  Copyright © 2019 池鑫. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CXSwitchView : UIView
@property (nonatomic,strong)UIFont* defualtFont;
@property (nonatomic,strong)UIColor* defulatTextColor;

@property (nonatomic,strong)UIFont* selectedFont;
@property (nonatomic,strong)UIColor* selectedTextColor;

@property (nonatomic,assign)CGFloat bottomLineHeight;
@property (nonatomic,strong)UIColor* bottomLineColor;

@property (nonatomic,strong)UIColor* separateLineColor;
@property (nonatomic,assign)CGFloat separateLineHeight;
@property (nonatomic,assign)UIEdgeInsets separateStyle;

@property (nonatomic,strong)NSArray* titleArray;

+(instancetype)switchViewWithFrame:(CGRect)frame andTitles:(NSArray*)titleArray clickCallback:(void (^)(NSInteger index))block;
-(void)selectIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
