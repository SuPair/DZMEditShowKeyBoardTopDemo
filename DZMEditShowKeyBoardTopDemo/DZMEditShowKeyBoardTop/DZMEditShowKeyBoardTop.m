//
//  DZMEditShowKeyBoardTop.m
//  DZMEditShowKeyBoardTopDemo
//
//  Created by haspay on 15/11/18.
//  Copyright © 2015年 DZM. All rights reserved.
//

#import "DZMEditShowKeyBoardTop.h"
@interface DZMEditShowKeyBoardTop()
@property (nonatomic,assign) CGSize currentSize;                      // 记录滚动控件原来的contensize
@property (nonatomic,assign) BOOL isOK;
@end
@implementation DZMEditShowKeyBoardTop
/**
 *  获取对象（单利）
 *
 *  @return DZMEditShowKeyBoardTop
 */
+ (DZMEditShowKeyBoardTop *)editShowKeyBoardTop
{
    static DZMEditShowKeyBoardTop *editShowKeyBoardTop = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        editShowKeyBoardTop = [[DZMEditShowKeyBoardTop alloc] init];
    });
    
    return editShowKeyBoardTop;
}

/**
 *  为一个对象添加键盘监听通知
 *
 *  @param object 对象（建议是UIViewController，其他不保证出错误）
 */
+ (void)addKeyBoardNotificationWithObject:(id)object
{
    // 警告不用管 你传进来的对象实现需要的方法就行了
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    // 监听键盘开始显示
    if ([object respondsToSelector:@selector(keyboardWillShowNotification:)]) {
        
        [notificationCenter addObserver:object selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    }
    
    if ([object respondsToSelector:@selector(keyboardDidShowNotification:)]) {
        
        // 监听键盘结束显示
        [notificationCenter addObserver:object selector:@selector(keyboardDidShowNotification:) name:UIKeyboardDidShowNotification object:nil];
    }
    
    if ([object respondsToSelector:@selector(keyboardWillHideNotification:)]) {
        
        // 监听键盘开始隐藏
        [[NSNotificationCenter defaultCenter] addObserver:object selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    if ([object respondsToSelector:@selector(keyboardDidHideNotification:)]) {
        
        // 监听键盘结束隐藏
        [notificationCenter addObserver:object selector:@selector(keyboardDidHideNotification:) name:UIKeyboardDidHideNotification object:nil];
    }
   
    if ([object respondsToSelector:@selector(keyboardWillChangeFrameNotification:)]) {
        
        // 监听键盘改变frame
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
            [[NSNotificationCenter defaultCenter] addObserver:object selector:@selector(keyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:nil];
        }
    }
}



/**
 *  传入一个输入框获取输入框的最大Y值
 *
 *  @param view 编辑的输入框
 *
 *  @return 当前控件在当前界面的最大Y值
 */
+ (CGFloat)maxYWithView:(UIView *)view
{
    DZMEditShowKeyBoardTop *object = [DZMEditShowKeyBoardTop editShowKeyBoardTop];
  
    object.maxY = [DZMEditShowKeyBoardTop getMaxYWithView:view];
    
    return object.maxY;
}

/**
 *  获取位置得出最大Y值
 *
 *  @param view view
 *
 *  @return 最大Y值
 */
+ (CGFloat)getMaxYWithView:(UIView *)view
{
    // 获取当前输入框在当前屏幕上得位置
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    CGRect rect = [view convertRect:view.bounds toView:window];
    CGFloat maxY = CGRectGetMaxY(rect);
    return maxY;
}

/**
 *  键盘开始显示的适合 输入框一起弹到键盘上边 （显示）则在键盘监听方法keyboardWillShowNotification里面调用即可
 *
 *  @param notification 键盘通知的notification
 *  @param scrollView   一个能滚动的view
 *  @param maxY         输入控件的最大Y值 需要键盘与输入框中间有一点间距 可以通过单利取出 maxY + 间距值 就可以了
 */
+ (void)keyboardWillShowNotification:(NSNotification *)notification scrollView:(UIScrollView *)scrollView maxY:(CGFloat)maxY
{
    [DZMEditShowKeyBoardTop keyboardDidShowNotification:notification scrollView:scrollView maxY:maxY];
}

/**
 *  键盘显示完毕 后 输入框弹到键盘上边 （显示）则在键盘监听方法keyboardDidShowNotification里面调用即可
 *
 *  @param notification 键盘通知的notification
 *  @param scrollView   一个能滚动的view
 *  @param maxY         输入控件的最大Y值 （如果不传值 会去单利对象里那通过maxYWithView初始化过得最大Y值）
 *  但是由于考虑这个MaxY说不定有些需要键盘与输入框中间有一点间距 可以通过单利取出 maxY + 间距值 就可以了
 */
+ (void)keyboardDidShowNotification:(NSNotification *)notification scrollView:(UIScrollView *)scrollView maxY:(CGFloat)maxY
{
    DZMEditShowKeyBoardTop *object = [DZMEditShowKeyBoardTop editShowKeyBoardTop];
    
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    float keyboardAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    CGFloat keyboardY = keyboardFrame.origin.y;

    if (maxY > keyboardY) {
        
        if (!object.isOK) {
            
            object.isOK = YES;
            
            if (scrollView.contentSize.height < scrollView.frame.size.height) {
                
                object.currentSize = CGSizeMake(0, scrollView.frame.size.height);
                
            }else{
                
                object.currentSize = scrollView.contentSize;
            }
            scrollView.contentSize = CGSizeMake(0, object.currentSize.height + keyboardFrame.size.height - ([UIScreen mainScreen].bounds.size.height - [DZMEditShowKeyBoardTop getMaxYWithView:scrollView]));
           
        }
        
        [UIView animateWithDuration:keyboardAnimationDuration animations:^{
          
            scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y + (maxY - keyboardY));
        }];
    }
}

/**
 *  键盘开始隐藏 的时候 跟着退下去 （隐藏）则在键盘监听方法keyboardWillHideNotification里面调用即可
 *
 *  @param notification 键盘通知的notification
 *  @param scrollView   一个能滚动的view
 */
+ (void)keyboardWillHideNotification:(NSNotification *)notification scrollView:(UIScrollView *)scrollView
{
    DZMEditShowKeyBoardTop *object = [DZMEditShowKeyBoardTop editShowKeyBoardTop];
    
    float keyboardAnimationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
        [UIView animateWithDuration:keyboardAnimationDuration animations:^{
            
            scrollView.contentSize = object.currentSize;
            
        } completion:^(BOOL finished) {
            
            object.isOK = NO;
            
            object.currentSize = CGSizeMake(0, 0);
        }];
   
}
@end
