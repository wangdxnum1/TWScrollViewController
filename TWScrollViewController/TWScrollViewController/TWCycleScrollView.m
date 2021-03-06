//
//  TWCycleScrollView.m
//  TWCycleScrollView
//
//  Created by HaKim on 16/2/26.
//  Copyright © 2016年 haKim. All rights reserved.
//

#import "TWCycleScrollView.h"
#import "TWCollectionViewCell.h"
#import "UIView+TWExtension.h"
#import "UIColor+randomColor.h"
#import "DJDConstant.h"
#import "DJDConstant.h"

#define kTWCollectionViewCellPrefix         @"TWCollectionViewCellID_"

@interface TWCycleScrollView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger oldIndex;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) CGFloat oldOffSetX;

@property (assign, nonatomic) BOOL forbidTouchToAdjustPosition;

@property (nonatomic, weak) UICollectionView *mainView; // 显示view的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, assign) NSInteger totalItemsCount;
@property (nonatomic, weak) UIControl *pageControl;

@end

@implementation TWCycleScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self setupMainView];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initialization];
    [self setupMainView];
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    // navgation controller 关闭自动调整insets
    UIViewController *parentVc = [self viewController];
    parentVc.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - public method

- (void)scrollToPageWithIndex:(NSInteger)index{
    if (0 == _totalItemsCount) return;

    self.forbidTouchToAdjustPosition = YES;
    NSInteger targetIndex = index;
    if (targetIndex == _totalItemsCount) {
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
        }else{
            return;
        }
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        return;
    }
    if(!self.infiniteLoop && (targetIndex < 0 || targetIndex > _totalItemsCount)){
        return;
    }
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)scrollToNextPage{
    [self automaticScroll:1];
}

- (void)scrollToPreviousPage{
    [self automaticScroll:-1];
}

- (void)initialization
{
    _pageControlAliment = TWCycleScrollViewPageContolAlimentCenter;

    _infiniteLoop = YES;
    _showPageControl = YES;
    _hidesForSinglePage = YES;
    _currentPageDotColor = [UIColor whiteColor];
    _pageDotColor = [UIColor lightGrayColor];
    _pageControlDotSize = CGSizeMake(10, 10);
    
    self.oldIndex = 0;
    self.currentIndex = 0;
    self.oldOffSetX = 0.0;
    self.forbidTouchToAdjustPosition = NO;
    
    self.backgroundColor = [UIColor lightGrayColor];
    
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame viewsGroup:(NSArray *)viewsGroup
{
    TWCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.contentViewsGroup = [viewsGroup copy];
    return cycleScrollView;
}

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame shouldInfiniteLoop:(BOOL)infiniteLoop viewsGroup:(NSArray *)viewsGroup
{
    TWCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.infiniteLoop = infiniteLoop;
    cycleScrollView.contentViewsGroup = [viewsGroup copy];
    return cycleScrollView;
}


// 设置显示view的collectionView
- (void)setupMainView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    
    mainView.dataSource = self;
    mainView.delegate = self;
    [self addSubview:mainView];
    _mainView = mainView;
}


#pragma mark - properties

- (void)setShowPageControl:(BOOL)showPageControl
{
    _showPageControl = showPageControl;
    
    _pageControl.hidden = !showPageControl;
}

- (void)setCurrentPageDotColor:(UIColor *)currentPageDotColor
{
    _currentPageDotColor = currentPageDotColor;

    UIPageControl *pageControl = (UIPageControl *)_pageControl;
    pageControl.currentPageIndicatorTintColor = currentPageDotColor;
}

- (void)setPageDotColor:(UIColor *)pageDotColor
{
    _pageDotColor = pageDotColor;
    
    if ([self.pageControl isKindOfClass:[UIPageControl class]]) {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.pageIndicatorTintColor = pageDotColor;
    }
}

