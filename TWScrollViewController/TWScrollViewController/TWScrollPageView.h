//
//  TWScrollPageView.h
//  TWScrollViewController
//
//  Created by HaKim on 16/5/10.
//  Copyright © 2016年 haKim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWScrollSegmentView.h"
#import "TWCycleScrollView.h"

typedef void(^ExtraBtnOnClick)(UIButton *extraBtn);
@interface TWScrollPageView : UIView

@property (copy, nonatomic) ExtraBtnOnClick extraBtnOnClick;

- (instancetype)initWithFrame:(CGRect)frame segmentStyle:(TWSegmentStyle *)segmentStyle contentViews:(NSArray *)contentViews titles:(NSArray*)titles;

/** 给外界设置选中的下标的方法 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;

/**  给外界重新设置视图内容的标题的方法 */
- (void)reloadChildVcsWithNewChildVcs:(NSArray *)newChildVcs;

@end
