//
//  ViewController.m
//  StarChiTools
//
//  Created by 池鑫 on 2019/7/29.
//  Copyright © 2019 9964858. All rights reserved.
//

#import "ViewController.h"
#import <StarChiTools.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [btn setTitle:@"TouchMe" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.center = self.view.center;
    [self.view addSubview:btn];
}

-(void)btnClick:(UIButton*)sender{
    TextViewAlertView* view = [[TextViewAlertView alloc]initWithTitle:@"输入文字" message:nil clickSureBlock:^(TextViewAlertView *alertView) {
        [sender setTitle:alertView.textView.text forState:UIControlStateNormal];
    }];
    
    [view showInView:self.view];
}

@end
