//
//  UIBarButtonItem+IFACategory.h
//  Gusty
//
//  Created by Marcelo Schroeder on 28/01/13.
//  Copyright (c) 2013 InfoAccent Pty Limited. All rights reserved.
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

@interface UIBarButtonItem (IFACategory)

@property (nonatomic, strong, readonly) UIButton *ifa_button;

-(id)initWithImageName:(NSString*)a_imageName target:(id)a_target action:(SEL)a_action;

- (id)initWithImageName:(NSString *)a_imageName
                 target:(id)a_target
                 action:(SEL)a_action
           appearanceId:(NSString *)a_appearanceId
         viewController:(UIViewController *)a_viewController;

@end
