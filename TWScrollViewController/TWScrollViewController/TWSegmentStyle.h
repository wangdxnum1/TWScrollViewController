//
//  TWSegmentStyle.h
//  TWScrollViewController
//
//  Created by HaKim on 16/5/6.
//  Copyright © 2016年 haKim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TWSegmentStyle : NSObject

//是否显示遮盖
@property (nonatomic, assign) BOOL showCover;

// 是否显示下划线
@property (nonatomic, assign) BOOL showLine;

// 是否缩放文字
@property (nonatomic, assign) BOOL scaleTitle;
@end
