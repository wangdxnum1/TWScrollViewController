//
//  ViewController.m
//  TWScrollViewController
//
//  Created by HaKim on 16/5/6.
//  Copyright © 2016年 haKim. All rights reserved.
//

#import "ViewController.h"
#import "TWCycleScrollView.h"
#import "TWScrollSegmentView.h"
#import "UIColor+randomColor.h"
#import "TWSegmentStyle.h"
#import "TWScrollPageView.h"

@interface ViewController ()<TWCycleScrollViewDelegate>
@property (nonatomic, weak) TWCycleScrollView *cycleScrollView;
@property (nonatomic, weak) TWScrollSegmentView *segmentView;
@property (nonatomic, weak) TWScrollPageView *scrollPageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self test2];
}

- (void)test2{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectZero];
    view1.backgroundColor = [UIColor redColor];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectZero];
    view2.backgroundColor = [UIColor greenColor];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectZero];
    view3.backgroundColor = [UIColor blueColor];
    
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectZero];
    view4.backgroundColor = [UIColor orangeColor];
    
    UIView *view5 = [[UIView alloc] initWithFrame:CGRectZero];
    view5.backgroundColor = [UIColor randomColor];
    
    UIView *view6 = [[UIView alloc] initWithFrame:CGRectZero];
    view6.backgroundColor = [UIColor randomColor];
    
    UIView *view7 = [[UIView alloc] initWithFrame:CGRectZero];
    view7.backgroundColor = [UIColor randomColor];
    
    UIView *view8 = [[UIView alloc] initWithFrame:CGRectZero];
    view8.backgroundColor = [UIColor randomColor];
    
    UIView *view9 = [[UIView alloc] initWithFrame:CGRectZero];
    view9.backgroundColor = [UIColor randomColor];
    
    UIView *view10 = [[UIView alloc] initWithFrame:CGRectZero];
    view10.backgroundColor = [UIColor randomColor];
    
    UIView *view11 = [[UIView alloc] initWithFrame:CGRectZero];
    view11.backgroundColor = [UIColor randomColor];
    
    UIView *view12 = [[UIView alloc] initWithFrame:CGRectZero];
    view12.backgroundColor = [UIColor randomColor];
    
    NSArray *views = @[view1,view2,view3,view4,view5,view6,view7,view8,view9,view10,view11,view12];
    
    TWSegmentStyle *style = [[TWSegmentStyle alloc] init];
    //style.scaleTitle = YES;
    
    //显示遮盖
    style.showCover = YES;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    // 显示附加的按钮
    style.showExtraButton = YES;
    // 设置附加按钮的背景图片
    style.extraBtnBackgroundImageName = @"extraBtnBackgroundImage";
    // 设置子控制器 --- 注意子控制器需要设置title, 将用于对应的tag显示title
    NSArray *titles = [NSArray arrayWithArray:[self setupChildVcAndTitle]];
    
    CGRect frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64);
    TWScrollPageView *scrollPageView = [[TWScrollPageView alloc]initWithFrame:frame segmentStyle:style contentViews:views titles:titles];
    [self.view addSubview:scrollPageView];
}

- (void)test1{
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectZero];
    view1.backgroundColor = [UIColor redColor];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectZero];
    view2.backgroundColor = [UIColor greenColor];
    
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectZero];
    view3.backgroundColor = [UIColor blueColor];
    
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectZero];
    view4.backgroundColor = [UIColor orangeColor];
    
    
    NSArray *imageNames = @[view1,view2,view3,view4];
    CGFloat w = self.view.bounds.size.width;
    CGFloat h = self.view.bounds.size.height;
    TWCycleScrollView *cycleScrollView = [TWCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 100, w, h - 100) shouldInfiniteLoop:NO viewsGroup:imageNames];
    cycleScrollView.delegate = self;
    [self.view addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
    
    TWSegmentStyle *style = [[TWSegmentStyle alloc] init];
    
    style.scaleTitle = YES;
    
    //显示遮盖
    style.showCover = YES;
    // 颜色渐变
    style.gradualChangeTitleColor = YES;
    // 显示附加的按钮
    style.showExtraButton = YES;
    // 设置附加按钮的背景图片
    style.extraBtnBackgroundImageName = @"extraBtnBackgroundImage";
    // 设置子控制器 --- 注意子控制器需要设置title, 将用于对应的tag显示title
    NSArray *childVcs = [NSArray arrayWithArray:[self setupChildVcAndTitle]];
    
    TWScrollSegmentView *segmentView = [[TWScrollSegmentView alloc]initWithFrame:CGRectMake(0, 56, w, 44) segmentStyle:style titles:childVcs titleDidClick:^(UIButton *btn, NSInteger index) {
        NSLog(@"title btn clicked");
    }];
    [self.view addSubview:segmentView];
    self.segmentView = segmentView;
    
    //    self.segmentView.backgroundColor = [UIColor randomColor];
}

- (NSArray *)setupChildVcAndTitle {
    
    UIViewController *vc1 = [[UIViewController alloc]init];
    vc1.view.backgroundColor = [UIColor redColor];
    vc1.title = @"新闻头条";
    
    UIViewController *vc2 = [UIViewController new];
    vc2.view.backgroundColor = [UIColor greenColor];
    vc2.title = @"国际要闻";
    
    UIViewController *vc3 = [UIViewController new];
    vc3.view.backgroundColor = [UIColor yellowColor];
    vc3.title = @"体育";
    
    UIViewController *vc4 = [UIViewController new];
    vc4.view.backgroundColor = [UIColor brownColor];
    vc4.title = @"中国足球";
    
    UIViewController *vc5 = [UIViewController new];
    vc5.view.backgroundColor = [UIColor lightGrayColor];
    vc5.title = @"汽车";
    
    UIViewController *vc6 = [UIViewController new];
    vc6.view.backgroundColor = [UIColor orangeColor];
    vc6.title = @"囧途旅游";
    
    UIViewController *vc7 = [UIViewController new];
    vc7.view.backgroundColor = [UIColor cyanColor];
    vc7.title = @"幽默搞笑";
    
    UIViewController *vc8 = [UIViewController new];
    vc8.view.backgroundColor = [UIColor blueColor];
    vc8.title = @"视频";
    
    UIViewController *vc9 = [UIViewController new];
    vc9.view.backgroundColor = [UIColor purpleColor];
    vc9.title = @"无厘头";
    
    UIViewController *vc10 = [UIViewController new];
    vc10.view.backgroundColor = [UIColor magentaColor];
    vc10.title = @"美女图片";
    
    UIViewController *vc11 = [UIViewController new];
    vc11.view.backgroundColor = [UIColor whiteColor];
    vc11.title = @"今日房价";
    
    UIViewController *vc12 = [UIViewController new];
    vc12.view.backgroundColor = [UIColor redColor];
    vc12.title = @"头像";
    
    NSArray *childVcs = [NSArray arrayWithObjects:vc1.title, vc2.title, vc3.title, vc4.title, vc5.title, vc6.title, vc7.title, vc8.title, vc9.title , vc10.title, vc11.title, vc12.title, nil];
    return childVcs;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(TWCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"--->>>点击了第%ld个view", (long)index);
}

@end
