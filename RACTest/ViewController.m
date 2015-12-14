//
//  ViewController.m
//  RACTest
//
//  Created by qinfensky on 15/12/13.
//  Copyright © 2015年 qinfensky. All rights reserved.
//


#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self RACSignalTest];
//    [self RACSubjectTest];
    [self RACDict];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)RACDict {
    
    /**
     *  遍历数组
     */
    NSArray *arry = @[@"a",@"b",@"c",@"d",@"e"];
    [arry.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"x is %@", x);
    }];
    
    /**
     *  元祖遍历字典
     */
    NSDictionary *dict = @{@"a":@"b",@"c":@"d",@"e":@"F"};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        NSLog(@"key is %@, value is %@", x[0], x[1]);
    }];
    
}

- (IBAction)aaaa:(id)sender {
    _a = [NSString stringWithFormat:@"%ld", random()];

}

- (void) RACSignalTest {
    // RACSignal使用步骤：
    // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
    // 2.订阅信号,才会激活信号. - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 - (void)sendNext:(id)value
    
    
    // RACSignal底层实现：
    // 1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
    // 2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
    // 2.2 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中。
    // 2.1 subscribeNext内部会调用siganl的didSubscribe
    // 3.siganl的didSubscribe中调用[subscriber sendNext:@1];
    // 3.1 sendNext底层其实就是执行subscriber的nextBlock
    
    // 1.创建信号
    
    RACSignal *singnal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"adada"];
        [subscriber sendCompleted];
        
        
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号已销毁");
        }];
        
    }];
    
    [singnal subscribeNext:^(NSString *str) {
        
        NSLog(@"接收心数据为%@", str);
    }];
    [singnal subscribeNext:^(NSString *str) {
        
        NSLog(@"接收心ssss数据为%@", str);
    }];
}


- (void)RACSubjectTest {
    
    // RACSubject使用步骤
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 3.发送信号 sendNext:(id)value
    
    // RACSubject:底层实现和RACSignal不一样。
    // 1.调用subscribeNext订阅信号，只是把订阅者保存起来，并且订阅者的nextBlock已经赋值了。
    // 2.调用sendNext发送信号，遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    
//    // 1.创建信号
//    RACSubject *subject = [RACSubject subject];
//    
//    // 2.订阅信号
//    [subject subscribeNext:^(id x) {
//        // block调用时刻：当信号发出新值，就会调用.
//        NSLog(@"第一个订阅者%@",x);
//    }];
//    [subject subscribeNext:^(id x) {
//        // block调用时刻：当信号发出新值，就会调用.
//        NSLog(@"第二个订阅者%@",x);
//    }];
//    
//    // 3.发送信号
//    [subject sendNext:@"1"];
    
    
    // RACReplaySubject使用步骤:
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.可以先订阅信号，也可以先发送信号。
    // 2.1 订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 2.2 发送信号 sendNext:(id)value
    
    // RACReplaySubject:底层实现和RACSubject不一样。
    // 1.调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    // 2.调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock
    
    // 如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
    // 也就是先保存值，在订阅值。
    
    // 1.创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    // 2.发送信号
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
    // 3.订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第一个订阅者接收到的数据%@",x);
    }];
    
    // 订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第二个订阅者接收到的数据%@",x);
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
