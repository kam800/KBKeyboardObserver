//
//  KBKeyboardObserver.m
//  KBKeyboardObserver
//
//  Created by Kamil Borzym on 15.10.2013.
//  Copyright (c) 2013 Killer Ball. All rights reserved.
//

#import "KBKeyboardObserver.h"

@interface KBKeyboardObserver ()

@property (nonatomic, assign) BOOL keyboardVisible;
@property (nonatomic, assign) CGRect previousKeyboardBounds;
@property (nonatomic, assign) CGRect currentKeyboardBounds;
@property (nonatomic, assign) BOOL interfaceRotation;
@property (nonatomic, assign) BOOL standardKeyboard;
@property (nonatomic, weak) UIView *referenceView;

@end

@implementation KBKeyboardObserver

- (id)initWithReferenceView:(UIView *)referenceView
{
    if (referenceView) {
        self = [super init];
    } else {
        self = nil;
    }
    
    if (self) {
        _referenceView = referenceView;
        [self observeForNotification:UIKeyboardWillShowNotification
                            selector:@selector(keyboardWillShow:)];
        [self observeForNotification:UIKeyboardDidShowNotification
                            selector:@selector(keyboardDidShow:)];
        [self observeForNotification:UIKeyboardWillHideNotification
                            selector:@selector(keyboardWillHide:)];
        [self observeForNotification:UIKeyboardDidHideNotification
                            selector:@selector(keyboardDidHide:)];
        [self observeForNotification:UIKeyboardWillChangeFrameNotification
                            selector:@selector(keyboardWillChangeFrame:)];
        [self observeForNotification:UIKeyboardDidChangeFrameNotification
                            selector:@selector(keyboardDidChangeFrame:)];
        [self observeForNotification:UIApplicationWillChangeStatusBarOrientationNotification
                            selector:@selector(handleWillChangeStatusBarOrientationNotification:)];
        [self observeForNotification:UIApplicationDidChangeStatusBarOrientationNotification
                            selector:@selector(handleDidChangeStatusBarOrientationNotification:)];

    }
    return self;
}

- (void)observeForNotification:(NSString *)notificationName selector:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:selector
                                                 name:notificationName
                                               object:nil];
}

#pragma mark - Notification
- (void)handleWillChangeStatusBarOrientationNotification:(NSNotification*)aNotification
{
    _interfaceRotation = YES;
}

- (void)handleDidChangeStatusBarOrientationNotification:(NSNotification*)aNotification
{
    _interfaceRotation = NO;
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    if (self.interfaceRotation) {
        return;
    }
    _standardKeyboard = YES;
    
    if ([self.delegate respondsToSelector:@selector(keyboardObserver:observedKeyboardWillShowToRect:duration:)]) {
        NSDictionary *info = aNotification.userInfo;
        CGRect kbRectEnd = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect viewKbRectEnd = [self.referenceView convertRect:kbRectEnd fromView:nil];
        NSTimeInterval duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue] ;
        [self.delegate keyboardObserver:self
         observedKeyboardWillShowToRect:viewKbRectEnd
                               duration:duration];
    }
}

- (void)keyboardDidShow:(NSNotification*)aNotification
{
    if (self.interfaceRotation) {
        return;
    }

    _standardKeyboard = NO;
    NSDictionary *info = aNotification.userInfo;
    CGRect kbRectBegin = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect kbRectEnd = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.previousKeyboardBounds = [self.referenceView convertRect:kbRectBegin fromView:nil];
    self.currentKeyboardBounds = [self.referenceView convertRect:kbRectEnd fromView:nil];
    if ([self.delegate respondsToSelector:@selector(keyboardObserver:observedKeyboardDidShowToRect:)]) {
        [self.delegate keyboardObserver:self
          observedKeyboardDidShowToRect:self.currentKeyboardBounds];
    }
}

- (void)keyboardWillHide:(NSNotification*)aNotification
{
    if (self.interfaceRotation) {
        return;
    }

    _standardKeyboard = YES;

    if ([self.delegate respondsToSelector:@selector(keyboardObserver:observedKeyboardWillHideToRect:duration:)]) {
        NSDictionary *info = aNotification.userInfo;
        CGRect kbRectEnd = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect viewKbRectEnd = [self.referenceView convertRect:kbRectEnd fromView:nil];
        NSTimeInterval duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue] ;
        [self.delegate keyboardObserver:self
         observedKeyboardWillHideToRect:viewKbRectEnd
                               duration:duration];
    }
}

