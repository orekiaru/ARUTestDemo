//
//  AFNetWorkingViewController.m
//  ARUTestDemo
//
//  Created by aru oreki on 2020/3/15.
//  Copyright © 2020 aru oreki. All rights reserved.
//

#import "AFNetWorkingViewController.h"
#import <AFNetworking.h>
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
@interface AFNetWorkingViewController ()

@end

@implementation AFNetWorkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"AFN测试";
    // Do any additional setup after loading the view.
    UIButton * getButton = [[UIButton alloc] init];
    [getButton setTitle:@"get" forState:UIControlStateNormal];
    [getButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:getButton];
    [getButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.top.equalTo(self.view.mas_top).with.offset(100);
    }];
    
    [[getButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self getTest];
    }];
    
    UIButton * postButton = [[UIButton alloc] init];
    [postButton setTitle:@"post" forState:UIControlStateNormal];
    [postButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:postButton];
    [postButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.top.equalTo(getButton.mas_top).with.offset(20);
    }];
    
    [[postButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [self postTest];
    }];
    
}


- (void)getTest
{
    /// 1.创建一个请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    
    /// 2.GET请求
    [manager GET:@"http://127.0.0.1:5000" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功：%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",error);
    }];
}

- (void)postTest
{
    /// 1.创建一个请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    /// 2.POST请求
    [manager POST:@"http://127.0.0.1:5000/login" parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功：%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求成功：%@",error);
    }];
}

- (void)fileDownloadTest
{
    /// 1.创建会话管理者
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    
    NSURL *url = [NSURL URLWithString:@"http://101.132.173.156:18080/shared//C8892FC2410C48E7A2C1DE8FC72CC5B1.jpg"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    /// 2.下载文件
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        /// 监听下载进度
        /// completedUnitCount 已经下载的数据大小
        /// totalUnitCount     文件数据的中大小
        NSLog(@"%f",1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        NSLog(@"targetPath:%@",targetPath);
        NSLog(@"fullPath:%@",fullPath);
        
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        NSLog(@"%@",filePath);
    }];
    
    //3.执行Task
    [download resume];
}

- (void)uploadTest
{
    /// 1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //    NSDictionary *dictM = @{}
    /// 2.发送post请求上传文件
    [manager POST:@"http://168.192.1.18:33322/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        UIImage *image = [UIImage imageNamed:@"Snip20160227_128"];
        NSData *imageData = UIImagePNGRepresentation(image);
        
        //使用formData来拼接数据
        /*
         第一个参数:二进制数据 要上传的文件参数
         第二个参数:服务器规定的
         第三个参数:该文件上传到服务器以什么名称保存
         */
        //[formData appendPartWithFileData:imageData name:@"file" fileName:@"xxxx.png" mimeType:@"image/png"];
        
        //[formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/Users/Da/Desktop/Snip20160227_128.png"] name:@"file" fileName:@"123.png" mimeType:@"image/png" error:nil];
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:@"/Users/xiaomage/Desktop/Snip20160227_128.png"] name:@"file" error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传成功---%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败---%@",error);
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
