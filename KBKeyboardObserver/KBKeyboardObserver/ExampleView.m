//
//  ExampleView.m
//  KBKeyboardObserver
//
//  Created by Kamil Borzym on 27.10.2013.
//  Copyright (c) 2013 Killer Ball. All rights reserved.
//

#import "ExampleView.h"

@interface ExampleView ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UITextView *statusTextView;
@property (nonatomic, strong) UILabel *bottomLabel;

@end

@implementation ExampleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textField];
        [self addSubview:self.button];
        [self addSubview:self.statusTextView];
        [self addSubview:self.bottomLabel];
    }
    return self;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.placeholder = @"Type me :)";
    }
    return _textField;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_button setTitle:@"DONE" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    return _button;
}

- (UITextView *)statusTextView
{
    if (!_statusTextView) {
        _statusTextView = [[UITextView alloc] init];
        _statusTextView.alwaysBounceVertical = YES;
        _statusTextView.editable = NO;
    }
    return _statusTextView;
}

- (UILabel *)bottomLabel
{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.text = @"BOTTOM LABEL";
    }
    return _bottomLabel;
}

- (void)setKeyboardHeight:(CGFloat)keyboardHeight
{
    if (_keyboardHeight != keyboardHeight) {
        _keyboardHeight = keyboardHeight;
        self.statusTextView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0);
        self.statusTextView.scrollIndicatorInsets = self.statusTextView.contentInset;
        [self layoutBottomLabel];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.textField sizeToFit];
    self.textField.frame = CGRectMake(0, 0, self.bounds.size.width, self.textField.frame.size.height);
    
    [self.button sizeToFit];
    CGFloat buttonY = self.textField.frame.origin.y + self.textField.frame.size.height;
    self.button.frame = CGRectMake(0, buttonY, self.bounds.size.width, self.button.frame.size.height);
    
    CGFloat statusViewY = self.button.frame.origin.y + self.button.frame.size.height;
    self.statusTextView.frame = CGRectMake(0, statusViewY,
                                           self.bounds.size.width, self.bounds.size.height - statusViewY);
    
    [self layoutBottomLabel];
}

- (void)layoutBottomLabel
{
    [self.bottomLabel sizeToFit];
    CGRect bottomLabelRect = self.bottomLabel.frame;
    bottomLabelRect.origin.x = self.bounds.size.width - self.bottomLabel.frame.size.width;
    bottomLabelRect.origin.y = self.bounds.size.height - bottomLabelRect.size.height - self.keyboardHeight;
    self.bottomLabel.frame = bottomLabelRect;
}

@end
