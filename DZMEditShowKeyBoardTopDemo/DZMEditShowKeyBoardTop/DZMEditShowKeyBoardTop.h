//
//  DZMEditShowKeyBoardTop.h
//  DZMEditShowKeyBoardTopDemo
//
//  Created by haspay on 15/11/18.
//  Copyright © 2015年 DZM. All rights reserved.
//

/**
 
 #pragma mark -- 键盘开始显示
 - (void)keyboardWillShowNotification:(NSNotification *)notification;
 
 #pragma mark -- 键盘结束显示
 - (void)keyboardDidShowNotification:(NSNotification *)notification;
 
 #pragma mark -- 键盘开始隐藏
 - (void)keyboardWillHideNotification:(NSNotification *)notification;
 
 #pragma mark -- 键盘结束隐藏
 - (void)keyboardDidHideNotification:(NSNotification *)notification;
 
 #pragma mark -- 键盘开始改变frame
 - (void)keyboardWillChangeFrameNotification:(NSNotification*)notification;
 
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DZMEditShowKeyBoardTop : NSObject
/**
 *  获取对象（单利）
 *
 *  @return DZMEditShowKeyBoardTop
 */
+ (DZMEditShowKeyBoardTop *)editShowKeyBoardTop;

/** 添加通知之后 实现方法已在上面写好 拷贝过去即可 可以根据需要实现 不一定要全部拿过去
 *  (注意：只有实现了的方法才会添加通知成功，没有实现方法的不会进行添加通知 确保了多余通知的添加)
 *  为一个对象添加键盘监听通知 切记不要重复添加通知了（注意 ：只帮忙添加通知 不帮忙删除 删除就一句话 系统的 自己需要删除的时候在自己添加的那个界面子自己看情况删除通知吧）
 *
 *  @param object 对象（建议是UIViewController，其他不保证出错误）
 */
+ (void)addKeyBoardNotificationWithObject:(id)object;

/**
 *  传入一个输入框获取输入框的最大Y值 （留了多个口 这个用于初始化MaxY 也会返回MaxY 方便在实现通知界面使用）
 *
 *  @param view 编辑的输入框
 */
+ (CGFloat)maxYWithView:(UIView *)view;
/**
 *   当前正在编辑的输入框最大Y值
 *   这个最大Y值就是上面方法初始化之后得到的MaxY 用于在别的界面使用对象获得使用
 */
@property (nonatomic,assign) CGFloat maxY;

#pragma mark - 以下几个效果   总之 调用一个显示 跟一个隐藏 就好了  一对一就行了 调用多了就要出问题的额。。。。先说明
/**
 *  键盘开始显示的适合 输入框一起弹到键盘上边 （显示）则在键盘监听方法keyboardWillShowNotification里面调用即可
 *
 *  @param notification 键盘通知的notification
 *  @param scrollView   一个能滚动的view
 *  @param maxY         输入控件的最大Y值 需要键盘与输入框中间有一点间距 可以通过单利取出 maxY + 间距值 就可以了
 */
+ (void)keyboardWillShowNotification:(NSNotification *)notification scrollView:(UIScrollView *)scrollView maxY:(CGFloat)maxY;
/**
 *  键盘显示完毕 后 输入框弹到键盘上边 （显示）则在键盘监听方法keyboardDidShowNotification里面调用即可
 *
 *  @param notification 键盘通知的notification
 *  @param scrollView   一个能滚动的view
 *  @param maxY         输入控件的最大Y值 需要键盘与输入框中间有一点间距 可以通过单利取出 maxY + 间距值 就可以了
 */
+ (void)keyboardDidShowNotification:(NSNotification *)notification scrollView:(UIScrollView *)scrollView maxY:(CGFloat)maxY;

/**
 *  键盘开始隐藏 的时候 跟着退下去(注意 只有编辑框在滚动) （隐藏）则在键盘监听方法keyboardWillHideNotification里面调用即可
 *
 *  @param notification 键盘通知的notification
 *  @param scrollView   一个能滚动的view
 */
+ (void)keyboardWillHideNotification:(NSNotification *)notification scrollView:(UIScrollView *)scrollView;
@end
