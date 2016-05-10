//
//  TWScrollSegmentView.m
//  TWScrollViewController
//
//  Created by HaKim on 16/5/9.
//  Copyright © 2016年 haKim. All rights reserved.
//

#import "TWScrollSegmentView.h"
#import "TWSegmentStyle.h"
#import "UIView+TWExtension.h"

#define kXGap               (5.0)
#define kWGap               (2 * kXGap)

@interface TWScrollSegmentView ()

@property (nonatomic, assign) CGFloat currentWidth;
@property (nonatomic, assign) CGFloat currentIndex;
@property (nonatomic, assign) CGFloat oldIndex;

@property (strong, nonatomic) UIColor *coverBackgroundColor;
@property (weak, nonatomic) UIView *scrollLine;
@property (weak, nonatomic) UIView *coverLayer;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) UIImageView *backgroundImageView;
@property (weak, nonatomic) UIButton *extraBtn;

@property (strong, nonatomic) TWSegmentStyle *segmentStyle;
@property (strong, nonatomic) NSArray *titles;

@property (strong, nonatomic) NSArray *deltaRGB;
@property (strong, nonatomic) NSArray *selectedColorRgb;
@property (strong, nonatomic) NSArray *normalColorRgb;

/** 所有标题数组 */
@property (nonatomic, strong) NSMutableArray *titleBtns;

/** 所有标题宽度数组 */
@property (nonatomic, strong) NSMutableArray *titleWidths;
@property (copy, nonatomic) TitleBtnOnClickBlock titleBtnOnClick;

@end


@implementation TWScrollSegmentView

