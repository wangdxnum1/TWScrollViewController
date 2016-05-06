//
//  TWSegmentStyle.m
//  TWScrollViewController
//
//  Created by HaKim on 16/5/6.
//  Copyright © 2016年 haKim. All rights reserved.
//

#import "TWSegmentStyle.h"

@implementation TWSegmentStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.showCover = NO;
        self.showLine = NO;
        self.scaleTitle = NO;
        self.scrollTitle = YES;
        self.gradualChangeTitleColor = NO;
        self.showExtraButton = NO;
        self.scrollLineHeight = 2.0;
        self.scrollLineColor = [UIColor brownColor];
        self.coverBackgroundColor = [UIColor lightGrayColor];
        self.coverCornerRadius = 14.0;
        self.coverHeight = 28.0;
        self.titleFont = [UIFont systemFontOfSize:14.0];
        self.titleBigScale = 1.3;
        _titleOriginalScale = 1.0;
        self.normalTitleColor = [UIColor colorWithRed:51.0/255.0 green:53.0/255.0 blue:75.0/255.0 alpha:1.0];
        self.selectedTitleColor = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:121.0/255.0 alpha:1.0];
    }
    return self;
}

@end
