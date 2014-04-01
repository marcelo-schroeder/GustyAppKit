//
//  IAUIAbstractAppearanceTheme.h
//  Gusty
//
//  Created by Marcelo Schroeder on 29/06/12.
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

#import "IAUIAppearanceTheme.h"

@class IAUINavigationItemTitleView;
@class IAUIColorScheme;

@interface IAUIAbstractAppearanceTheme : NSObject <IAUIAppearanceTheme>

-(void)m_setOrientationDependentBackgroundImagesForViewController:(UIViewController*)a_viewController;
-(IAUINavigationItemTitleView*)m_navigationItemTitleViewForViewController:(UIViewController*)a_viewController barMetrics:(UIBarMetrics)a_barMetrics;
-(UINavigationItem*)m_titleViewNavigationItemForViewViewController:(UIViewController*)a_viewController;
- (void)m_setCustomDisclosureIndicatorForCell:(UITableViewCell *)a_cell
                          tableViewController:(UITableViewController *)a_tableViewController;
-(IAUIColorScheme*)m_colorScheme;
-(UIColor*)m_colorWithIndex:(NSUInteger)a_colorIndex;

+ (UIColor *)m_splitViewControllerDividerColour;

@end