//
// Created by Marcelo Schroeder on 23/12/2013.
// Copyright (c) 2013 InfoAccent Pty Limited. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "IAPhoneServiceManager.h"
#import "NSNumberFormatter+IACategory.h"


@implementation IAPhoneServiceManager {

}

#pragma mark - Private

- (NSURL *)ifa_buildTelURL:(NSString *)a_phoneNumber {
    NSString *l_urlString = [@"tel:" stringByAppendingString:[a_phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSURL *l_url = [NSURL URLWithString:l_urlString];
    return l_url;
}

- (BOOL)ifa_isPhoneServiceAvailable {
    NSURL *l_dummyTelURL = [self ifa_buildTelURL:@"12345678"];
    UIApplication *l_sharedApplication = [UIApplication sharedApplication];
    return [l_sharedApplication canOpenURL:l_dummyTelURL];
}

#pragma mark - Public

- (void)dialPhoneNumber:(NSString *)a_phoneNumber {
    if ([self ifa_isPhoneServiceAvailable]) {
        NSURL *l_url = [self ifa_buildTelURL:a_phoneNumber];
        UIApplication *l_sharedApplication = [UIApplication sharedApplication];
        [l_sharedApplication openURL:l_url];
    } else {
        NSString *l_alertMessage = nil;
        NSString *l_alertTitle = @"";
        NSString *l_formattedPhoneNumber = [NSNumberFormatter IFA_stringFromAustralianPhoneNumberString:a_phoneNumber];
        l_alertMessage = [NSString stringWithFormat:@"Please call %@ using a phone", l_formattedPhoneNumber];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:l_alertTitle message:l_alertMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

+ (IAPhoneServiceManager *)sharedInstance {
    static dispatch_once_t c_dispatchOncePredicate;
    static IAPhoneServiceManager *c_instance;
    void (^instanceBlock)(void) = ^(void) {
        c_instance = [self new];
    };
    dispatch_once(&c_dispatchOncePredicate, instanceBlock);
    return c_instance;
}

@end