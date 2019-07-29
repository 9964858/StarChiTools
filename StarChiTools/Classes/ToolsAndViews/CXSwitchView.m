//
//  CXSwitchView.m
//  FirstApp
//
//  Created by 池鑫 on 2019/5/17.
//  Copyright © 2019 池鑫. All rights reserved.
//

#import "CXSwitchView.h"
// 颜色转换工具函数
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TopTextCell : UICollectionViewCell
@property (nonatomic,strong)UIFont* defualtFont;
@property (nonatomic,strong)UIColor* defulatTextColor;

@property (nonatomic,strong)UIFont* selectedFont;
@property (nonatomic,strong)UIColor* selectedTextColor;

@property (nonatomic,strong)UILabel* textLabel;
@end


@implementation TopTextCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _textLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = self.defualtFont;
        _textLabel.textColor = self.defulatTextColor;
        [self addSubview:_textLabel];
    }
    return self;
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _textLabel.frame = self.bounds;
}

-(void)setDefualtFont:(UIFont *)defualtFont{
    _defualtFont = defualtFont;
    if (!self.selected) {
        self.textLabel.font = _defualtFont;
    }
}
-(void)setDefulatTextColor:(UIColor *)defulatTextColor{
    _defulatTextColor = defulatTextColor;
    if (!self.selected) {
        self.textLabel.textColor = _defulatTextColor;
    }
}
-(void)setSelectedFont:(UIFont *)selectedFont{
    _selectedFont = selectedFont;
    if (self.selected) {
        self.textLabel.font = _defualtFont;
    }
}
-(void)setSelectedTextColor:(UIColor *)selectedTextColor{
    _selectedTextColor = selectedTextColor;
    if (self.selected) {
        self.textLabel.textColor = _defulatTextColor;
    }
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            if (selected) {
                CGFloat scale = self.selectedFont.pointSize/self.defualtFont.pointSize;
                self.textLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
                self.textLabel.textColor = self.selectedTextColor;
            }else{
                self.textLabel.transform = CGAffineTransformIdentity;
                self.textLabel.textColor = self.defulatTextColor;
            }
        }];
    });
}
@end

@interface CXSwitchView()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView* collectionView;
@property (nonatomic,strong)UIView* bottomLine;
@property (nonatomic,strong)UIView* bottomSeparateLine;
@property (nonatomic,copy)void (^block)(NSInteger index);

@end
@implementation CXSwitchView

#pragma mark - init
+(instancetype)switchViewWithFrame:(CGRect)frame andTitles:(NSArray*)titleArray clickCallback:(void (^)(NSInteger index))block{
    CXSwitchView* view = [[CXSwitchView alloc]initWithFrame:frame];
    view.titleArray = titleArray;
    view.block = block;
    return view;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadViews];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadViews];
        self.frame = frame;
    }
    return self;
}
-(void)loadViews{
    self.backgroundColor = [UIColor whiteColor];
    _defualtFont = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    _defulatTextColor = UIColorFromRGB(0x949494);
    _selectedFont = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    _selectedTextColor = UIColorFromRGB(0x386afe);
    _bottomLineHeight = 2;
    _bottomLineColor = UIColorFromRGB(0x386afe);
    _separateLineColor = UIColorFromRGB(0xf6f6f6);
    _separateLineHeight = 0.5;
    _separateStyle = UIEdgeInsetsMake(0, 12, 0, 12);
    
    self.bottomSeparateLine = [[UIView alloc]init];
    [self addSubview: self.bottomSeparateLine];
    
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.allowsSelection = YES;
    _collectionView.allowsMultipleSelection = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[TopTextCell class] forCellWithReuseIdentifier:@"TopTextCell"];
    [self addSubview:_collectionView];
    
    _bottomLine = [[UIView alloc]init];
    _bottomLine.backgroundColor = _bottomLineColor;
    [_collectionView addSubview:_bottomLine];
}

