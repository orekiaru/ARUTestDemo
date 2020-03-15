//
//  GCDComputeViewController.m
//  ARUTestDemo
//
//  Created by aru oreki on 2020/3/15.
//  Copyright © 2020 aru oreki. All rights reserved.
//

#import "GCDComputeViewController.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "AFNetWorkingViewController.h"
@interface GCDComputeViewController ()
@property (nonatomic) UIButton * button;
@end

@implementation GCDComputeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"next" style:UIBarButtonItemStyleDone target:self action:nil];
    [nextButton setRac_command:[[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            ///发送数据
//            [subscriber sendNext:@"执行完命令之后产生的数据"];
//            NSLog(@"llll");
            AFNetWorkingViewController *nextViewController = [[AFNetWorkingViewController alloc]init];
            [self.navigationController pushViewController:nextViewController animated:YES];
            return nil;
        }];
    }]];
    self.navigationItem.rightBarButtonItem = nextButton;
    
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectZero];
    [button setTitle:@"GCD计算" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _button = button;
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.top.equalTo(self.view.mas_top).with.offset(100);
    }];
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self asyncConcurrent];
        [self sumOfList];
    }];
    
}


- (long)addContWithStart:(int)start end:(int)end
{
    long sum = 0;
    for(long i=start; i <= end ;i++)
    {
        sum += i;
    }
    return sum;
}
- (void)asyncConcurrent {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    static long sum;
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphoreLock = dispatch_semaphore_create(1);
    
    CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
    
    dispatch_group_async(group, queue, ^{
        /// 追加任务
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        sum += [self addContWithStart:0 end:(1000000000/4)];
        dispatch_semaphore_signal(semaphoreLock);
    });
    dispatch_group_async(group, queue, ^{
        /// 追加任务
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        sum += [self addContWithStart:(1000000000/4) end:(1000000000/2)];
        dispatch_semaphore_signal(semaphoreLock);
    });
    
    dispatch_group_async(group, queue, ^{
        /// 追加任务
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        sum += [self addContWithStart:(1000000000/2) end:(1000000000*3/4)];
        dispatch_semaphore_signal(semaphoreLock);
    });
    dispatch_group_async(group, queue, ^{
        /// 追加任务
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        sum += [self addContWithStart:(1000000000*3/4) end:1000000000];
        dispatch_semaphore_signal(semaphoreLock);
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"%ld",sum);
        CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
        NSLog(@"Linked in %f ms", linkTime *1000.0);
    });
    
}


- (void)sumOfList
{
    long sum = 0;
    CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
    for (long i = 1 ;i < 1000000000 ;i++)
    {
        sum +=i;
    }
    NSLog(@"%ld",sum);
    CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"Linked in %f ms", linkTime *1000.0);
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
