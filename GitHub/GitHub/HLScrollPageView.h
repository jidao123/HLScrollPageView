//
//  HLScrollPageView.h
//  ll
//
//  Created by jidao on 16/6/27.
//  Copyright © 2016年 黄磊. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol HLScrollPageViewDelegate <NSObject>
-(void)HLdidSelectPageViewWithNumber:(NSInteger)SelectNumber;
@end



@interface HLScrollPageView : UIView
@property (nonatomic,strong) NSArray * hlImageAry;
@property (nonatomic,assign) NSTimeInterval hlDuration;
@property (nonatomic,assign) BOOL hlIsWebImage;
@property (nonatomic,weak) id <HLScrollPageViewDelegate> delegate;

-(instancetype)initHLScrollPageViewFrame:(CGRect)frame;
@end