- (instancetype)initWithFrame:(CGRect )frame segmentStyle:(TWSegmentStyle *)segmentStyle titles:(NSArray *)titles titleDidClick:(TitleBtnOnClickBlock)titleDidClick {
    if (self = [super initWithFrame:frame]) {
        self.segmentStyle = segmentStyle;
        self.titles = titles;
        self.titleBtnOnClick = titleDidClick;
        
        self.currentIndex = 0;
        self.oldIndex = 0;
        self.currentWidth = frame.size.width;
        
        if (!self.segmentStyle.isScrollTitle) {
            // 不能滚动的时候就不要把缩放和遮盖或者滚动条同时使用, 否则显示效果不好
            self.segmentStyle.scaleTitle = !(self.segmentStyle.isShowCover || self.segmentStyle.isShowLine);
        }
        
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.currentIndex = 0;
        self.oldIndex = 0;
        self.currentWidth = frame.size.width;
        
        if (!self.segmentStyle.isScrollTitle) {
            // 不能滚动的时候就不要把缩放和遮盖或者滚动条同时使用, 否则显示效果不好
            self.segmentStyle.scaleTitle = !(self.segmentStyle.isShowCover || self.segmentStyle.isShowLine);
        }
        
        [self commonInit];
    }
    return self;
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    // navgation controller 关闭自动调整insets
    UIViewController *parentVc = [self viewController];
    parentVc.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - public method

- (void)adjustUIWhenBtnOnClickWithAnimate:(BOOL)animated {
    if(self.currentIndex == self.oldIndex){
        return;
    }
    
    [self adjustTitleOffSetToCurrentIndex:self.currentIndex];
    
    UIButton *toBtn = [self.titleBtns objectAtIndex:self.currentIndex];
    UIButton *fromBtn = [self.titleBtns objectAtIndex:self.oldIndex];
    
    if(animated){
        [UIView animateWithDuration:0.3 animations:^{
            [self adjustTitleBtnStatus:toBtn fromBtn:fromBtn];
        } completion:^(BOOL finished) {
            
        }];
    }else{
        [self adjustTitleBtnStatus:toBtn fromBtn:fromBtn];
    }
    
    self.oldIndex = self.currentIndex;
    if (self.titleBtnOnClick) {
        self.titleBtnOnClick(toBtn, self.currentIndex);
    }
}

- (void)adjustUIWithProgress:(CGFloat)progress oldIndex:(NSInteger)oldIndex currentIndex:(NSInteger)currentIndex{
    if(oldIndex == currentIndex){
        return;
    }
    
    self.oldIndex = currentIndex;
    
    UIButton *fromBtn = [self.titleBtns objectAtIndex:oldIndex];
    UIButton *toBtn = [self.titleBtns objectAtIndex:currentIndex];
    
    CGFloat xDistance = toBtn.tw_x - fromBtn.tw_x;
    CGFloat wDistance = toBtn.tw_width - fromBtn.tw_width;
    
    if(self.segmentStyle.isShowLine){
        self.scrollLine.tw_x = fromBtn.tw_x + xDistance * progress;
        self.scrollLine.tw_width = fromBtn.tw_width + wDistance * progress;
    }
    
    if(self.segmentStyle.isShowCover){
        if(self.segmentStyle.isScrollTitle){
            self.coverLayer.tw_x = fromBtn.tw_x + xDistance * progress - kXGap;
            self.coverLayer.tw_width = fromBtn.tw_width + wDistance * progress + kWGap;
        }else{
            self.coverLayer.tw_x = fromBtn.tw_x + xDistance * progress;
            self.coverLayer.tw_width = fromBtn.tw_width + wDistance * progress;
        }
    }
    
    // 渐变
    if (self.segmentStyle.isGradualChangeTitleColor) {
        UIColor *fromColor = [UIColor colorWithRed:[self.selectedColorRgb[0] floatValue] + [self.deltaRGB[0] floatValue] * progress green:[self.selectedColorRgb[1] floatValue] + [self.deltaRGB[1] floatValue] * progress blue:[self.selectedColorRgb[2] floatValue] + [self.deltaRGB[2] floatValue] * progress alpha:1.0];
        [fromBtn setTitleColor:fromColor forState:UIControlStateNormal];
        UIColor *toColor = [UIColor colorWithRed:[self.normalColorRgb[0] floatValue] - [self.deltaRGB[0] floatValue] * progress green:[self.normalColorRgb[1] floatValue] - [self.deltaRGB[1] floatValue] * progress blue:[self.normalColorRgb[2] floatValue] - [self.deltaRGB[2] floatValue] * progress alpha:1.0];
        [toBtn setTitleColor:toColor forState:UIControlStateNormal];
    }
    
    if(self.segmentStyle.isScaleTitle){
        CGFloat dealta = self.segmentStyle.titleBigScale  - 1.0;
        fromBtn.transform = CGAffineTransformMakeScale(self.segmentStyle.titleBigScale - dealta *progress, self.segmentStyle.titleBigScale - dealta *progress);
        toBtn.transform = CGAffineTransformMakeScale(1.0 + dealta *progress, 1.0 + dealta *progress);
    }
}

- (void)adjustTitleOffSetToCurrentIndex:(NSInteger)currentIndex {
    UIButton *btn = [self.titleBtns objectAtIndex:currentIndex];
    
    CGFloat offsetX = btn.center.x - self.bounds.size.width / 2;
    if(offsetX < 0){
        offsetX = 0;
    }
    CGFloat maxOffsetX = self.scrollView.contentSize.width - (self.currentWidth - (self.segmentStyle.showExtraButton ? self.extraBtn.tw_width : 0.0));
    if(offsetX >= maxOffsetX){
        offsetX = maxOffsetX;
    }
    [self.scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated {
    if (index < 0 || index >= self.titles.count) {
        return;
    }
    
    self.currentIndex = index;
    [self adjustUIWhenBtnOnClickWithAnimate:animated];
}

- (void)adjustTitleBtnStatus:(UIButton*)toBtn fromBtn:(UIButton*)fromBtn{
    [fromBtn setTitleColor:self.segmentStyle.normalTitleColor forState:UIControlStateNormal];
    [toBtn setTitleColor:self.segmentStyle.selectedTitleColor forState:UIControlStateNormal];
    
    if(self.segmentStyle.isScaleTitle){
        fromBtn.transform = CGAffineTransformIdentity;
        toBtn.transform = CGAffineTransformMakeScale(self.segmentStyle.titleBigScale, self.segmentStyle.titleBigScale);
    }
    if(self.segmentStyle.isShowLine){
        self.scrollLine.tw_x = toBtn.tw_x;
        self.scrollLine.tw_width = toBtn.tw_width;
    }
    if(self.segmentStyle.isShowCover){
        if(self.segmentStyle.isScrollTitle){
            self.coverLayer.tw_x = toBtn.tw_x - kXGap;
            self.coverLayer.tw_width = toBtn.tw_width + kWGap;
        }else{
            self.coverLayer.tw_x = toBtn.tw_x;
            self.coverLayer.tw_width = toBtn.tw_width;
        }
    }
}

#pragma mark - button action

- (void)titleBtnClicked:(UIButton *)sender {
    _currentIndex = sender.tag;
    
    [self adjustUIWhenBtnOnClickWithAnimate:YES];
}

- (void)extraBtnOnClick:(UIButton *)extraBtn {
    if (self.extraBtnOnClick) {
        self.extraBtnOnClick(extraBtn);
    }
}

#pragma mark - UI

- (void)commonInit{
     //设置了frame之后可以直接设置其他的控件的frame了, 不需要在layoutsubView()里面设置
    [self setupTitles];
    [self setupUI];
}

- (void)setupTitles {
    NSInteger index = 0;
    for (NSString *title in self.titles) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = index;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:self.segmentStyle.normalTitleColor forState:UIControlStateNormal];
        btn.titleLabel.font = self.segmentStyle.titleFont;

        [btn addTarget:self action:@selector(titleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        CGRect bounds = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: btn.titleLabel.font} context:nil];
        [self.titleWidths addObject:@(bounds.size.width)];
        [self.titleBtns addObject:btn];
        [self.scrollView addSubview:btn];
        
        index++;
    }
}

- (void)setupUI {
    [self setupScrollViewAndExtraBtn];
    [self setupBtnPosition];
    [self setupScrollLineAndCover];
    
    if (self.segmentStyle.isScrollTitle) {
        // 设置滚动区域
        UIButton *lastBtn = (UIButton *)self.titleBtns.lastObject;
        
        if (lastBtn) {
            self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastBtn.frame)+self.segmentStyle.titleMargin, 0.0);
        }
    }
}

