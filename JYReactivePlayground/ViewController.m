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
- (IBAction)actionLogin:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    [[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"Button clicked");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)isValidUserName:(NSString *)name
{
    if (name != nil && name.length >= 3) {
        return YES;
    }
    return NO;
}

- (BOOL)isValidPassword:(NSString *)password
{
    if (password != nil && password.length >= 6) {
        return YES;
    }
    return NO;
}

- (IBAction)actionLogin:(id)sender
{
    [self performSegueWithIdentifier:@"loginsuccess" sender:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
