//
//  ViewController.m
//  JYReactivePlayground
//
//  Created by JinYong on 15-1-9.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import "JYDummySignInService.h"
#import <ReactiveCocoa.h>
@interface ViewController ()

@property (nonatomic, weak) IBOutlet UITextField *usernameTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *signInFailureText;
@property (nonatomic, strong) JYDummySignInService *signInService;
- (IBAction)actionLogin:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.signInService = [JYDummySignInService new];
    self.signInFailureText.hidden = YES;
//    [self.usernameTextField.rac_textSignal subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
//    
//    [[self.usernameTextField.rac_textSignal filter:^BOOL(NSString *text) {
//        return text.length > 3;
//    }] subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
//    
//    [[[self.usernameTextField.rac_textSignal map:^id(NSString *text) {
//        return @(text.length);
//    }] filter:^BOOL(NSNumber *length) {
//        return [length integerValue] > 3;
//    }] subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];

    RACSignal *validUsernameSignal = [self.usernameTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidUserName:text]);
    }];
    
    RACSignal *validPasswordSignal = [self.passwordTextField.rac_textSignal map:^id(NSString *text) {
        return @([self isValidPassword:text]);
    }];
    
//    [[validUsernameSignal map:^id(NSNumber *usernameValid) {
//        return [usernameValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
//    }] subscribeNext:^(UIColor *color) {
//        self.usernameTextField.backgroundColor = color;
//    }];
    
    RAC(self.usernameTextField,backgroundColor) = [validUsernameSignal map:^id(NSNumber *usernameValid) {
        return [usernameValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    RAC(self.passwordTextField,backgroundColor) = [validPasswordSignal map:^id(NSNumber *passwordValid) {
        return [passwordValid boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
    
    RACSignal *signUpActiveSignal = [RACSignal combineLatest:@[validUsernameSignal,validPasswordSignal] reduce:^id(NSNumber *usernameValid,NSNumber *passwordValid){
        return @([usernameValid boolValue] && [passwordValid boolValue]);
    }];
    
    [signUpActiveSignal subscribeNext:^(NSNumber *signupActive) {
        self.signInButton.enabled = [signupActive boolValue];
    }];
    
//    [[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        NSLog(@"Button clicked");
//    }];
    
//    [[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] map:^id(id value) {
//        return [self signInButton];
//    }] subscribeNext:^(id x) {
//        NSLog(@"Sign in result : %@",x);
//    }];
    
    [[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] flattenMap:^RACStream *(id value) {
        return [self signInSignal];
    }] subscribeNext:^(NSNumber *signedIn) {
        NSLog(@"Sign in result:%@",signedIn);
        BOOL success = [signedIn boolValue];
        self.signInFailureText.hidden = success;
        if (success) {
            [self performSegueWithIdentifier:@"loginsuccess" sender:self];
        }
    }];
    
//    [[[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext:^(id x) {
//        self.signInButton.enabled = NO;
//        self.signInFailureText.hidden = YES;
//    }] flattenMap:^RACStream *(id value) {
//        return [self signInSignal];
//    }] subscribeNext:^(NSNumber *signedIn) {
//        self.signInButton.enabled = YES;
//        BOOL success = [signedIn boolValue];
//        if (success) {
//            [self performSegueWithIdentifier:@"loginsuccess" sender:self];
//        }
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RACSignal *)signInSignal{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.signInService signInWithUsername:self.usernameTextField.text password:self.passwordTextField.text complete:^(BOOL success) {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }];
        return nil;
    }];
}

- (BOOL)isValidUserName:(NSString *)name {
  if (name != nil && name.length >= 3) {
    return YES;
  }
  return NO;
}

- (BOOL)isValidPassword:(NSString *)password {
  if (password != nil && password.length >= 6) {
    return YES;
  }
  return NO;
}

- (IBAction)actionLogin:(id)sender {
  [self performSegueWithIdentifier:@"loginsuccess" sender:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
