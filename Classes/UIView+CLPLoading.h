//
//  UIView+CLPLoading.h
//  ColparterLoadingExample
//
//  Created by Alekseenko Oleg on 09.09.14.
//  Copyright (c) 2014 alekoleg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CLPLoadingEmptyBlock)(void);

@interface UIView (CLPLoading)

/**
 *   Shows UIActivityIndicatorView
 */
- (UIActivityIndicatorView *)clp_showLoading;
- (UIActivityIndicatorView *)clp_showLoadingWithStyle:(UIActivityIndicatorViewStyle)style;
- (UIActivityIndicatorView *)clp_showLoadingWithColor:(UIColor *)color;

/**
 *   Shows UIActivityIndicatorView with text Localizable key @"clp_loading"
 */
- (UIActivityIndicatorView *)clp_showLoadingWithText;

/**
 *   Shows UIActivityIndicatorView with text
 */
- (UIActivityIndicatorView *)clp_showLoadingWithCustomText:(NSString *)text;

/**
 *   Shows rotatining Image
 */
- (void)clp_showLoadingWithImage:(UIImage *)image;

/**
 *   Shows animtaion with Images
 *   UIImageView.animationImages = images
 */
- (void)clp_showLoadingWithImages:(NSArray *)images;

/**
 *   Show error title with retry button. With Localizable key @"clp_error_retry"
 */
- (void)clp_showError:(NSString *)error retryBlock:(CLPLoadingEmptyBlock)retry;

/**
 *   Can show addition button if otherButton != nil
 */
- (void)clp_showError:(NSString *)error retryButton:(NSString *)retryButton otherButton:(NSString *)otherButton retryBlock:(CLPLoadingEmptyBlock)retry otherButton:(CLPLoadingEmptyBlock)otherBlock;

/**
 *   Show Images above error string
 */
- (void)clp_showError:(NSString *)error withImage:(UIImage *)image retryBlock:(CLPLoadingEmptyBlock)retry;
- (void)clp_showError:(NSString *)error withImage:(UIImage *)image retryButton:(NSString *)retryButton otherButton:(NSString *)otherButton retryBlock:(CLPLoadingEmptyBlock)retry otherButton:(CLPLoadingEmptyBlock)otherBlock;

/**
 *   Hide all subviews and shows view
 */
- (void)clp_showCustomView:(UIView *)view;
- (void)clp_showCustomView:(UIView *)view animated:(BOOL)animated;

/**
 *   Remove all loading, error, view. And restore subviews.
 */
- (void)clp_hideAll;
- (void)clp_hideAllWithAnimation:(BOOL)animated postAnimationBlock:(CLPLoadingEmptyBlock)postAnimation complete:(CLPLoadingEmptyBlock)complete;

//Global UI setup
+ (void)clp_setTextLabelColor:(UIColor *)color;
+ (void)clp_setTextLabelFont:(UIFont *)font;
+ (void)clp_setActivityIndicatorColor:(UIColor *)color;
+ (void)clp_setTextLabelMaxWidth:(CGFloat)width;
+ (void)clp_setButtonTextColor:(UIColor *)color;

@end
