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

- (void)keyboardWillShow:(NSNotification*)aNotification
{
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

@end
