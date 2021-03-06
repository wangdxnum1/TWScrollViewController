//
//  TWCycleScrollView.h
//  TWCycleScrollView
//
//  Created by HaKim on 16/2/26.
//  Copyright © 2016年 haKim. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TWCycleScrollViewPageContolAlimentRight,
    TWCycleScrollViewPageContolAlimentCenter
} TWCycleScrollViewPageContolAliment;

@class TWCycleScrollView;

@protocol TWCycleScrollViewDelegate <NSObject>

@optional

- (void)cycleScrollView:(TWCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

- (void)cycleScrollView:(TWCycleScrollView *)cycleScrollView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)index progress:(CGFloat)progress;

- (void)cycleScrollView:(TWCycleScrollView *)cycleScrollView didEndScrollToIndex:(NSInteger)index;

@end

@interface TWCycleScrollView : UIView

// 数据源接口
@property (nonatomic, strong) NSArray *contentViewsGroup;

// 滚动控制接口

/** 是否无限循环,默认Yes */
@property(nonatomic,assign) BOOL infiniteLoop;

@property (nonatomic, weak) id<TWCycleScrollViewDelegate> delegate;

/** block监听点击方式 */
@property (nonatomic, copy) void (^clickItemOperationBlock)(NSInteger currentIndex);


// 自定义样式接口

/** 是否显示分页控件 */
@property (nonatomic, assign) BOOL showPageControl;

/** 是否在只有个view时隐藏pagecontrol，默认为YES */
@property(nonatomic) BOOL hidesForSinglePage;

/** 分页控件位置 */
@property (nonatomic, assign) TWCycleScrollViewPageContolAliment pageControlAliment;


/** 当前分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *currentPageDotColor;

/** 其他分页控件小圆标颜色 */
@property (nonatomic, strong) UIColor *pageDotColor;

/** 分页控件小圆标大小 */
@property (nonatomic, assign) CGSize pageControlDotSize;


+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame viewsGroup:(NSArray *)viewsGroup;


+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame shouldInfiniteLoop:(BOOL)infiniteLoop viewsGroup:(NSArray *)viewsGroup;

- (void)scrollToPageWithIndex:(NSInteger)index;

// scroll 到下一页
- (void)scrollToNextPage;

// scroll 到上一页
- (void)scrollToPreviousPage;

@end
