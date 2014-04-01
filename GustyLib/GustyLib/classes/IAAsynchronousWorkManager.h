//
//  IAAsynchronousWorkManager.h
//  Gusty
//
//  Created by Marcelo Schroeder on 19/04/11.
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

@interface IAAsynchronousWorkManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext *p_managedObjectContext;

@property (readonly) BOOL p_areAllBlocksCancelled;

+ (IAAsynchronousWorkManager*)instance;

-(void)m_showNonModalProgressIndicatorInView:(UIView*)a_view;
-(void)m_showNonModalProgressIndicator;
-(void)m_hideNonModalProgressIndicatorWithAnimation:(BOOL)a_animate;

/* the methods below are based on NSOperation */

-(void)m_dispatchOperation:(NSOperation*)a_operation;
-(void)m_dispatchOperation:(NSOperation*)a_operation callbackObject:(id)a_callbackObject callbackSelector:(SEL)a_callbackSelector;
-(void)m_dispatchOperation:(NSOperation*)a_operation showProgressIndicator:(BOOL)a_showProgressIndicator callbackObject:(id)a_callbackObject callbackSelector:(SEL)a_callbackSelector;
-(void)m_cancelAllOperations;

/* the methods below are based on GCD serial dispatch queues */

-(void)m_dispatchSerialBlock:(dispatch_block_t)a_block;
-(void)m_dispatchSerialBlock:(dispatch_block_t)a_block cancelPreviousBlocks:(BOOL)a_cancelPreviousBlocks;
-(void)m_dispatchSerialBlock:(dispatch_block_t)a_block showProgressIndicator:(BOOL)a_showProgressIndicator;
-(void)m_dispatchSerialBlock:(dispatch_block_t)a_block showProgressIndicator:(BOOL)a_showProgressIndicator cancelPreviousBlocks:(BOOL)a_cancelPreviousBlocks;
-(void)m_dispatchSerialBlock:(dispatch_block_t)a_block progressIndicatorContainerView:(UIView*)a_progressIndicatorContainerView cancelPreviousBlocks:(BOOL)a_cancelPreviousBlocks;
-(void)m_dispatchSerialBlock:(dispatch_block_t)a_block progressIndicatorContainerView:(UIView*)a_progressIndicatorContainerView cancelPreviousBlocks:(BOOL)a_cancelPreviousBlocks usePrivateManagedObjectContext:(BOOL)a_usePrivateManagedObjectContext;
-(void)m_dispatchSerialBlock:(dispatch_block_t)a_block usePrivateManagedObjectContext:(BOOL)a_usePrivateManagedObjectContext;
-(void)m_cancelAllSerialBlocks;

/* the methods below are based on GCD global concurrent dispatch queues */

-(void)m_dispatchConcurrentBackgroundBlock:(dispatch_block_t)a_block;

@end