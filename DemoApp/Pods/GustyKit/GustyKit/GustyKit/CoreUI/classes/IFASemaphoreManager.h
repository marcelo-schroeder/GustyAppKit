//
// Created by Marcelo Schroeder on 30/01/2014.
// Copyright (c) 2014 InfoAccent Pty Limited. All rights reserved.
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

#import <Foundation/Foundation.h>

@interface IFASemaphoreManager : NSObject

- (BOOL)waitForSemaphore:(dispatch_semaphore_t)a_semaphore
shouldShowModalProgressIndicator:(BOOL)a_shouldShowModalProgressIndicator
        progressIndicatorMessage:(NSString *)a_progressIndicatorMessage
            semaphoreNoWaitBlock:(void (^)())a_semaphoreNoWaitBlock
          semaphoreWaitOverBlock:(void (^)())a_semaphoreWaitOverBlock
           userCancellationBlock:(void (^)())a_userCancellationBlock;
@end