- (void)setupScrollViewAndExtraBtn {
    CGFloat extraBtnW = 44.0;
    CGFloat extraBtnY = 5.0;
    CGFloat scrollW = self.extraBtn ? _currentWidth - extraBtnW : _currentWidth;
    self.scrollView.frame = CGRectMake(0.0, 0.0, scrollW, self.tw_height);
    if (self.extraBtn) {
        self.extraBtn.frame = CGRectMake(scrollW, extraBtnY, extraBtnW, self.tw_height - 2*extraBtnY);
    }
}

- (void)setupBtnPosition {
    CGFloat titleX = 0.0;
    CGFloat titleY = 0.0;
    CGFloat titleW = 0.0;
    CGFloat titleH = self.tw_height - self.segmentStyle.scrollLineHeight;
    
    if (!self.segmentStyle.isScrollTitle) {// 标题不能滚动, 平分宽度
        titleW = _currentWidth / self.titles.count;
        
        NSInteger index = 0;
        for (UIButton *btn in self.titleBtns) {
            titleX = index * titleW;
            
            btn.frame = CGRectMake(titleX, titleY, titleW, titleH);
            index++;
        }
        
    } else {
        NSInteger index = 0;
        for (UIButton *btn in self.titleBtns) {
            titleW = [self.titleWidths[index] floatValue];
            titleX = self.segmentStyle.titleMargin;
            
            if (index != 0) {
                UIButton *lastBtn = (UIButton *)self.titleBtns[index - 1];
                titleX = CGRectGetMaxX(lastBtn.frame) + self.segmentStyle.titleMargin;
            }
            btn.frame = CGRectMake(titleX, titleY, titleW, titleH);
            index++;
        }
    }
    
    UIButton *firstBtn = (UIButton *)[self.titleBtns firstObject];
    
    if (firstBtn) {
        // 缩放, 设置初始的label的transform
        if (self.segmentStyle.isScaleTitle) {
            firstBtn.transform = CGAffineTransformMakeScale(self.segmentStyle.titleBigScale, self.segmentStyle.titleBigScale);
            //firstLabel.currentTransformSx = self.segmentStyle.titleBigScale;
        }
        // 设置初始状态文字的颜色
        [firstBtn setTitleColor:self.segmentStyle.selectedTitleColor forState:UIControlStateNormal];
    }
}

- (void)setupScrollLineAndCover {
    UIButton *firstBtn = (UIButton *)[self.titleBtns firstObject];
    CGFloat coverX = firstBtn.tw_x;
    CGFloat coverW = firstBtn.tw_width;
    CGFloat coverH = self.segmentStyle.coverHeight;
    CGFloat coverY = (self.bounds.size.height - coverH) * 0.5;
    
    if (self.scrollLine) {
        self.scrollLine.frame = CGRectMake(coverX , self.tw_height - self.segmentStyle.scrollLineHeight, coverW , self.segmentStyle.scrollLineHeight);
    }
    
    if (self.coverLayer) {
        if (self.segmentStyle.isScrollTitle) {
            self.coverLayer.frame = CGRectMake(coverX - kXGap, coverY, coverW + kWGap, coverH);
        } else {
            self.coverLayer.frame = CGRectMake(coverX, coverY, coverW, coverH);
        }
    }
}

