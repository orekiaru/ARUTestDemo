//
//  ViewController.m
//  ARUTestDemo
//
//  Created by aru oreki on 2020/3/14.
//  Copyright © 2020 aru oreki. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Masonry/Masonry.h>
#import "NextViewController.h"
@interface ViewController ()
@property (nonatomic) UIButton *button;
@property (nonatomic) UITextField *textField;
@property (nonatomic) NSString *name;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"按钮和输入框RAC监听";
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"next" style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.rightBarButtonItem = nextButton;
    [nextButton setRac_command:[[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input)
    {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber)
        {
           
            NextViewController *nextViewController = [[NextViewController alloc]init];
            nextViewController.delegateSignal = [RACSubject subject];
            [nextViewController.delegateSignal subscribeNext:^(id  _Nullable x) {
                NSLog(@"View %@",x);
            }];
            [self.navigationController pushViewController:nextViewController animated:YES];
            return nil;
        }];
        
    }]];
    
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    [button setTitle:@"test" forState:UIControlStateNormal];
    _button = button;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.top.equalTo(self.view.mas_top).with.offset(100);
    }];
    
    [[_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"you click test button");
        /* 创建信号 */
        RACSubject *subject = [RACSubject subject];
        
        /* 发送信号 */
        [subject sendNext:@"发送信号"];
    }];
    
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectZero];
    _textField = textField;
    textField.placeholder = @"input";
    [self.view addSubview:textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.top.equalTo(self.button.mas_top).with.offset(50);
    }];
    
    [[textField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        return value.length > 3;
    }]
     subscribeNext:^(NSString * _Nullable x) {
         NSLog(@"%@",x);
//         self->_name = x;
     }];
    

}



@end
