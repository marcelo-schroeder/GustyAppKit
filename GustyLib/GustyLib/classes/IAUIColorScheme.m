//
//  IAUIColorScheme.m
//  Gusty
//
//  Created by Marcelo Schroeder on 13/11/12.
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

#import "IAUIColorScheme.h"

@interface IAUIColorScheme ()

@property (nonatomic, strong) NSArray *p_colors;

@end

@implementation IAUIColorScheme{
    
}

#pragma mark - Overrides

-(BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[self class]]) {
        IAUIColorScheme *l_theOtherColorScheme = (IAUIColorScheme*)object;
        return [self.p_colors isEqual:l_theOtherColorScheme.p_colors];
    }else{
        return [super isEqual:object];
    }
}

#pragma mark - Public

- (id)initWithColors:(NSArray*)a_colors{
    self = [super init];
    if (self) {
        self.p_colors = a_colors;
    }
    return self;
}

-(UIColor*)m_colorAtIndex:(NSUInteger)a_index{
    return [self.p_colors objectAtIndex:a_index];
}

@end