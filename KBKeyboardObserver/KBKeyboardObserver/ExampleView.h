//
//  ExampleView.h
//  KBKeyboardObserver
//
//  Created by Kamil Borzym on 27.10.2013.
//  Copyright (c) 2013 Killer Ball. All rights reserved.
//

@interface ExampleView : UIView

@property (nonatomic, readonly) UITextField *textField;
@property (nonatomic, readonly) UIButton *button;
@property (nonatomic, readonly) UITextView *statusTextView;
@property (nonatomic, readonly) UILabel *bottomLabel;

@property (nonatomic, assign) CGFloat visibleKeyboardHeight;

@end
