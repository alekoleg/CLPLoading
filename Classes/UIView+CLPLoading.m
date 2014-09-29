//
//  UIView+CLPLoading.m
//  ColparterLoadingExample
//
//  Created by Alekseenko Oleg on 09.09.14.
//  Copyright (c) 2014 alekoleg. All rights reserved.
//

#import "UIView+CLPLoading.h"
#import <objc/runtime.h>

static UIFont *CLPLabelTextFont = nil;
static UIColor *CLPTextColor = nil;
static UIColor *CLPActivityColor = nil;
static CGFloat CLPTextMaxWidth = 270;

@implementation UIView (CLPLoading)

#pragma mark - API -

- (UIActivityIndicatorView *)clp_showLoading
{
    return [self clp_showLoadingWithCustomText:nil];
}

- (UIActivityIndicatorView *)clp_showLoadingWithText {
    return [self clp_showLoadingWithCustomText:NSLocalizedString(@"clp_loading", nil)];
}

- (UIActivityIndicatorView *)clp_showLoadingWithCustomText:(NSString *)text {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0, 0, 44, 44);
    if (CLPActivityColor) {
        indicator.color = CLPActivityColor;
    } else {
        indicator.color = self.tintColor;
    }

    [indicator startAnimating];
    
    UIView *container = [[UIView alloc] initWithFrame:indicator.frame];
    [container addSubview:indicator];
    
    if (text) {
        UILabel *label = [self _clp_labelWithFrame:CGRectMake(40, 0, CLPTextMaxWidth, container.frame.size.height) text:text];
        label.numberOfLines = 1;
        label.frame = ({
            CGRect frame = label.frame;
            frame.size.width = ceil([label.text boundingRectWithSize:CGSizeMake(CLPTextMaxWidth, container.frame.size.height) options:NSStringDrawingUsesDeviceMetrics attributes:@{ NSFontAttributeName : label.font }  context:NULL].size.width);
            frame.size.height = container.frame.size.height;
            frame;
        });

        container.frame = ({
            CGRect frame = container.frame;
            frame.size.width = label.frame.size.width + label.frame.origin.x;
            frame;
        });
        [container addSubview:label];
    }
    [self clp_showCustomView:container];
    return indicator;
}

- (void)clp_showLoadingWithImage:(UIImage *)image
{
    UIImageView *view = [[UIImageView alloc] initWithImage:image];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationRepeatCount:HUGE_VAL];
    view.transform = CGAffineTransformMakeRotation(M_PI);
    [UIView commitAnimations];
    [self clp_showCustomView:view];
}

- (void)clp_showLoadingWithImages:(NSArray *)images
{
    CGSize size = [[images firstObject] size];
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    view.contentMode = UIViewContentModeCenter;
    view.animationImages = images;
    view.animationDuration = 0.1;
    view.animationRepeatCount = HUGE_VAL;
    [self clp_showCustomView:view];
}

- (void)clp_showError:(NSString *)error retryBlock:(CLPLoadingEmptyBlock)retry
{
    [self clp_showError:error withImage:nil retryButton:NSLocalizedString(@"clp_error_retry", nil) otherButton:nil retryBlock:retry otherButton:NULL];
}

- (void)clp_showError:(NSString *)error retryButton:(NSString *)retryButton otherButton:(NSString *)otherButton retryBlock:(CLPLoadingEmptyBlock)retry otherButton:(CLPLoadingEmptyBlock)otherBlock
{
    [self clp_showError:error withImage:nil retryButton:retryButton otherButton:otherButton retryBlock:retry otherButton:otherBlock];
}

- (void)clp_showError:(NSString *)error withImage:(UIImage *)image retryBlock:(CLPLoadingEmptyBlock)retry
{
    [self clp_showError:error withImage:image retryButton:NSLocalizedString(@"clp_error_retry", nil) otherButton:nil retryBlock:retry otherButton:NULL];
}

