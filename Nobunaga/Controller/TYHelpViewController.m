//
//  TYHelpViewController.m
//  Nobunaga
//
//  Created by Tomohiko on 2014/09/27.
//  Copyright (c) 2014年 yamatomo. All rights reserved.
//

#import "TYHelpViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TYHelpViewController ()

@end

@implementation TYHelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  UIScrollView *scrollView = [[UIScrollView alloc] init];
  scrollView.frame = self.view.bounds;
  float width = self.view.bounds.size.width;
  float height = 700;
  scrollView.scrollEnabled = YES;
  
  scrollView.contentSize = CGSizeMake(width, height);
  [self.view addSubview:scrollView];
  
  //背景
  UIImage *background = [UIImage imageNamed:@"Scenario"];
  self.view.backgroundColor = [UIColor colorWithPatternImage:background];
  
  //ベース
  UIView *uv = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-((self.view.bounds.size.width-20)/2), 5, self.view.bounds.size.width-20, 600)];
  uv.backgroundColor = [UIColor whiteColor];
  uv.alpha = 0.7f;
  uv.layer.borderWidth = 6.0f;
  uv.layer.borderColor = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:0.5].CGColor;
  uv.layer.cornerRadius = 5.0f;
  [scrollView addSubview:uv];
  
  //タイトル
  NSString *ttl = @"遊び方";
  UILabel *label = [[UILabel alloc] init];
  label.font = [UIFont fontWithName:@"HirakakuProN-W6" size:24];
  label.frame = CGRectMake(self.view.frame.size.width/2-100, 10 , 200, 30);
  label.textColor = [UIColor whiteColor];
  label.textAlignment = NSTextAlignmentCenter;
  label.text = ttl;
//  [self.view addSubview:label];
  [scrollView addSubview:label];
  //説明ボード
  UIImage *captionImg = [UIImage imageNamed:@"Board"];
  UIImageView *caption = [[UIImageView alloc] initWithImage:captionImg];
  caption.frame = CGRectMake(self.view.bounds.size.width/2-captionImg.size.width/2, 50, captionImg.size.width, captionImg.size.height);
  caption.contentMode = UIViewContentModeCenter;
//  [self.view addSubview:caption];
  [scrollView addSubview:caption];
  //説明
  NSString *description = @"全5ステージをクリアする\nタイムを競うゲーム";
  // LineHeightを指定
  CGFloat customLineHeight = 20.0f;
  // lineHeightをセット
  NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
  paragrahStyle.minimumLineHeight = customLineHeight;
  paragrahStyle.maximumLineHeight = customLineHeight;
  
  // NSAttributedStringを生成してパラグラフスタイルをセット
  NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:description];
  [attributed addAttribute:NSParagraphStyleAttributeName
                         value:paragrahStyle
                         range:NSMakeRange(0, attributed.length)];
  
  UILabel *descLabel = [[UILabel alloc] init];
  descLabel.font = [UIFont fontWithName:@"HirakakuProN-W6" size:14];
  descLabel.frame = CGRectMake(self.view.frame.size.width/2-100, 55, 200, 50);
  descLabel.numberOfLines = 2;
  descLabel.attributedText = attributed;
  descLabel.textColor = [UIColor whiteColor];
  descLabel.textAlignment = NSTextAlignmentLeft;
//  [self.view addSubview:descLabel];
  [scrollView addSubview:descLabel];
  
  //チュートリアル
  UIImage *ttralImgA = [UIImage imageNamed:@"Tutorial1"];
  UIImageView *ttralA = [[UIImageView alloc] initWithImage:ttralImgA];
  ttralA.frame = CGRectMake(self.view.bounds.size.width/2-ttralImgA.size.width/2, 140, ttralImgA.size.width, ttralImgA.size.height);
  ttralA.contentMode = UIViewContentModeCenter;
//  [self.view addSubview:ttralA];
  [scrollView addSubview:ttralA];
  UIImage *ttralImgB = [UIImage imageNamed:@"Tutorial2"];
  UIImageView *ttralB = [[UIImageView alloc] initWithImage:ttralImgB];
  ttralB.frame = CGRectMake(self.view.bounds.size.width/2-ttralImgB.size.width/2, 350, ttralImgB.size.width, ttralImgB.size.height);
  ttralB.contentMode = UIViewContentModeCenter;
  [scrollView addSubview:ttralB];
//  [self.view addSubview:ttralB];
  UIImage *ttralImgC = [UIImage imageNamed:@"Tutorial3"];
  UIImageView *ttralC = [[UIImageView alloc] initWithImage:ttralImgC];
  ttralC.frame = CGRectMake(self.view.bounds.size.width/2-ttralImgC.size.width/2, 480, ttralImgC.size.width, ttralImgC.size.height);
  ttralC.contentMode = UIViewContentModeCenter;
//  [self.view addSubview:ttralC];
  [scrollView addSubview:ttralC];
  
  //戻るボタン
  CGRect rtnFrame = CGRectMake(self.view.frame.size.width/2-70, 630, 140, 50);
  NSString *rtn = @"戻る";
  UIButton *returnBtn = [self makeButton:rtnFrame text:rtn];
  [returnBtn addTarget:self action:@selector(returnTop) forControlEvents:UIControlEventTouchUpInside];
  [scrollView addSubview:returnBtn];
  
}

- (UIButton *)makeButton:(CGRect)rect text:(NSString *)text
{
  UIButton *Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  Btn.titleLabel.font = [UIFont fontWithName:@"HirakakuProN-W6" size:18];
  Btn.layer.borderColor = [[UIColor whiteColor] CGColor];
  Btn.layer.borderWidth = 1.0;
  Btn.layer.cornerRadius = 10;
  [Btn setFrame:rect];
  [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [Btn setTitle:text forState:UIControlStateNormal];
 
  return Btn;
}

- (void)returnTop
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