- (void)setPageControlDotSize:(CGSize)pageControlDotSize
{
    _pageControlDotSize = pageControlDotSize;
    [self setupPageControl];
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop
{
    _infiniteLoop = infiniteLoop;
    
    if (self.contentViewsGroup.count) {
        self.contentViewsGroup = self.contentViewsGroup;
    }
}

- (void)setContentViewsGroup:(NSArray *)contentViewsGroup
{
    _contentViewsGroup = contentViewsGroup;
    
    // 注册class
//    [mainView registerClass:[TWCollectionViewCell class] forCellWithReuseIdentifier:@"0"];
    for(int i = 0; i < _contentViewsGroup.count; ++i){
        NSString *ID = [NSString stringWithFormat:@"%@%d",kCFNumberFormatterNegativePrefix,i];
        [self.mainView registerClass:[TWCollectionViewCell class] forCellWithReuseIdentifier:ID];
    }
    
    _totalItemsCount = self.infiniteLoop ? self.contentViewsGroup.count * 100 : self.contentViewsGroup.count;
    
    if (contentViewsGroup.count != 1) {
        self.mainView.scrollEnabled = YES;
    } else {
        self.mainView.scrollEnabled = NO;
    }
    
    [self setupPageControl];
    [self.mainView reloadData];
}
#pragma mark - actions


- (void)setupPageControl
{
    if (_pageControl) [_pageControl removeFromSuperview]; // 重新加载数据时调整
    
    if ((self.contentViewsGroup.count <= 1) && self.hidesForSinglePage) {
        return;
    }

    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.contentViewsGroup.count;
    pageControl.currentPageIndicatorTintColor = self.currentPageDotColor;
    pageControl.pageIndicatorTintColor = self.pageDotColor;
    pageControl.userInteractionEnabled = NO;
    [self addSubview:pageControl];
    _pageControl = pageControl;
}

- (void)automaticScroll:(NSInteger)page
{
    if (0 == _totalItemsCount) return;
    int currentIndex = _mainView.contentOffset.x / _flowLayout.itemSize.width;
    NSInteger targetIndex = currentIndex + page;
    if (targetIndex == _totalItemsCount) {
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
        }else{
            return;
        }
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        return;
    }
    if(!self.infiniteLoop && (targetIndex < 0 || targetIndex > _totalItemsCount)){
        return;
    }
    [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - life circles

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _flowLayout.itemSize = self.frame.size;
    
    _mainView.frame = self.bounds;
    if (_mainView.contentOffset.x == 0 &&  _totalItemsCount) {
        int targetIndex = 0;
        if (self.infiniteLoop) {
            targetIndex = _totalItemsCount * 0.5;
        }else{
            targetIndex = 0;
        }
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    CGSize size = CGSizeZero;
    size = CGSizeMake(self.contentViewsGroup.count * self.pageControlDotSize.width * 1.2, self.pageControlDotSize.height);
    
    CGFloat x = (self.tw_width - size.width) * 0.5;
    if (self.pageControlAliment == TWCycleScrollViewPageContolAlimentRight) {
        x = self.mainView.tw_width - size.width - 10;
    }
    CGFloat y = self.mainView.tw_height - size.height - 10;
    
    self.pageControl.frame = CGRectMake(x, y, size.width, size.height);
    self.pageControl.hidden = !_showPageControl;
}

#pragma mark - public actions


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    long itemIndex = indexPath.item % self.contentViewsGroup.count;
    NSString *ID = [NSString stringWithFormat:@"%@%ld",kCFNumberFormatterNegativePrefix,itemIndex];
    TWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    if (!cell.hasConfigured) {
        //cell.contentView.backgroundColor = [UIColor randomColor];
        UIView *view = self.contentViewsGroup[itemIndex];
        view.frame = cell.contentView.bounds;
        [cell.contentView addSubview:view];

        cell.hasConfigured = YES;
        cell.clipsToBounds = YES;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:indexPath.item % self.contentViewsGroup.count];
    }
    if (self.clickItemOperationBlock) {
        self.clickItemOperationBlock(indexPath.item % self.contentViewsGroup.count);
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int itemIndex = (scrollView.contentOffset.x + self.mainView.tw_width * 0.5) / self.mainView.tw_width;
    if (!self.contentViewsGroup.count) return;
    NSInteger indexOnPageControl = itemIndex % self.contentViewsGroup.count;
    
    UIPageControl *pageControl = (UIPageControl *)_pageControl;
    pageControl.currentPage = indexOnPageControl;
    
    
    if(self.forbidTouchToAdjustPosition){
        return;
    }
    
    CGFloat offsetX = self.mainView.contentOffset.x;
    CGFloat temp = offsetX / self.mainView.tw_width;
    CGFloat progress = temp - floor(temp);
    
    //CGFloat progress = fabs(offsetX - self.oldOffSetX) / self.mainView.tw_width;
    
    //DLog(@"offset x = %@,progress = %@",@(offsetX),@(progress));
    if(offsetX >= self.oldOffSetX){
        // 向右滑动
        if (progress == 0.0) {
            return;
        }
        NSInteger maxCount = self.infiniteLoop ? (self.totalItemsCount / 100) : self.totalItemsCount;
        if(offsetX < 0 || offsetX > (maxCount - 1) * self.mainView.tw_width){
            return;
        }
        self.oldIndex = offsetX / self.mainView.tw_width;
        self.currentIndex = self.oldIndex + 1;
        
        if([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollFromIndex:toIndex:progress:)]){
            [self.delegate cycleScrollView:self didScrollFromIndex:self.oldIndex toIndex:self.currentIndex progress:progress];
        }
    }else{
        // 向左滑动
        NSInteger maxCount = self.infiniteLoop ? (self.totalItemsCount / 100) : self.totalItemsCount;
        if(offsetX < 0 || offsetX > (maxCount - 1) * self.mainView.tw_width){
            return;
        }
        self.currentIndex = offsetX / self.mainView.tw_width;
        self.oldIndex = self.currentIndex + 1;
        if(self.oldIndex >= maxCount){
            return;
        }
        self.currentIndex = self.oldIndex - 1;
        if([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollFromIndex:toIndex:progress:)]){
            [self.delegate cycleScrollView:self didScrollFromIndex:self.oldIndex toIndex:self.currentIndex progress:1.0 - progress];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
     self.forbidTouchToAdjustPosition = NO;
    self.oldOffSetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    DLog(@"++++++scrollViewDidEndDecelerating");
    CGFloat offsetX = self.mainView.contentOffset.x;
    NSInteger maxCount = self.infiniteLoop ? (self.totalItemsCount / 100) : self.totalItemsCount;
    if(offsetX < 0 || offsetX > (maxCount - 1) * self.mainView.tw_width){
        return;
    }
    NSInteger itemIndex = (scrollView.contentOffset.x + self.mainView.tw_width * 0.5) / self.mainView.tw_width;
    if([self.delegate respondsToSelector:@selector(cycleScrollView:didEndScrollToIndex:)]){
        [self.delegate cycleScrollView:self didEndScrollToIndex:itemIndex];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    DLog(@"----scrollViewDidEndScrollingAnimation");
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    DLog(@"!!!!!!scrollViewDidEndDragging");
//    CGFloat offsetX = self.mainView.contentOffset.x;
//    NSInteger maxCount = self.infiniteLoop ? (self.totalItemsCount / 100) : self.totalItemsCount;
//    if(offsetX < 0 || offsetX > (maxCount - 1) * self.mainView.tw_width){
//        return;
//    }
//    NSInteger itemIndex = (scrollView.contentOffset.x + self.mainView.tw_width * 0.5) / self.mainView.tw_width;
//    if([self.delegate respondsToSelector:@selector(cycleScrollView:didEndScrollToIndex:)]){
//        [self.delegate cycleScrollView:self didEndScrollToIndex:itemIndex];
//    }
}

#pragma makr - dealloc
- (void)dealloc {
    _mainView.delegate = nil;
    _mainView.dataSource = nil;
}

@end
