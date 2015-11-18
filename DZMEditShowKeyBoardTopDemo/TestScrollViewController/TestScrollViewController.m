//
//  TestScrollViewController.m
//  DZMEditShowKeyBoardTopDemo
//
//  Created by haspay on 15/11/18.
//  Copyright © 2015年 DZM. All rights reserved.
//

#import "TestScrollViewController.h"
#import "DZMEditShowKeyBoardTop.h"
@interface TestScrollViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textOne;
@property (weak, nonatomic) IBOutlet UITextField *textTwo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TestScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [DZMEditShowKeyBoardTop addKeyBoardNotificationWithObject:self];
    
    self.textOne.delegate = self;
    self.textTwo.delegate = self;
    self.textView.delegate = self;
}

#pragma mark -- 键盘开始显示
- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    [DZMEditShowKeyBoardTop keyboardWillShowNotification:notification scrollView:self.scrollview maxY:[DZMEditShowKeyBoardTop editShowKeyBoardTop].maxY];
}

//#pragma mark -- 键盘结束显示
//- (void)keyboardDidShowNotification:(NSNotification *)notification
//{
//    [DZMEditShowKeyBoardTop keyboardDidShowNotification:notification scrollView:self.scrollview maxY:[DZMEditShowKeyBoardTop editShowKeyBoardTop].maxY];
//}

#pragma mark -- 键盘开始隐藏
- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    [DZMEditShowKeyBoardTop keyboardWillHideNotification:notification scrollView:self.scrollview];
}








#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // 只要在编辑框没有出来键盘之前的代理方法里面都可以 不用区分在那个子控件文件里面 我这边就直接放在了控制器里做示范 你可以直接放到子控件的子控件里面 都行只要在开始编辑的代理方法里面加上这句话
    [DZMEditShowKeyBoardTop maxYWithView:textField];
    
    return YES;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [DZMEditShowKeyBoardTop maxYWithView:textView];
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