- (void)clp_showError:(NSString *)error withImage:(UIImage *)image retryButton:(NSString *)retryButtonTitle otherButton:(NSString *)otherButtonTitle retryBlock:(CLPLoadingEmptyBlock)retry otherButton:(CLPLoadingEmptyBlock)otherBlock
{
    self.otherBlock = otherBlock;
    self.retryBlock = retry;
    
    float verticalBetween = 10;
    float horizontalBetween = 5;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    UILabel *label = [self _clp_labelWithFrame:CGRectMake(0, 0, CLPTextMaxWidth, 100) text:error];

    float maxWidth = MAX(label.frame.size.width, imageView.frame.size.width);
    float buttonWidth = maxWidth / 2 - 2 * horizontalBetween;
    UIButton *retryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, 44)];
    [retryButton setTitle:otherButtonTitle forState:UIControlStateNormal];
    [retryButton addTarget:self action:@selector(clp_retryClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *otherButton = nil;
    if (otherButtonTitle) {
        otherButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, 44)];
        [otherButton setTitle:otherButtonTitle forState:UIControlStateNormal];
        [otherButton addTarget:self action:@selector(clp_otherButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    float viewHegiht = imageView.frame.size.height + label.frame.size.height + retryButton.frame.size.height + verticalBetween * 4 + verticalBetween * (image != nil);

    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, maxWidth, viewHegiht)];
    if (imageView) {
        [container addSubview:imageView];
        imageView.frame = ({
            CGRect frame = imageView.frame;
            frame.origin.x = (container.frame.size.width - frame.size.width) / 2;
            frame.origin.y = verticalBetween;
            frame;
        });
    }
    
    [container addSubview:label];
    label.frame = ({
        CGRect frame = label.frame;
        frame.origin.x = (container.frame.size.width - frame.size.width) / 2;
        frame.origin.y = verticalBetween + (image != nil) * (imageView.frame.size.height + imageView.frame.origin.y);
        frame;
    });
    
    [container addSubview:retryButton];
    retryButton.frame = ({
        CGRect frame = retryButton.frame;
        frame.origin.x = (container.frame.size.width - frame.size.width) / 2 - (otherButton != nil) * (otherButton.frame.size.width - horizontalBetween) / 2;
        frame.origin.y = label.frame.origin.y + label.frame.size.height + 2 * verticalBetween;
        frame;
    });
    
    if (otherButton) {
        [container addSubview:otherButton];
        otherButton.frame = ({
            CGRect frame = otherButton.frame;
            frame.origin.x = retryButton.frame.size.width + retryButton.frame.origin.x + horizontalBetween;
            frame.origin.y = retryButton.frame.origin.y;
            frame;
        });
    }

    [self clp_showCustomView:container];
}

- (void)clp_showCustomView:(UIView *)view
{
    [self clp_showCustomView:view animated:NO];
}

- (void)clp_showCustomView:(UIView *)view animated:(BOOL)animated
{
    [self _positionView:view];
    if (self.presentView) {
        __weak typeof(self) weakSelf = self;
        [self _replaceView:self.presentView withView:view animated:animated complete:^{
            weakSelf.presentView = view;
        }];
    } else {
        self.presentView = view;
        [self _hideSubviewsWithShowView:self.presentView animated:animated complete:NULL];
    }
}

- (void)clp_hideAll {
    if ([self presentView]) {
        __weak typeof(self) weakSelf = self;
        [self _restoreSubviewsWithRemoveView:self.presentView animated:YES complete:^{
            [weakSelf.presentView removeFromSuperview];
            weakSelf.presentView = nil;
            [weakSelf setSubViewsAlphas:nil];
            [weakSelf setRetryBlock:nil];
            [weakSelf setOtherBlock:nil];
        }];
    }
}

#pragma mark - Variables -

