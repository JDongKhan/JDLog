//
//  JDLogViewController.m
//  JDLog
//
//  Created by JD on 2018/5/30.
//  Copyright © 2018年 JD. All rights reserved.
//

#import "JDLogViewController.h"
#import "JDLogFileManager.h"

@interface JDLogViewController ()<UITextViewDelegate,UITextFieldDelegate> {
    BOOL _scrollBottomAble;
}

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIView *searchView;

@property (nonatomic, strong) UITextField *searchTextField;

@end

@implementation JDLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"控制台";
    _scrollBottomAble = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat bottomHeight = 60;
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-bottomHeight)];
    self.textView.delegate = self;
    self.textView.editable = NO;
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.textView];
    
    self.searchView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-bottomHeight, self.view.bounds.size.width, bottomHeight)];
    self.searchView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.searchView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.searchView.frame.size.width, 0.5)];
    lineView.backgroundColor = [UIColor lightGrayColor];
    lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.searchView addSubview:lineView];
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.searchView.frame.size.width-20, self.searchView.frame.size.height-20)];
    self.searchTextField.placeholder = @"输入你想查找的关键字";
    self.searchTextField.returnKeyType = UIReturnKeyDone;
    self.searchTextField.delegate = self;
    [self.searchView addSubview:self.searchTextField];
    
    
    
    //两种实现方式，第一种监听文件变化
    __weak JDLogViewController *weakSelf = self;
    [[JDLogFileManager shareInstance] watcherLog:^(NSInteger type) {
        [weakSelf updateTextView];
    }];
    //第二种用CADisplayLink定时刷
//    _link = [CADisplayLink displayLinkWithTarget:weakSelf selector:@selector(updateTextView)];
//    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清理" style:UIBarButtonItemStyleDone target:self action:@selector(clear)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillSHow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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

- (void)keyboardWillSHow:(NSNotification *)notification {
    //获取键盘高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    NSInteger height = keyboardRect.size.height;
    CGRect frame = self.searchView.frame;
    frame.origin.y = self.view.bounds.size.height - height - frame.size.height;
    self.searchView.frame = frame;
    
    CGRect textViewFrame = self.textView.frame;
    textViewFrame.size.height = frame.origin.y;
    self.textView.frame = textViewFrame;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect frame = self.searchView.frame;
    frame.origin.y = self.view.bounds.size.height  - frame.size.height;
    self.searchView.frame = frame;
    
    CGRect textViewFrame = self.textView.frame;
    textViewFrame.size.height = frame.origin.y;
    self.textView.frame = textViewFrame;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *regex = @"^\n[.]*\n$";
    NSString *string = textField.text;
    NSRegularExpression *regularExpretion = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *arrayOfAllMatches = [regularExpretion matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *match in  arrayOfAllMatches) {
        NSString *subStringForMatch = [string substringWithRange:match.range];
        NSLog(@"%@",subStringForMatch);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