#pragma mark - SetValue
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _collectionView.frame = self.bounds;
    [_collectionView reloadData];
    [self refreshBottomLine];
    [self refreshSeparateLine];
}
-(void)refreshBottomLine{
    dispatch_async(dispatch_get_main_queue(), ^{
        TopTextCell* cell;
        if (self.collectionView.indexPathsForSelectedItems.count == 0) {
            cell = (TopTextCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
        }else{
            cell = (TopTextCell*)[self.collectionView cellForItemAtIndexPath:self.collectionView.indexPathsForSelectedItems[0]];
        }
        UILabel* label = [[UILabel alloc]init];
        label.font = cell.textLabel.font;
        label.text = cell.textLabel.text;
        [label sizeToFit];
        CGFloat labelWidth = label.frame.size.width;
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomLine.frame = CGRectMake(cell.center.x - labelWidth/2.f, self.bounds.size.height-self.bottomLineHeight, labelWidth, self.bottomLineHeight);
        }];
        
    });
}
-(void)refreshSeparateLine{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bottomSeparateLine.frame = CGRectMake(self.separateStyle.left, self.bounds.size.height - self.separateLineHeight, self.bounds.size.width-self.separateStyle.left-self.separateStyle.right, self.separateLineHeight);
        self.bottomSeparateLine.backgroundColor = self.separateLineColor;
    });
}
-(void)setSeparateLineHeight:(CGFloat)separateLineHeight{
    _separateLineHeight = separateLineHeight;
    [self refreshBottomLine];
}
-(void)setSeparateLineColor:(UIColor *)separateLineColor{
    _separateLineColor = separateLineColor;
    [self refreshBottomLine];
}
-(void)setSeparateStyle:(UIEdgeInsets)separateStyle{
    _separateStyle = separateStyle;
    [self refreshSeparateLine];
}
-(void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    [_collectionView reloadData];
    if (_collectionView.indexPathsForSelectedItems.count == 0) {
        if ([_collectionView.dataSource collectionView:_collectionView numberOfItemsInSection:0]>0) {
            [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
    [self refreshBottomLine];
}
-(void)setDefualtFont:(UIFont *)defualtFont{
    _defualtFont = defualtFont;
    [_collectionView reloadData];
}
-(void)setDefulatTextColor:(UIColor *)defulatTextColor{
    _defulatTextColor = defulatTextColor;
    [_collectionView reloadData];
}
-(void)setSelectedFont:(UIFont *)selectedFont{
    _selectedFont = selectedFont;
    [_collectionView reloadData];
}
-(void)setSelectedTextColor:(UIColor *)selectedTextColor{
    _selectedTextColor = selectedTextColor;
    [_collectionView reloadData];
}
-(void)setBottomLineColor:(UIColor *)bottomLineColor{
    _bottomLineColor = bottomLineColor;
    [self refreshBottomLine];
}
-(void)setBottomLineHeight:(CGFloat)bottomLineHeight{
    _bottomLineHeight = bottomLineHeight;
    [self refreshBottomLine];
}

#pragma mark - CollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _titleArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TopTextCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TopTextCell" forIndexPath:indexPath];
    cell.defualtFont = self.defualtFont;
    cell.defulatTextColor = self.defulatTextColor;
    cell.selectedFont = self.selectedFont;
    cell.selectedTextColor = self.selectedTextColor;
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self refreshBottomLine];
    self.block(indexPath.row);
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - CollectionViewFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger num = [collectionView.dataSource collectionView:collectionView numberOfItemsInSection:indexPath.section];
    CGFloat width;
    if (num>4) {
        width = floor(collectionView.bounds.size.width/4.5);
    }else{
        width = floor(collectionView.bounds.size.width/num);
    }
    return CGSizeMake(width, collectionView.bounds.size.height);
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark - OtherFunction
-(void)selectIndex:(NSInteger)index{
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
}
@end
