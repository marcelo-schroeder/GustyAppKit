//
//  IFAFormTextFieldTableViewCell.h
//  GustyKit
//
//  Created by Marcelo Schroeder on 18/05/12.
//  Copyright (c) 2012 InfoAccent Pty Limited. All rights reserved.
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

#import "IFAFormTableViewCell.h"

@interface IFAFormTextFieldTableViewCell : IFAFormTableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *textField;

-(void)reloadData;
-(BOOL)valueChanged;
-(id)parsedValue;

/**
* Add layout constraints related to textField.
* This method can be overridden to provide different constraints.
*/
- (void)addTextFieldLayoutConstraints;
@end
