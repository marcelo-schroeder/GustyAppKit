//
//  IAUIDynamicPagingContainerViewControllerDataSource.h
//  Gusty
//
//  Created by Marcelo Schroeder on 12/11/11.
//  Copyright (c) 2011 InfoAccent Pty Limited. All rights reserved.
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

#import "IAConstants.h"

@protocol IAUIDynamicPagingContainerViewControllerDataSource <NSObject>

/*
 This method is called so the container view controller can obtain the title for each page.
 The method is called once for each page represented in the IAUIScrollPage enum, with the exception of IA_UISCROLL_PAGE_LEFT_FAR and IA_UISCROLL_PAGE_RIGHT_FAR.
 Those pages never fully appear so their titles do not appear either.
 */
-(NSString*)m_titleForPage:(IAUIScrollPage)a_page;

/* 
 This method is called so the container view controller can obtain an instance of a child view controller for each page.
 The method is called once for each page represented in the IAUIScrollPage enum.
 The child view controller for the centre page (i.e. IA_UISCROLL_PAGE_CENTRE) is always obtained first. That way the child view controller for the other pages can have their model
    data generated relative to the centre page's child view controller.
 To indicate the left or right boundaries just return a nil value;
 */
-(UITableViewController*)m_childViewControlerForPage:(IAUIScrollPage)a_page;

@end