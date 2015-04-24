//
//  IFAApplicationDelegate.h
//  Gusty
//
//  Created by Marcelo Schroeder on 30/08/11.
//  Copyright 2011 InfoAccent Pty Limited. All rights reserved.
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

@protocol IFAAppearanceTheme;
@class IFAColorScheme;

//wip: add documentation
@interface IFAApplicationDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic) BOOL skipWindowSetup;
@property (nonatomic) BOOL skipWindowRootViewControllerSetup;

@end
