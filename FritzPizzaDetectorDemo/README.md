# Pizza Detector Demo with Image Labeling

[![Twitter](https://img.shields.io/badge/twitter-@fritzlabs-blue.svg?style=flat)](http://twitter.com/fritzlabs)

In this app, we use the Image Labeling API by Fritz in order to build a pizza identifier similar to Domino's Points for Pies feature.

For the full tutorial, visit [our post on Heartbeat](https://heartbeat.fritz.ai/recreate-dominos-points-for-pies-app-on-ios-with-fritz-image-labeling-2ed23398e1c2)

![](images/pizza.gif)

There are 2 projects to help you get started:

- Starter app - The bare bones app you should use to get started with the tutorial.
- Final app - The finished app displaying an animation when a pizza is detected.

Choose an app and run it in Xcode.

## Requirements

- Xcode 10.2 or later.
- Xcode project targeting iOS 10 or above. You will only be able to use features in iOS 11+, but you still can include Fritz in apps that target iOS 10+ and selectively enable for users on 11+.
- Swift projects must use Swift 4.1 or later.
- CocoaPods 1.4.0 or later.

## Getting Started

**Step 1: Clone / Fork the fritz-ios-tutorials repository and open FritzPizzaDetectorDemo (Starter or Final folder)**

```
git clone https://github.com/fritzlabs/fritz-ios-tutorials.git
```

**Step 2: Create a Fritz Account**

In order to use Fritz, please [register for a free account](https://app.fritz.ai/register) and [follow the directions](https://docs.fritz.ai/develop/get-started-sdk.html) for setting up a new app.

**Step 3: Setup the project via Cocoapods**

Install dependencies via Cocoapods by running `pod install` from `fritz-ios-tutorials/FritzPizzaDetectorDemo/Starter`

```
cd fritz-ios-tutorials/FritzPizzaDetectorDemo/Starter
pod install
```

- Note you may need to run `pod update` if you already have Fritz installed locally.

**Step 4: Open up a new XCode project**

XCode > Open > FritzPizzaDetectorDemo.xcworkspace

**Step 5: Run the app**

Attach a device or use an emulator to run the app. If you get the error "Please download the Fritz-Info.plist", you'll need to register the app with Fritz (See Step 2).

## For questions on how to use the demos, contact us:

- [Slack](https://heartbeat-by-fritz.slack.com/join/shared_invite/enQtMzY5OTM1MzgyODIzLTZhNTFjYmRiODU0NjZjNjJlOGRjYzI2OTIwY2M4YTBiNjM1ODU1ZmU3Y2Q2MmMzMmI2ZTIzZjQ1ZWI3NzBkZGU)
- [Help Center](https://docs.fritz.ai/help-center/index.html)

## Setup a Fritz account

[iOS SDK instructions](https://docs.fritz.ai/develop/get-started-sdk.html)

## Documentation

[Fritz Docs Home](https://docs.fritz.ai/)

[iOS SDK Reference Docs](https://docs.fritz.ai/iOS/latest/index.html)
