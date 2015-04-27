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

#import "GustyAppKitCoreApp.h"


@implementation IFAPhoneServiceManager {

}

#pragma mark - Private

- (NSURL *)IFA_buildTelURL:(NSString *)a_phoneNumber {
    NSString *l_urlString = [@"tel:" stringByAppendingString:[a_phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""]];
    NSURL *l_url = [NSURL URLWithString:l_urlString];
    return l_url;
}

#pragma mark - Public

#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCUnusedMethodInspection"
- (void)dialPhoneNumber:(NSString *)a_phoneNumber {
    NSURL *url = [self IFA_buildTelURL:a_phoneNumber];
    void (^completionHandler)(BOOL) = ^(BOOL success) {
        if (!success) {
            NSString *l_alertMessage = nil;
            NSString *l_alertTitle = @"";
            NSString *l_formattedPhoneNumber = [NSNumberFormatter ifa_stringFromAustralianPhoneNumberString:a_phoneNumber];
            l_alertMessage = [NSString stringWithFormat:NSLocalizedStringFromTable(@"Please call %@ using a phone", @"GustyKitLocalizable", @"Please call <PHONE_NUMBER> using a phone"), l_formattedPhoneNumber];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:l_alertTitle message:l_alertMessage delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @"GustyKitLocalizable", nil) otherButtonTitles:nil, nil];
            [alert show];
        }
    };
    [IFAUIUtils          openUrl:url
withAlertPresenterViewController:nil
               completionHandler:completionHandler];
}
#pragma clang diagnostic pop

+ (IFAPhoneServiceManager *)sharedInstance {
    static dispatch_once_t c_dispatchOncePredicate;
    static IFAPhoneServiceManager *c_instance;
    void (^instanceBlock)(void) = ^(void) {
        c_instance = [self new];
    };
    dispatch_once(&c_dispatchOncePredicate, instanceBlock);
    return c_instance;
}

@end