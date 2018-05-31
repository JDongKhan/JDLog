//
//  JDLogViewController.m
//  JDLog
//
//  Created by JD on 2018/5/30.
//  Copyright © 2018年 JD. All rights reserved.
//

#import "JDLogViewController.h"
#import "JDLogFileManager.h"

@interface JDLogViewController ()<UITextViewDelegate> {
    BOOL _scrollBottomAble;
}

@property (nonatomic, strong) UITextView *textView;

@end

@implementation JDLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"控制台";
    _scrollBottomAble = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.delegate = self;
    self.textView.editable = NO;
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.textView];
    
    //两种实现方式，第一种监听文件变化
    __weak JDLogViewController *weakSelf = self;
    [[JDLogFileManager shareInstance] watcherLog:^(NSInteger type) {
        [weakSelf updateTextView];
    }];
    //第二种用CADisplayLink定时刷
//    _link = [CADisplayLink displayLinkWithTarget:weakSelf selector:@selector(updateTextView)];
//    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清理" style:UIBarButtonItemStyleDone target:self action:@selector(clear)];
    // Do any additional setup after loading the view.
}

- (void)updateTextView {
    self.textView.text = [[JDLogFileManager shareInstance] readLog];
    if (_scrollBottomAble) {
        [self scrollToBottom];
    }
}

- (void)scrollToBottom {
    CGFloat y = (self.textView.contentSize.height - self.textView.frame.size.height) > 0 ? (self.textView.contentSize.height - self.textView.frame.size.height) : 0;
    [self.textView setContentOffset:CGPointMake(0, y) animated:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _scrollBottomAble = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == (self.textView.contentSize.height - self.textView.frame.size.height)) {
        _scrollBottomAble = YES;
    }
}

- (void)clear {
    self.textView.text = nil;
    self.textView.contentOffset = CGPointZero;
    [[JDLogFileManager shareInstance] clearLog];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc {
    [[JDLogFileManager shareInstance] stopWatcher];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
