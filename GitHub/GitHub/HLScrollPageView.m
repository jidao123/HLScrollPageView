//
//  HLScrollPageView.m
//  ll
//
//  Created by jidao on 16/6/27.
//  Copyright © 2016年 黄磊. All rights reserved.
//

#import "HLScrollPageView.h"
#import "UIImageView+WebCache.h"

@interface HLScrollPageView () <UIScrollViewDelegate>


@property (nonatomic ,strong) UIScrollView *hlScrollView;

@property (nonatomic ,strong) UIPageControl *hlPageControl;

@property (nonatomic ,strong) NSTimer *hlTimer;

@end

@implementation HLScrollPageView


-(instancetype)initHLScrollPageViewFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)setHlImageAry:(NSArray *)hlImageAry
{
    _hlImageAry = hlImageAry;
    
    [self setUpScrollView:hlImageAry];
    [self setUpImage:hlImageAry];
    [self setUpPageControl:hlImageAry];
    [self.hlTimer invalidate];
    [self startTimer];
}

-(void)setHlDuration:(NSTimeInterval)hlDuration{
    _hlDuration = hlDuration;
    [self.hlTimer invalidate];
    [self startTimer];
}


-(void)setUpScrollView:(NSArray *)array
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pageViewClick:)];
    [scrollView addGestureRecognizer:tapGesture];
    [self addSubview:scrollView];
    self.hlScrollView = scrollView;
}

-(void)setUpImage:(NSArray *)array
{
    CGSize contentSize;
    CGPoint startPoint;
    if (array.count > 1) {
        for (int i = 0 ; i < array.count + 2; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            if (i == 0) {
                
       
                _hlIsWebImage==YES?[imageView sd_setImageWithURL:[NSURL URLWithString:array[array.count - 1]] placeholderImage:[UIImage imageNamed:@"h043"]]:(imageView.image = [UIImage imageNamed:array[array.count - 1]]);
            }else if(i == array.count + 1){
              
                _hlIsWebImage==YES?[imageView sd_setImageWithURL:[NSURL URLWithString:array[0]] placeholderImage:[UIImage imageNamed:@"h043"]]:(imageView.image = [UIImage imageNamed:array[0]]);
            }else{
               
                _hlIsWebImage==YES?[imageView sd_setImageWithURL:[NSURL URLWithString:array[i - 1]] placeholderImage:[UIImage imageNamed:@"h043"]]:(imageView.image = [UIImage imageNamed:array[i - 1]]);
            }
            [self.hlScrollView addSubview:imageView];
            contentSize = CGSizeMake((array.count + 2) * self.frame.size.width,0);
            startPoint = CGPointMake(self.frame.size.width, 0);
        }
    }else{ 
        for (int i = 0; i < array.count; i ++) {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];

            _hlIsWebImage==YES?[imageView sd_setImageWithURL:[NSURL URLWithString:array[i]] placeholderImage:[UIImage imageNamed:@"h043"] ]:(imageView.image = [UIImage imageNamed:array[i]]);
            
            [self addSubview:imageView];
        }
        contentSize = CGSizeMake(self.frame.size.width, 0);
        startPoint = CGPointZero;
    }
   
    self.hlScrollView.contentOffset = startPoint;
    self.hlScrollView.contentSize = contentSize;
}

-(void)setUpPageControl:(NSArray *)array
{
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.superview.backgroundColor = [UIColor whiteColor];
    pageControl.numberOfPages = array.count;
    pageControl.currentPage = 0;
    CGSize pageSize = [pageControl sizeForNumberOfPages:array.count];
    pageControl.bounds = CGRectMake(0, 0, pageSize.width, pageSize.height);
    pageControl.center = CGPointMake(self.center.x, self.frame.size.height - 20);
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:200/255.f green:200/255.f blue:200/255.f alpha:0.2];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:pageControl];
    self.hlPageControl = pageControl;
    
}

-(void)pageChange:(UIPageControl *)page
{
    CGFloat x = page.currentPage * self.bounds.size.width;
    [self.hlScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

-(void)startTimer
{
    if (!_hlDuration) {
        self.hlTimer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }else{
        self.hlTimer = [NSTimer timerWithTimeInterval:_hlDuration target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    }
    [[NSRunLoop currentRunLoop] addTimer:self.hlTimer forMode:NSRunLoopCommonModes];
}

-(void)updateTimer
{
    CGPoint newOffset = CGPointMake(self.hlScrollView.contentOffset.x  + CGRectGetWidth(self.hlScrollView.frame), 0);
    [self.hlScrollView setContentOffset:newOffset animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView.contentOffset.x < self.frame.size.width) {
        [self.hlScrollView setContentOffset:CGPointMake(self.frame.size.width * (self.hlImageAry.count + 1), 0) animated:NO];
    }
   
    if (scrollView.contentOffset.x > self.frame.size.width * (self.hlImageAry.count + 1)) {
        [self.hlScrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    }
    int pageCount = scrollView.contentOffset.x / self.frame.size.width;
    
    if (pageCount > self.hlImageAry.count) {
        pageCount = 0;
    }else if (pageCount == 0){
        pageCount = (int)self.hlImageAry.count - 1;
    }else{
        pageCount--;
    }
    self.hlPageControl.currentPage = pageCount;
}

- (void)pageViewClick:(UITapGestureRecognizer *)tap
{
    [self.delegate HLdidSelectPageViewWithNumber:self.hlPageControl.currentPage];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.hlTimer invalidate];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}
@end