//
//  KBKeyboardObserver.h
//  KBKeyboardObserver
//
//  Created by Kamil Borzym on 15.10.2013.
//  Copyright (c) 2013 Killer Ball. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KBKeyboardObserver;

@protocol KBKeyboardObserverDelegate <NSObject>

@optional

/**
 Called by the KBKeyboardObserver prior to the display of the keyboard.
 
 @param keyboardObserver observer instance
 @param keyboardRect CGRect value that identifies the end frame of the keyboard in the reference view coordinates
 @param duration duration of the animation in seconds
 */
- (void)keyboardObserver:(KBKeyboardObserver *)keyboardObserver observedKeyboardWillHideToRect:(CGRect)keyboardRect duration:(NSTimeInterval)duration;

/**
 Called by the KBKeyboardObserver after the display of the keyboard.
 
 @param keyboardObserver observer instance
 @param keyboardRect CGRect value that identifies the end frame of the keyboard in the reference view coordinates
 */
- (void)keyboardObserver:(KBKeyboardObserver *)keyboardObserver observedKeyboardDidHideToRect:(CGRect)keyboardRect;

/**
 Called by the KBKeyboardObserver prior to the dismissal of the keyboard.
 
 @param keyboardObserver observer instance
 @param keyboardRect CGRect value that identifies the end frame of the keyboard in the reference view coordinates
 @param duration duration of the animation in seconds
 */
- (void)keyboardObserver:(KBKeyboardObserver *)keyboardObserver observedKeyboardWillShowToRect:(CGRect)keyboardRect duration:(NSTimeInterval)duration;

/**
 Called by the KBKeyboardObserver after the dismissal of the keyboard.
 
 @param keyboardObserver observer instance
 @param keyboardRect CGRect value that identifies the end frame of the keyboard in the reference view coordinates
 */
- (void)keyboardObserver:(KBKeyboardObserver *)keyboardObserver observedKeyboardDidShowToRect:(CGRect)keyboardRect;

@end

@interface KBKeyboardObserver : NSObject

/**
 Initializes the receiver with a reference view. All coordinates and frames produced by the KBKeyboardObserver object will be relative to the reference view.
 
 @param referenceView an UIView object for coordinates reference
 
 @return an initialized object
 */
- (id)initWithReferenceView:(UIView *)referenceView;

/**
 Returns keyboard visibility. Initially set to NO, so could result in false negative if the observer was initialized during keyboard visibility.
 
 @return returns keyboard visibility
 */
@property (nonatomic, readonly, getter = isKeyboardVisible) BOOL keyboardVisible;

/**
 Returns keyboard state prior to the last completed keyboard show/hide. Initially set to CGRectZero.
 
 @return returns keyboard state prior to the last completed keyboard show/hide
 */
@property (nonatomic, readonly) CGRect previousKeyboardBounds;

/**
 Returns keyboard state after the last completed keyboard show/hide. Initially set to CGRectZero.
 
 @return returns keyboard state after the last completed keyboard show/hide
 */
@property (nonatomic, readonly) CGRect currentKeyboardBounds;

/**
 Returns an UIView object used as a reference view during initialization
 
 @return returns the reference view object
 */
@property (nonatomic, readonly, weak) UIView *referenceView;

@property (nonatomic, weak) id<KBKeyboardObserverDelegate> delegate;

/**
 Disables KBKeyboardObserver instance. Called automatically by -[KBKeyboardObserver dealloc]
 */
- (void)unregister;

@end

@interface UIViewController (KBKeyboardObserver)

/**
 Creates a new KBKeyboardObserver object for given delegate. The view that the UIViewController receiver manages, will be used as the reference view. Result should be retained by the caller.
 
 @param delegate a KBKeyboardObserver delegate object
 
 @return returns a new KBKeyboardObserver object for the UIViewController receiver
 */
- (KBKeyboardObserver *)registerForKeyboardNotifications:(id<KBKeyboardObserverDelegate>)delegate;

@end
