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
/** 是否显示遮盖 默认为NO */
@property (assign, nonatomic, getter=isShowCover) BOOL showCover;
/** 是否显示滚动条 默认为NO*/
@property (assign, nonatomic, getter=isShowLine) BOOL showLine;
/** 是否缩放标题 默认为NO*/
@property (assign, nonatomic, getter=isScaleTitle) BOOL scaleTitle;
/** 是否滚动标题 默认为YES 设置为NO的时候所有的标题将不会滚动, 和系统的segment效果相似 */
@property (assign, nonatomic, getter=isScrollTitle) BOOL scrollTitle;
/** 是否颜色渐变 默认为NO*/
@property (assign, nonatomic, getter=isGradualChangeTitleColor) BOOL gradualChangeTitleColor;
/** 是否显示附加的按钮 默认为NO*/
@property (assign, nonatomic, getter=isShowExtraButton) BOOL showExtraButton;
/** 设置附加按钮的背景图片 默认为nil*/
@property (strong, nonatomic) NSString *extraBtnBackgroundImageName;
/** 滚动条的高度 默认为2 */
@property (assign, nonatomic) CGFloat scrollLineHeight;
/** 滚动条的颜色 */
@property (strong, nonatomic) UIColor *scrollLineColor;
/** 遮盖的颜色 */
@property (strong, nonatomic) UIColor *coverBackgroundColor;
/** 遮盖的圆角 默认为14*/
@property (assign, nonatomic) CGFloat coverCornerRadius;
/** 遮盖的高度 默认为28*/
@property (assign, nonatomic) CGFloat coverHeight;
/** 标题之间的间隙 默认为15.0 */
@property (assign, nonatomic) CGFloat titleMargin;
/** 标题的字体 默认为14 */
@property (strong, nonatomic) UIFont *titleFont;
/** 标题缩放倍数, 默认1.3 */
@property (assign, nonatomic) CGFloat titleBigScale;
/** 标题一般状态的颜色 */
@property (strong, nonatomic) UIColor *normalTitleColor;
/** 标题选中状态的颜色 */
@property (strong, nonatomic) UIColor *selectedTitleColor;
/** segmentVIew的高度, 这个属性只在使用ZJScrollPageVIew的时候设置生效 */
@property (assign, nonatomic) CGFloat segmentHeight;

////是否显示遮盖
//@property (nonatomic, assign) BOOL showCover;
//
//// 是否显示下划线
//@property (nonatomic, assign) BOOL showLine;
//
//// 是否缩放文字
//@property (nonatomic, assign) BOOL scaleTitle;
//
//// 是否可以滚动标题
//@property (nonatomic, assign) BOOL scrollTitle;
//
//// 是否颜色渐变
//@property (nonatomic, assign) BOOL gradualChangeTitleColor;
//
//// 是否显示附加的按钮
//@property (nonatomic, assign) BOOL showExtraButton;
//
//@property (nonatomic, copy) NSString *extraBtnBackgroundImageName;
//
//// 下面的滚动条的高度 默认2
//@property (nonatomic, assign) CGFloat scrollLineHeight;
//
//// 下面的滚动条的颜色
//@property (nonatomic, strong) UIColor *scrollLineColor;
//
//// 遮盖的背景颜色
//@property (nonatomic, strong) UIColor *coverBackgroundColor;
//
//// 遮盖圆角
//@property (nonatomic, assign) CGFloat coverCornerRadius;
//
//// cover的高度 默认28
//@property (nonatomic, assign) CGFloat coverHeight;
//
//// 文字间的间隔 默认15
//@property (nonatomic, assign) CGFloat titleMargin;
//
//// 文字 字体 默认14.0
//@property (nonatomic, strong) UIFont *titleFont;
//
//// 放大倍数 默认1.3
//@property (nonatomic, assign) CGFloat titleBigScale;
//
//// 默认倍数 不可修改
//@property (nonatomic, assign,readonly) CGFloat titleOriginalScale;
//
//// 文字正常状态颜色 请使用RGB空间的颜色值!! 如果提供的不是RGB空间的颜色值就可能crash
//@property (nonatomic, strong) UIColor *normalTitleColor;
//
//// 文字选中状态颜色 请使用RGB空间的颜色值!! 如果提供的不是RGB空间的颜色值就可能crash
//@property (nonatomic, strong) UIColor *selectedTitleColor;

@end
