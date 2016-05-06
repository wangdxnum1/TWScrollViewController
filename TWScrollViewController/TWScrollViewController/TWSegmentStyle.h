//
//  TWSegmentStyle.h
//  TWScrollViewController
//
//  Created by HaKim on 16/5/6.
//  Copyright © 2016年 haKim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TWSegmentStyle : NSObject

//是否显示遮盖
@property (nonatomic, assign) BOOL showCover;

// 是否显示下划线
@property (nonatomic, assign) BOOL showLine;

// 是否缩放文字
@property (nonatomic, assign) BOOL scaleTitle;

// 是否可以滚动标题
@property (nonatomic, assign) BOOL scrollTitle;

// 是否颜色渐变
@property (nonatomic, assign) BOOL gradualChangeTitleColor;

// 是否显示附加的按钮
@property (nonatomic, assign) BOOL showExtraButton;

@property (nonatomic, copy) NSString *extraBtnBackgroundImageName;

// 下面的滚动条的高度 默认2
@property (nonatomic, assign) CGFloat scrollLineHeight;

// 下面的滚动条的颜色
@property (nonatomic, strong) UIColor *scrollLineColor;

// 遮盖的背景颜色
@property (nonatomic, strong) UIColor *coverBackgroundColor;

// 遮盖圆角
@property (nonatomic, assign) CGFloat coverCornerRadius;

// cover的高度 默认28
@property (nonatomic, assign) CGFloat coverHeight;

// 文字间的间隔 默认15
@property (nonatomic, assign) CGFloat titleMargin;

// 文字 字体 默认14.0
@property (nonatomic, strong) UIFont *titleFont;

// 放大倍数 默认1.3
@property (nonatomic, assign) CGFloat titleBigScale;

// 默认倍数 不可修改
@property (nonatomic, assign,readonly) CGFloat titleOriginalScale;

// 文字正常状态颜色 请使用RGB空间的颜色值!! 如果提供的不是RGB空间的颜色值就可能crash
@property (nonatomic, strong) UIColor *normalTitleColor;

// 文字选中状态颜色 请使用RGB空间的颜色值!! 如果提供的不是RGB空间的颜色值就可能crash
@property (nonatomic, strong) UIColor *selectedTitleColor;

@end
