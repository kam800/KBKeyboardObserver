//
//  ExampleViewController.m
//  KBKeyboardObserver
//
//  Created by Kamil Borzym on 15.10.2013.
//  Copyright (c) 2013 Killer Ball. All rights reserved.
//

#import "ExampleViewController.h"
#import "ExampleView.h"
#import "KBKeyboardObserver.h"

@interface ExampleViewController () <KBKeyboardObserverDelegate>

@property (nonatomic, strong) KBKeyboardObserver *keyboardObserver;

@property (nonatomic, strong) ExampleView *exampleView;

@end

@implementation ExampleViewController

- (ExampleView *)exampleView
{
    if (!_exampleView) {
        _exampleView = [[ExampleView alloc] init];
    }
    return _exampleView;
}

#pragma mark - Lifecycle

- (void)loadView
{
    self.view = self.exampleView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.keyboardObserver = [self registerForKeyboardNotifications:self];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.exampleView.button addTarget:self
                                action:@selector(buttonPressed:)
                      forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - Actions

- (void)buttonPressed:(UIButton *)button
{
    [self.exampleView.textField resignFirstResponder];
}

#pragma mark - KBKeyboardObserverDelegate

- (void)keyboardObserver:(KBKeyboardObserver *)keyboardObserver observedKeyboardWillShowToRect:(CGRect)keyboardRect duration:(NSTimeInterval)duration
{
    [self updateStatus:[NSString stringWithFormat:@"Will show to %@ in %f", NSStringFromCGRect(keyboardRect), duration]];
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.exampleView.keyboardHeight = keyboardRect.size.height;
                     }
                     completion:nil];
}

- (void)keyboardObserver:(KBKeyboardObserver *)keyboardObserver observedKeyboardDidShowToRect:(CGRect)keyboardRect
{
    [self updateStatus:[NSString stringWithFormat:@"Did show to %@", NSStringFromCGRect(keyboardRect)]];
}

- (void)keyboardObserver:(KBKeyboardObserver *)keyboardObserver observedKeyboardWillHideToRect:(CGRect)keyboardRect duration:(NSTimeInterval)duration
{
    [self updateStatus:[NSString stringWithFormat:@"Will hide to %@ in %f", NSStringFromCGRect(keyboardRect), duration]];
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.exampleView.keyboardHeight = 0;
                     }
                     completion:nil];
}

- (void)keyboardObserver:(KBKeyboardObserver *)keyboardObserver observedKeyboardDidHideToRect:(CGRect)keyboardRect
{
    [self updateStatus:[NSString stringWithFormat:@"Did hide to %@", NSStringFromCGRect(keyboardRect)]];
}

- (void) updateStatus:(NSString *)status
{
    NSString *newStatusLine = [NSString stringWithFormat:@"%@\n%@\nPREV:%@\nCURR:%@\n----\n", [[NSDate alloc] init], status, NSStringFromCGRect(self.keyboardObserver.previousKeyboardBounds), NSStringFromCGRect(self.keyboardObserver.currentKeyboardBounds)];
    self.exampleView.statusTextView.text = [self.exampleView.statusTextView.text stringByAppendingString:newStatusLine];
    [self.exampleView.statusTextView scrollRangeToVisible:NSMakeRange([self.exampleView.statusTextView.text length], 0)];
}

@end
