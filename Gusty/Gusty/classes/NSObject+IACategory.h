//
//  NSObject+IACategory.h
//  Gusty
//
//  Created by Marcelo Schroeder on 28/02/12.
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

@interface NSObject (IACategory)

- (id)propertyValueForIndexPath:(NSIndexPath*)anIndexPath inForm:(NSString*)aFormName createMode:(BOOL)aCreateMode;
- (NSString*)propertyNameForIndexPath:(NSIndexPath*)anIndexPath inForm:(NSString*)aFormName createMode:(BOOL)aCreateMode;
- (NSString*)propertyStringValueForName:(NSString*)a_propertyName calendar:(NSCalendar*)a_calendar value:(id)a_value;
- (NSString*)propertyStringValueForName:(NSString*)a_propertyName calendar:(NSCalendar*)a_calendar;
- (NSString*)propertyStringValueForIndexPath:(NSIndexPath*)anIndexPath inForm:(NSString*)aFormName createMode:(BOOL)aCreateMode calendar:(NSCalendar*)a_calendar;
- (NSString*)displayValue;
- (NSString*)longDisplayValue;
- (NSString*)entityLabel;
- (void) setValue:(id)aValue forProperty:(NSString *)aKey;
- (NSString*)entityName;
- (NSPropertyDescription*)descriptionForProperty:(NSString*)aPropertyName;
- (NSString*)labelForProperty:(NSString*)aPropertyName;
- (NSUInteger)fractionDigitsForProperty:(NSString*)aPropertyName;
- (NSNumberFormatter*)numberFormatterForProperty:(NSString*)aPropertyName;
- (NSNumber*)minimumValueForProperty:(NSString*)a_propertyName;
- (NSNumber*)maximumValueForProperty:(NSString*)a_propertyName;

+ (NSString*)entityName;
+ (NSString*)displayValueForNil;

@end