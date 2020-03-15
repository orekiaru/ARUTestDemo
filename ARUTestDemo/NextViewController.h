//
//  NextViewController.h
//  ARUTestDemo
//
//  Created by aru oreki on 2020/3/15.
//  Copyright © 2020 aru oreki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>
NS_ASSUME_NONNULL_BEGIN

@interface NextViewController : UIViewController
@property (nonatomic) RACSubject *delegateSignal;
@end

NS_ASSUME_NONNULL_END
