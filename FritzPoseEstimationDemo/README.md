# Pose Estimation

[![Twitter](https://img.shields.io/badge/twitter-@fritzlabs-blue.svg?style=flat)](http://twitter.com/fritzlabs)

In this app, we use the Pose Estimation API by Fritz in order to identify and track the movement of different human poses.

For the full tutorial, visit [our post on Heartbeat](https://heartbeat.fritz.ai/pose-estimation-on-ios-with-fritz-60c8e5f7d195)

<img src="images/pose_estimation_ios.jpg" width="250" />

## Requirements

- Xcode 10.2 or later.
- Xcode project targeting iOS 10 or above. You will only be able to use features in iOS 11+, but you still can include Fritz in apps that target iOS 10+ and selectively enable for users on 11+.
- Swift projects must use Swift 4.1 or later.
- CocoaPods 1.4.0 or later.

## Getting Started

**Step 1: Clone / Fork the fritz-ios-tutorials repository and open FritzPoseEstimationDemo**

```
git clone https://github.com/fritzlabs/fritz-ios-tutorials.git
```

**Step 2: Create a Fritz Account**

In order to use Fritz, please [register for a free account](https://app.fritz.ai/register) and [follow the directions](https://docs.fritz.ai/quickstart.html#ios) for setting up a new app.

**Step 3: Setup the project via Cocoapods**

Install dependencies via Cocoapods by running `pod install` from `fritz-ios-tutorials/FritzPoseEstimationDemo`

```
cd fritz-ios-tutorials/FritzPoseEstimationDemo
pod install
```

- Note you may need to run `pod update` if you already have Fritz installed locally.

**Step 4: Open up a new XCode project**

XCode > Open > FritzPoseEstimationDemo.xcworkspace

**Step 5: Run the app**

Attach a device or use an emulator to run the app. If you get the error "Please download the Fritz-Info.plist", you'll need to register the app with Fritz (See Step 2).

## For questions on how to use the demos, contact us:

- [Slack](https://heartbeat-by-fritz.slack.com/join/shared_invite/enQtMzY5OTM1MzgyODIzLTZhNTFjYmRiODU0NjZjNjJlOGRjYzI2OTIwY2M4YTBiNjM1ODU1ZmU3Y2Q2MmMzMmI2ZTIzZjQ1ZWI3NzBkZGU)
- [Help Center](https://docs.fritz.ai/help-center/index.html)

## Setup a Fritz account

[iOS SDK instructions](https://docs.fritz.ai/quickstart.html#ios)

## Documentation

[Fritz Docs Home](https://docs.fritz.ai/)

[iOS SDK Reference Docs](https://docs.fritz.ai/iOS/latest/index.html)