- (void)keyboardDidHide:(NSNotification*)aNotification
{
    if (self.interfaceRotation) {
        return;
    }
    
    _standardKeyboard = NO;
    
    NSDictionary *info = aNotification.userInfo;
    CGRect kbRectBegin = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect kbRectEnd = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.previousKeyboardBounds = [self.referenceView convertRect:kbRectBegin fromView:nil];
    self.currentKeyboardBounds = [self.referenceView convertRect:kbRectEnd fromView:nil];
    if ([self.delegate respondsToSelector:@selector(keyboardObserver:observedKeyboardDidHideToRect:)]) {
        [self.delegate keyboardObserver:self
          observedKeyboardDidHideToRect:self.currentKeyboardBounds];
    }
}

- (void)keyboardWillChangeFrame:(NSNotification*)aNotification
{
    if (self.interfaceRotation)
    {
        return;
    }
    
    NSDictionary *info = aNotification.userInfo;
    CGRect kbRectEnd = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue] ;
    CGRect viewKbRectEnd = [self.referenceView convertRect:kbRectEnd fromView:nil];
    
    _keyboardVisible = CGRectContainsRect(self.referenceView.frame, viewKbRectEnd);

    if(CGRectContainsRect(self.referenceView.frame, viewKbRectEnd) && !self.standardKeyboard) {
        if ([self.delegate respondsToSelector:@selector(keyboardObserver:observedKeyboardWillShowToRect:duration:)]) {
            [self.delegate keyboardObserver:self
             observedKeyboardWillShowToRect:viewKbRectEnd
                                   duration:duration];
        }
    } else if (!self.standardKeyboard) {
        if ([self.delegate respondsToSelector:@selector(keyboardObserver:observedKeyboardWillHideToRect:duration:)]) {
            [self.delegate keyboardObserver:self
             observedKeyboardWillHideToRect:viewKbRectEnd
                                   duration:duration];
            }
    }
    
    if ([self.delegate respondsToSelector:@selector(keyboardObserver:observedKeyboardWillChangeFrameToRect:duration:)]) {
        [self.delegate keyboardObserver:self observedKeyboardWillChangeFrameToRect:viewKbRectEnd
                               duration:duration];
    }
}

- (void)keyboardDidChangeFrame:(NSNotification*)aNotification
{
    if (self.interfaceRotation)
    {
        return;
    }
    
    NSDictionary *info = aNotification.userInfo;
    CGRect kbRectEnd = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect viewKbRectEnd = [self.referenceView convertRect:kbRectEnd fromView:nil];
    _keyboardVisible = CGRectContainsRect(self.referenceView.frame, viewKbRectEnd);
    if(self.keyboardVisible && !self.standardKeyboard) {
        if ([self.delegate respondsToSelector:@selector(keyboardObserver:observedKeyboardDidShowToRect:)]) {
            [self.delegate keyboardObserver:self
              observedKeyboardDidShowToRect:viewKbRectEnd];
        }
    } else if (!self.standardKeyboard) {
        if ([self.delegate respondsToSelector:@selector(keyboardObserver:observedKeyboardDidHideToRect:)]) {
            [self.delegate keyboardObserver:self
              observedKeyboardDidHideToRect:viewKbRectEnd];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(keyboardObserver:observedKeyboardDidChangeFrameToRect:)]) {
        [self.delegate keyboardObserver:self
   observedKeyboardDidChangeFrameToRect:viewKbRectEnd];
        
    }
}

#pragma mark -

- (void)dealloc
{
    [self unregister];
}

- (void)unregister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@implementation UIViewController (KBKeyboardObserver)

- (KBKeyboardObserver *)registerForKeyboardNotifications:(id<KBKeyboardObserverDelegate>)delegate
{
    KBKeyboardObserver *observer = [[KBKeyboardObserver alloc] initWithReferenceView:self.view];
    observer.delegate = delegate;
    return observer;
}

#pragma mark - Orientation

@end
