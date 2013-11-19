KBKeyboardObserver
==================

KBKeyboardObserver is a convenient keyboard notifications observer.

Feel free to give suggestions!

## Installation

To install KBKeyboardObserver either:

* use [http://cocoapods.org/](http://cocoapods.org/)
* or copy __KBKeyboardObserver/KBKeyboardObserver.h__ and __KBKeyboardObserver/KBKeyboardObserver.m__ in your project.

## Usage

Create a new KBKeyboardObserver object by alloc/init and set delegate:
``` objc
self.observer = [[KBKeyboardObserver alloc] initWithReferenceView:self.view];
self.observer.delegate = self;
```
or use convenient UIViewController method instead:
``` objc
self.observer = [self registerForKeyboardNotifications:self];
```

Implement delegate methods to observe keyboard behaviour (willShow, didShow, willHide and didHide):
``` objc
- (void)keyboardObserver:(KBKeyboardObserver *)keyboardObserver observedKeyboardWillHideToRect:(CGRect)keyboardRect duration:(NSTimeInterval)duration;
- (void)keyboardObserver:(KBKeyboardObserver *)keyboardObserver observedKeyboardDidHideToRect:(CGRect)keyboardRect;
- (void)keyboardObserver:(KBKeyboardObserver *)keyboardObserver observedKeyboardWillShowToRect:(CGRect)keyboardRect duration:(NSTimeInterval)duration;
- (void)keyboardObserver:(KBKeyboardObserver *)keyboardObserver observedKeyboardDidShowToRect:(CGRect)keyboardRect;
```

## Examples

__KBKeyboardObserver__ directory contains example project.

#### Content indents

KBKeyboardObserver helps to set contentIndents of UIScrollView.

``` objc
#import "KBKeyboardObserver.h"

@interface ExampleViewController : UIViewController <KBKeyboardObserverDelegate>

@property (nonatomic, strong) UITextView *exampleView;
@property (nonatomic, strong) KBKeyboardObserver *keyboardObserver;

@end

@implementation ExampleViewController

- (UITextView *)exampleView
{
    if (!_exampleView) {
        _exampleView = [[UITextView alloc] init];
    }
    return _exampleView;
}

- (void)loadView
{
    self.view = self.exampleView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	  // 1 - create new observer and retain it
    self.keyboardObserver = [self registerForKeyboardNotifications:self];
}

#pragma mark - KBKeyboardObserverDelegate

- (void)keyboardObserver:(KBKeyboardObserver *)keyboardObserver observedKeyboardWillShowToRect:(CGRect)keyboardRect duration:(NSTimeInterval)duration
{
    // 2 - set content insets animation prior to the keyboard display
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, keyboardRect.size.height, 0);
    [UIView animateWithDuration:duration
                     animations:^{
                        self.exampleView.contentInset = edgeInsets;
                        self.exampleView.scrollIndicatorInsets = edgeInsets;
                     }];
}

- (void)keyboardObserver:(KBKeyboardObserver *)keyboardObserver observedKeyboardWillHideToRect:(CGRect)keyboardRect duration:(NSTimeInterval)duration
{
    // 3 - set content insets animation after the keyboard dismissal
    [UIView animateWithDuration:duration
                     animations:^{
                        self.exampleView.contentInset = UIEdgeInsetsZero;
                        self.exampleView.scrollIndicatorInsets = UIEdgeInsetsZero;
                     }];
}

@end
```

#### Layout element

KBKeyboardObserver helps to layout children of UIView.

``` objc
#import "KBKeyboardObserver.h"

@interface ExampleViewController : UIViewController <KBKeyboardObserverDelegate>

@property (nonatomic, strong) UIView *redView;
@property (nonatomic, strong) KBKeyboardObserver *keyboardObserver;

@end

@implementation ExampleViewController 

- (UIView *)redView
{
    if (!_redView) {
        _redView = [[UIView alloc] init];
        _redView.backgroundColor = [UIColor redColor];
    }
    return _redView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.redView];
    self.redView.frame = CGRectMake(0, self.view.bounds.size.height - 100, 100, 100);
	
    self.keyboardObserver = [self registerForKeyboardNotifications:self];
}

#pragma mark - KBKeyboardObserverDelegate

- (void)keyboardObserver:(KBKeyboardObserver *)keyboardObserver observedKeyboardWillShowToRect:(CGRect)keyboardRect duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration
                     animations:^{
                         CGRect redViewFrame = self.redView.frame;
                         redViewFrame.origin.y = keyboardRect.origin.y - redViewFrame.size.height;
                         self.redView.frame = redViewFrame;
                     }];
}

- (void)keyboardObserver:(KBKeyboardObserver *)keyboardObserver observedKeyboardWillHideToRect:(CGRect)keyboardRect duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration
                     animations:^{
                         CGRect redViewFrame = self.redView.frame;
                         redViewFrame.origin.y = keyboardRect.origin.y - redViewFrame.size.height;
                         self.redView.frame = redViewFrame;
                     }];
}

```
