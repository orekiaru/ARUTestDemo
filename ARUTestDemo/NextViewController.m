//
//  NextViewController.m
//  ARUTestDemo
//
//  Created by aru oreki on 2020/3/15.
//  Copyright © 2020 aru oreki. All rights reserved.
//

#import "NextViewController.h"
#import "GCDComputeViewController.h"
#import <Masonry/Masonry.h>
@interface NextViewController ()

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"替代delelgate";
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"next" style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.rightBarButtonItem = nextButton;
    [nextButton setRac_command:[[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            GCDComputeViewController *nextViewController = [[GCDComputeViewController alloc]init];
            [self.navigationController pushViewController:nextViewController animated:YES];
            return nil;
        }];
    }]];
    // Do any additional setup after loading the view.
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    [button setTitle:@"发送数据" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.top.equalTo(self.view.mas_top).with.offset(100);
    }];
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        if(self.delegateSignal)
        {
            [self.delegateSignal sendNext:@"666"];
        }
    }];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
