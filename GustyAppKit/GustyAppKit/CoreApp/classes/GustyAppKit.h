//
//  GustyAppKit.h
//  GustyAppKit
//
//  Created by Marcelo Schroeder on 30/07/10.
//  Copyright 2010 InfoAccent Pty Limited. All rights reserved.
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

//wip: manage framework versioning
//wip: am I going to need to my own umbrella headers since Cocoapods is generating one automatically??
//wip: document framework support and restrictions on GitHub
//wip: document how to use it as framework in app extensions
//wip: need to release the world when the framework work is finished

// CoreApp
#import "GustyAppKitCoreApp.h"

// FlurrySupport
#ifdef IFA_AVAILABLE_FlurrySupport
#import "GustyAppKitFlurrySupport.h"
#endif

// GoogleMobileAdsSupport
#ifdef IFA_AVAILABLE_GoogleMobileAdsSupport
#import "GustyAppKitGoogleMobileAdsSupport.h"
#endif

// Help
#ifdef IFA_AVAILABLE_Help
#import "GustyAppKitHelp.h"
#endif

// Html
#ifdef IFA_AVAILABLE_Html
#import "GustyAppKitHtml.h"
#endif