- (void)setPresentView:(UIView *)presentView {
    objc_setAssociatedObject(self, @selector(setPresentView:), presentView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIView *)presentView {
    return objc_getAssociatedObject(self, @selector(setPresentView:));
}

- (void)setSubViewsAlphas:(NSArray *)subViewsAlphas {
    objc_setAssociatedObject(self, @selector(setSubViewsAlphas:), subViewsAlphas, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)subViewsAlphas {
    return objc_getAssociatedObject(self, @selector(setSubViewsAlphas:));
}

- (void)setRetryBlock:(CLPLoadingEmptyBlock)retryBlock {
    objc_setAssociatedObject(self, @selector(retryBlock), retryBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CLPLoadingEmptyBlock)retryBlock {
    return objc_getAssociatedObject(self, @selector(retryBlock));
}

- (void)setOtherBlock:(CLPLoadingEmptyBlock)otherBlock {
    objc_setAssociatedObject(self, @selector(otherBlock), otherBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CLPLoadingEmptyBlock)otherBlock {
    return objc_getAssociatedObject(self, @selector(otherBlock));
}

#pragma mark - Actions -

- (void)_hideSubviewsWithShowView:(UIView *)showView animated:(BOOL)animated complete:(CLPLoadingEmptyBlock)complete
{
    NSMutableArray *array = [NSMutableArray array];
    for (UIView *view in self.subviews) {
        [array addObject:@(view.alpha)];
    }
    self.subViewsAlphas = [array copy];
    showView.alpha = 0.0;
    [self addSubview:showView];
    
    void (^animationBlock) (void) = ^{
        for (UIView *view in self.subviews) {
            view.alpha = 0.0;
        }
        showView.alpha = 1.0;
    };
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:animationBlock];
    } else {
        animationBlock();
    }
}

- (void)_restoreSubviewsWithRemoveView:(UIView *)view animated:(BOOL)animated complete:(CLPLoadingEmptyBlock)complete
{
    void (^animationBlock) (void) = ^{
        int index = 0;
        for (UIView *v in self.subviews) {
            if (v != view) {
                if (index < self.subViewsAlphas.count) {
                    v.alpha = [self.subViewsAlphas[index] floatValue];
                } else {
                    v.alpha = 1.0;
                }
                index++;
            }
        }
        view.alpha = 0.0;
    };
    
    if (animationBlock) {
        [UIView animateWithDuration:0.3 animations:animationBlock completion:^(BOOL finished) {
            [view removeFromSuperview];
            if (complete) {
                complete();
            }
        }];
    } else {
        animationBlock();
        if (complete) {
            complete();
        }
    }
}

- (void)_replaceView:(UIView *)view withView:(UIView *)newView animated:(BOOL)animated complete:(CLPLoadingEmptyBlock)complete
{
    newView.alpha = 0.0;
    [self addSubview:newView];
    void (^animationBlock) (void) = ^{
        newView.alpha = 0.0;
        view.alpha = 1.0;
    };
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:animationBlock completion:^(BOOL finished) {
            [view removeFromSuperview];
            if (complete) {
                complete();
            }
        }];
    } else {
        animationBlock();
        [view removeFromSuperview];
        if (complete) {
            complete();
        }
    }
}

- (void)_positionView:(UIView *)view
{
    view.frame = ({
        CGRect frame = view.frame;
        frame.origin.x = (self.frame.size.width - frame.size.width) * 0.5;
        frame.origin.y = (self.frame.size.height - frame.size.height) * 0.5;
        frame;
    });
}

- (UILabel *)_clp_labelWithFrame:(CGRect)frame text:(NSString *)text {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = (CLPTextColor != nil) ? CLPTextColor : [UIColor blackColor];
    if (CLPLabelTextFont) {
        label.font = CLPLabelTextFont;
    }
    label.text = text;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textAlignment = NSTextAlignmentCenter;
    label.frame = ({
        CGRect frame = label.frame;
        frame.size.height = ceilf([label.text boundingRectWithSize:CGSizeMake(frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes: @{ NSFontAttributeName: label.font} context:NULL].size.height);
        frame;
    });
    return label;
}

#pragma mark - Actions -

- (void)clp_retryClicked:(id)sender
{
    if (self.retryBlock) {
        self.retryBlock();
    }
}

- (void)clp_otherButtonClicked:(id)sender
{
    if (self.otherBlock) {
        self.otherBlock();
    }
}


#pragma mark - Global UI setup -

+ (void)clp_setTextLabelColor:(UIColor *)color
{
    CLPTextColor = color;
}

+ (void)clp_setTextLabelFont:(UIFont *)font
{
    CLPLabelTextFont = font;
}

+ (void)clp_setActivityIndicatorColor:(UIColor *)color {
    CLPActivityColor = color;
}

+ (void)clp_setTextLabelMaxWidth:(CGFloat)width {
    CLPTextMaxWidth = width;
}


@end
