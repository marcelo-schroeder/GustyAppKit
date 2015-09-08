<img src="http://marcelo-schroeder.github.io/GustyAppKit-logo.png" alt="GustyAppKit logo" width="300" height="auto">

A Cocoa Touch framework to help you develop high quality iOS apps faster. GustyAppKit requires iOS 8 or greater.

GustyAppKit has a dependency on the foundation provided by [GustyKit](https://github.com/marcelo-schroeder/GustyKit). If you need foundation functionality that is safe to use by app extensions, then use GustyKit. GustyAppKit provides extra functionality on top of GustyKit that only apps can use (e.g. access to UIApplication).

This framework has been used in a few projects for my clients.

The latest API documentation can be found [here](http://cocoadocs.org/docsets/GustyAppKit).

Additional documentation and sample code are coming soon.

## Features ##

GustyAppKit is broad in terms of the features it offers, but it is also flexible. You can benefit just from the features you are interest in without being distracted by the others you don't want to use.

### Core Data ###

GustyAppKit makes it easy to implement the UI on top of Core Data persistence with the following main features:

* CRUD support
  * Configurable via plist (no code required, but it is supported)
  * Automatic binding between view and model
  * Forms
      * Various editor types and controls supported such as:
          * Text fields
          * Long text fields
          * Numeric fields
          * Switches
          * Segmented controls
          * Pickers
          * Date pickers
          * Single selection lists
          * Multiple selection lists
          * Custom editors
      * Sub-forms
      * Help support
  * Lists
    * Edit mode support
    * Detail view linking to forms
* Look up tables with version control and conversion
* Core Data utilities

### HUD (Heads-Up Display) ###

Finally a modern HUD implementation for iOS!

Features:

* Modern UIKit API's used such as view controller containment and auto layout
* Multiple styles including blur and vibrancy
* Visual indicators:
  * Indeterminate progress
  * Determinate progress
  * Success
  * Error
  * Custom view
* Modality:
  * Modal
  * Non-modal
* User interaction:
  * Chrome tap
  * Overlay tap
* Layout:
  * Compressed
  * Expanded
  * Padding
  * Inter-item spacing
* Dynamic layout changes:
  * Non-animated
  * Animated
* Font:
  * Test style customisation
  * Font customisation
* Colour scheme customisation
* Content subview order customisation
* Completion blocks for presentation and dismissal
* Motion (honours reduce motion setting)
* And support for:
  * Appearance API
  * Both Objective-C and Swift
  * Dynamic font type
  * Device rotation

### Miscellaneous ###

* Asynchronous operations with UI support such as progress indicators
* Internal web browser
* Appearance theme support
* Help system
* About screen
* Lazy data loading for table views (also known as infinite scrolling)
* Foundation utility classes
* UI utility classes
* Smart grid collection views
* HTML parsing and manipulation utility classes

## How to install GustyAppKit ##

GustyAppKit can be installed via Cocoapods.

## How to use GustyAppKit ##

Refer to the DemoApp workspace for the demo app exploring GustyAppKit's features. Only HUD functionality is currently explored by the demo app. More to come soon...

The easiest way to just try the demo app is by running the following from the command line (Cocapods must be installed):

```
pod try GustyAppKit
```

## Latest API Documentation ##

http://cocoadocs.org/docsets/GustyAppKit