#pragma mark - get & set method

- (UIView *)scrollLine {
    if (!self.segmentStyle.isShowLine) {
        return nil;
    }
    
    if (!_scrollLine) {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = self.segmentStyle.scrollLineColor;
        
        [self.scrollView addSubview:lineView];
        _scrollLine = lineView;
    }
    
    return _scrollLine;
}

- (UIView *)coverLayer {
    if (!self.segmentStyle.isShowCover) {
        return nil;
    }
    
    if (_coverLayer == nil) {
        UIView *coverView = [[UIView alloc] init];
        coverView.backgroundColor = self.segmentStyle.coverBackgroundColor;
        coverView.layer.cornerRadius = self.segmentStyle.coverCornerRadius;
        coverView.layer.masksToBounds = YES;
        [self.scrollView insertSubview:coverView atIndex:0];
        
        _coverLayer = coverView;
    }
    
    return _coverLayer;
}

- (UIButton *)extraBtn {
    if (!self.segmentStyle.showExtraButton) {
        return nil;
    }
    if (!_extraBtn) {
        UIButton *btn = [UIButton new];
        [btn addTarget:self action:@selector(extraBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        NSString *imageName = self.segmentStyle.extraBtnBackgroundImageName ? self.segmentStyle.extraBtnBackgroundImageName : @"";
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        // 设置边缘的阴影效果
        btn.layer.shadowColor = [UIColor whiteColor].CGColor;
        btn.layer.shadowOffset = CGSizeMake(-5, 0);
        btn.layer.shadowOpacity = 1;
        
        [self addSubview:btn];
        _extraBtn = btn;
    }
    return _extraBtn;
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.bounces = YES;
        scrollView.pagingEnabled = NO;

        [self addSubview:scrollView];
        
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        
        [self insertSubview:imageView atIndex:0];
        
        _backgroundImageView = imageView;
    }
    return _backgroundImageView;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    if (backgroundImage) {
        self.backgroundImageView.image = backgroundImage;
    }
}

- (NSMutableArray *)titleBtns
{
    if (_titleBtns == nil) {
        _titleBtns = [NSMutableArray array];
    }
    return _titleBtns;
}

- (NSMutableArray *)titleWidths
{
    if (_titleWidths == nil) {
        _titleWidths = [NSMutableArray array];
    }
    return _titleWidths;
}

- (NSArray *)deltaRGB {
    if (_deltaRGB == nil) {
        NSArray *normalColorRgb = self.normalColorRgb;
        NSArray *selectedColorRgb = self.selectedColorRgb;
        
        NSArray *delta;
        if (normalColorRgb && selectedColorRgb) {
            CGFloat deltaR = [normalColorRgb[0] floatValue] - [selectedColorRgb[0] floatValue];
            CGFloat deltaG = [normalColorRgb[1] floatValue] - [selectedColorRgb[1] floatValue];
            CGFloat deltaB = [normalColorRgb[2] floatValue] - [selectedColorRgb[2] floatValue];
            delta = [NSArray arrayWithObjects:@(deltaR), @(deltaG), @(deltaB), nil];
            _deltaRGB = delta;
            
        }
    }
    return _deltaRGB;
}


- (NSArray *)normalColorRgb {
    if (!_normalColorRgb) {
        NSArray *normalColorRgb = [self getColorRgb:self.segmentStyle.normalTitleColor];
        NSAssert(normalColorRgb, @"设置普通状态的文字颜色时 请使用RGB空间的颜色值");
        _normalColorRgb = normalColorRgb;
        
    }
    return  _normalColorRgb;
}

- (NSArray *)selectedColorRgb {
    if (!_selectedColorRgb) {
        NSArray *selectedColorRgb = [self getColorRgb:self.segmentStyle.selectedTitleColor];
        NSAssert(selectedColorRgb, @"设置选中状态的文字颜色时 请使用RGB空间的颜色值");
        _selectedColorRgb = selectedColorRgb;
        
    }
    return  _selectedColorRgb;
}

- (NSArray *)getColorRgb:(UIColor *)color {
    CGFloat numOfcomponents = CGColorGetNumberOfComponents(color.CGColor);
    NSArray *rgbComponents;
    if (numOfcomponents == 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        rgbComponents = [NSArray arrayWithObjects:@(components[0]), @(components[1]), @(components[2]), nil];
    }
    return rgbComponents;
    
}

@end
