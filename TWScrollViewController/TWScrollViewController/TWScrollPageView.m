//
//  TWScrollPageView.m
//  TWScrollViewController
//
//  Created by HaKim on 16/5/10.
//  Copyright © 2016年 haKim. All rights reserved.
//

#import "TWScrollPageView.h"
#import "DJDConstant.h"

@interface TWScrollPageView ()<TWCycleScrollViewDelegate>

@property (strong, nonatomic) TWSegmentStyle *segmentStyle;
@property (weak, nonatomic) TWScrollSegmentView *segmentView;
@property (weak, nonatomic) TWCycleScrollView *cycleScrollView;

@property (strong, nonatomic) NSArray *contentViews;
@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation TWScrollPageView

- (instancetype)initWithFrame:(CGRect)frame segmentStyle:(TWSegmentStyle *)segmentStyle contentViews:(NSArray *)contentViews titles:(NSArray*)titles{
    if (self = [super initWithFrame:frame]) {
        self.contentViews = contentViews;
        self.segmentStyle = segmentStyle;
        self.titlesArray = titles;
        [self commonInit];
    }
    return self;
}

#pragma mark - UI
- (void)commonInit {
    [self setupSegmentView];
    [self setupCycleScrollView];
}

- (void)setupSegmentView{
    WeakSelf(weakSelf);
    CGFloat w = self.bounds.size.width;
    TWScrollSegmentView *segmentView = [[TWScrollSegmentView alloc]initWithFrame:CGRectMake(0, 0, w, 44) segmentStyle:self.segmentStyle titles:self.titlesArray titleDidClick:^(UIButton *btn, NSInteger index) {
        [weakSelf.cycleScrollView scrollToPageWithIndex:index];
    }];
    [self addSubview:segmentView];
    self.segmentView = segmentView;
}

- (void)setupCycleScrollView{
    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    
    CGFloat segmentX = CGRectGetMaxY(self.segmentView.frame);
    CGFloat segmetHeight = self.segmentView.frame.size.height;
    
    TWCycleScrollView *cycleScrollView = [TWCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, segmentX, w, h - segmetHeight) shouldInfiniteLoop:NO viewsGroup:self.contentViews];
    cycleScrollView.delegate = self;
    [self addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(TWCycleScrollView *)cycleScrollView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress{
    //DLog(@"fromIndex = %@, toIndex = %@,progress = %@",@(fromIndex),@(toIndex),@(progress));
    [self.segmentView adjustUIWithProgress:progress oldIndex:fromIndex currentIndex:toIndex];
}

- (void)cycleScrollView:(TWCycleScrollView *)cycleScrollView didEndScrollToIndex:(NSInteger)index{
    [self.segmentView adjustTitleOffSetToCurrentIndex:index];
    [self.segmentView adjustUIWithProgress:1.0 oldIndex:index currentIndex:index];
}

- (void)cycleScrollView:(TWCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"--->>>点击了第%ld个view", (long)index);
}

#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"TWScrollPageView--dealloc");
}

@end
