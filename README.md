![Vizury Logo](https://github.com/vizury/vizury-ios-sdk/blob/master/resources/VizuryLogo.png)
## Summary
 This is iOS SDK integration guide. The SDK supports iOS7 and above.

## Components

  * [Example app](#example-app)
  * [Basic Integration](#basic-integration)
	* [Getting the SDK](#sdk-get)
	* [Add the SDK to project](#sdk-add)
	* [Vizury SDK Initialization](#sdk-init)
	* [Event Logging](#event-logging)
  * [Push Notifications](#push-notifications)
	* [Configuring Apple Developer Settings](#config-apple-dev)
	* [Configuring project for FCM](#config-fcm)
		* [Set up CocoaPods dependencies](#setup-pods)
		* [Enabling FCM](#enable-fcm)
	* [Configuring Application](#config-app) 
	* [DeepLinks](#deeplinks)
	* [iOS 10 Rich Notifications](#ios10-rich)
		* [Create Notification Service Extension](#create-noti-service)
		* [Adding Vizury to Notification Service Extension](#add-viz-noti)
 
## <a id="example-app"></a>Example app

Examples on how the Vizury iOS SDK can be integrated.

`sampleApp/HelloVizury` is a sample app having a basic integration with vizury SDK.


## <a id="basic-integration"></a>Basic Integration

### <a id="sdk-get"></a>Getting the SDK
Download the latest Vizury iOS SDK [`VizuryEventLogger`][VizuryEventLogger_ios]. The framework file is available with `bitcode enabled` and `bitcode disabled`. Extract the required archive into a directory of your choice. The extracted file is `VizuryEventLogger.framework`

### <a id="sdk-add"></a>Add the SDK to project
Go to the Build phases -> Link Binary with Libraries. Click on the `+` icon

![addSDK-1](https://github.com/vizury/vizury-ios-sdk/blob/master/resources/addSDK-1.png)


Add `Foundation.framework` , then click on `Add Other` and add the extracted `VizuryEventLogger.framework` file

![addSDK-2](https://github.com/vizury/vizury-ios-sdk/blob/master/resources/addSDK-2.png)


### <a id="sdk-init"></a>Vizury SDK Initialization

#### Objective-C
---- 
  Import the VizuryEventLogger
 
 ```objc
 #import <VizuryEventLogger/VizuryEventLogger.h>
 ```
 
 Add the following in `didFinishLaunchingWithOptions` method of AppDelegate to initialize the SDK
 
```objc
  [VizuryEventLogger initializeEventLoggerInApplication:(UIApplication*)application
                            WithPackageId:(NSString *)packageId
                            ServerURL:(NSString *)serverURL
                            WithCachingEnabled:(BOOL) caching
                            AndWithFCMEnabled:(BOOL) isFCMEnabled];
```

#### Swift
----
 In yout bridging header file add
 
 ```objc
 #import <VizuryEventLogger/VizuryEventLogger.h>
 ```
 
 Update your AppDelegate 
 
 ```swift
 class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate
 ```
 
 Add the following in `didFinishLaunchingWithOptions` method of AppDelegate to initialize the SDK
 
```objc
VizuryEventLogger.initializeEventLogger(in: application,
			withPackageId: packageId, 
			serverURL: serverUrl,
			withCachingEnabled: caching, 
			AndWithFCMEnabled: isFCMEnabled)
```

```
Where 
  packageId     : packageId obtained from vizury
  serverURL     : serverURL obtained from vizury
  caching       : pass true if your app supports offline usage and you want to send user behaviour data 
                  to vizury while he was offline. Pass false otherwise
  isFCMEnabled  : true/false depending on if you want to use vizury for push
``` 
 
### <a id="event-logging"></a>Event Logging

When a user browse through the app, various activities happen e.g. visiting a product, adding the product to cart, making purchase, etc. These are called events. Corresponding to each event, app needs to pass certain variables to the SDK which the SDK will automatically pass to Vizury servers.


#### Objective-C
----
Create an attributeDictionary with the attributes associated with the event and call `[VizuryEventLogger logEvent]` with event name and the attributeDictionary.

```objc
	#import <VizuryEventLogger/VizuryEventLogger.h>

	NSDictionary *attributeDictionary  =   [[NSDictionary alloc] initWithObjectsAndKeys:
                                            @"AKSJDASNBD",@"productid",
                                            @"789", @"productPrice",
                                            @"Shirt",@"category",
                                            nil];

    [VizuryEventLogger logEvent:@"productPage" WithAttributes:attributeDictionary];
```

#### Swift
----
Create an attributeDictionary with the attributes associated with the event and call `VizuryEventLogger.logEvent with event name and the attributeDictionary.

```swift
        let attributeDictionary = [ "productId":"AKSJDASNBD",
                                        "price" : "999",
                                        "category" : "shirt"]
        VizuryEventLogger.logEvent("productPage", withAttributes: attributeDictionary)
```	

## <a id="push-notifications"></a>Push Notifications

For sending push notifications we are using GCM-APNS interface. For this you need to configure the App for push notifications in [Apple Developer Member Center][apple-dev-member-center] and get a configuration file from google.

### <a id="config-apple-dev"></a>Configuring Apple Developer Settings

To enable sending Push Notifications through APNs, you need

a) Create the authentication key.

b) Create an App ID

c) Provisioning profile for that App ID.


You can create them in the [Apple Developer Member Center][apple-dev-member-center] by following [these steps][provisioning-profiles]


### <a id="config-fcm"></a>Configuring project for FCM

#### <a id="setup-pods"></a>Set up CocoaPods dependencies

* If you don't have an Xcode project yet, create one now
* Create a Podfile if you don't have one

```
$ cd your-project directory
$ pod init
```

* Add the `Firebase/Messaging` pod

```
pod 'Firebase/Messaging'
```

* Install the pods and open the .xcworkspace file to see the project in Xcode

```
$ pod install
$ open your-project.xcworkspace
```
	
#### <a id="enable-fcm"></a>Enabling FCM

Create a Firebase project in the [Firebase console][firebase-console] if you don't already have one. Enter the `AppName` and `Region`.

![createProject-1](https://github.com/vizury/vizury-ios-sdk/blob/master/resources/create-project.png)


Click on `iOS` option and in the next screen add the `iOS Bundle Id`. The `iOS Bundle Id` should be same as your apps bundle identifier. You can download the `GoogleService-Info.plist` file in the next step.

![createProject-2](https://github.com/vizury/vizury-ios-sdk/blob/master/resources/add-bundle-id.png)

`Note : The GoogleService-Info.plist file that you have downloaded will have certain settings like IS_ADS_ENABLED, IS_SIGNIN_ENABLED set as YES. You have to add correspinding pod dependencies for the same or you can turn them off if you are not using them`

Next go the `Manage` option of the created project.

![createProject-3](https://github.com/vizury/vizury-ios-sdk/blob/master/resources/manage-app.png )


Click on `Cloud Messaging` tab and upload APNs Authentication Key (.p8 format). Also note down the the `Legacy Server key` as this will be required later during the integration. You can also upload APNs certificaties but configuration with auth keys is recommended as they are the more current method for sending notifications to iOS

![createProject-4](https://github.com/vizury/vizury-ios-sdk/blob/master/resources/upload-p8.png )

While uploading APNs Authentication Key (.p8 format) you need to enter the KeyId and App Id prefix
1. 'Key ID' is the id of the authentication key you created in Apple developer console under Keys -> All 
2. 'App ID Prefix' is the app prefix in Apple developer console under Identifiers -> App Ids

![createProject-5](https://github.com/vizury/vizury-ios-sdk/blob/master/resources/key_prefix.png)

### <a id="config-app"></a>Configuring Application

* Drag the GoogleService-Info.plist file you just downloaded into the root of your Xcode project and add it to all targets
* Register for Pushnotifications inside didFinishLaunchingWithOptions method of you AppDelegate

#### Objective-C
----
```objc
    // Register for remote notifications. This shows a permission dialog on first run, to
    // show the dialog at a more appropriate time move this registration accordingly.
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // iOS 7.1 or earlier. Disable the deprecation warnings.
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
        #pragma clang diagnostic pop
    } else {
        // iOS 8 or later
        // [START register_for_notifications]
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
            #pragma clang diagnostic push
            #pragma clang diagnostic ignored "-Wdeprecated-declarations"
            UIUserNotificationType allNotificationTypes =
            (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
            UIUserNotificationSettings *settings =
            [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        } else {
            // iOS 10 or later
            #if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
            // For iOS 10 display notification (sent via APNS)
            [UNUserNotificationCenter currentNotificationCenter].delegate = self;
            UNAuthorizationOptions authOptions =
            UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
            [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
            }];
            #endif
        }
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        // [END register_for_notifications]
```
* For iOS10 and above you also need to add the below code. You can refer to the sample app.

```objc
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate () <UNUserNotificationCenterDelegate>
@end
#endif

```

#### Swift
----
```swift
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            UNUserNotificationCenter.current().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
```

* Post Registration 

Pass the APNS token to Vizury

#### Objective-C
----
```objc
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    [VizuryEventLogger registerForPushWithToken:deviceToken];
}
```

#### Swift
-----
```swift
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        VizuryEventLogger.registerForPush(withToken: deviceToken)
    }
```

In case of any failed registration

#### Objective-C
----
```objc
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {

    [VizuryEventLogger didFailToRegisterForPush];
}
```

#### Swift
-----
```swift
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        VizuryEventLogger.didFailToRegisterForPush()
    }
```    

* Handling notification payload

#### Objective-C
-----
```objc
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(							UIBackgroundFetchResult))completionHandler {
    [VizuryEventLogger didReceiveRemoteNotificationInApplication:application withUserInfo:userInfo];
 }
```

#### Swift
----
```swift
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler 			completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {        
        VizuryEventLogger.didReceiveRemoteNotification(in: application, withUserInfo: userInfo)
        if (application.applicationState == UIApplicationState.inactive) {
            self.customPushHandler(userInfo: userInfo)
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler 			completionHandler: @escaping () -> Void) {
        let pushDictionary = response.notification.request.content.userInfo
        VizuryEventLogger.didReceiveResponse(userInfo: pushDictionary)
        self.customPushHandler(userInfo: pushDictionary)
        completionHandler();
    }
```

### <a id="deeplinks"></a> Deeplinks

In order to open Deep Links that are sent to the device as a Key/Value pair along with a push notification you must implement a custom handler

#### Objective-C
-----
```objc
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(							UIBackgroundFetchResult))completionHandler {
    [VizuryEventLogger didReceiveRemoteNotificationInApplication:application withUserInfo:userInfo];
    if(application.applicationState == UIApplicationStateInactive) {
        NSLog(@"Appilication Inactive - the user has tapped in the notification when app was closed or in background");
    	[self customPushHandler:userInfo];
    }
 }

- (void) customPushHandler:(NSDictionary *)notification {
    if (notification !=nil && [notification objectForKey:@"deeplink"] != nil) {
        NSString* deeplink = [notification objectForKey:@"deeplink"];
        NSLog(@"%@",deeplink);
        // Here based on the deeplink you can open specific screens that's part of your app
    }
}
```

#### Swift
----
```swift
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler 			completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {        
        VizuryEventLogger.didReceiveRemoteNotification(in: application, withUserInfo: userInfo)
        if (application.applicationState == UIApplicationState.inactive) {
            self.customPushHandler(userInfo: userInfo)
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler 			completionHandler: @escaping () -> Void) {
        let pushDictionary = response.notification.request.content.userInfo
        VizuryEventLogger.didReceiveResponse(userInfo: pushDictionary)
        self.customPushHandler(userInfo: pushDictionary)
        completionHandler();
    }
    
    func customPushHandler(userInfo : [AnyHashable : Any]) {        
        if let deeplink =  userInfo[AnyHashable("deeplink")] {
	    // handle the deeplink
            print("deeplink is ", deeplink)
        } 
    }
```


### <a id="ios10-rich"></a> iOS 10 Rich Notifications

With iOS 10 you can add image, gifs, audio and video to your notifications.


#### <a id="create-noti-service"></a> Create Notification Service Extension

Add a Notification Service Extension target to your project (File -> New -> Target -> Notification Service Extension)

![rich-1](https://github.com/vizury/vizury-ios-sdk/blob/master/resources/note-service.png)

Define the name for the Notification Service Extension in the next step.

Make sure the deployment target for notification service is set to 10

Make sure in capabilities for the target App 
1. Push notifications is enabled
2. Background Modes is enabled with 

	a. Background Fetch
	b. Remote Notification

![rich-2](https://github.com/vizury/vizury-ios-sdk/blob/master/resources/enableBackgroundModes.png)


#### <a id="add-viz-noti"></a> Add Vizury to Notification Service Extension

Add the VizuryRichNotification folder to your Notification Service Extension target

![rich-3](https://github.com/vizury/vizury-ios-sdk/blob/master/resources/addVizNotiFiles.png)

Make the below code changes in the NotificationService.m file.

```objc
#import "VizuryRichNotification.h"

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];

    [[VizuryRichNotification getInstance] didReceiveNotificationRequest:request withContentHandler:contentHandler];
}
```


 [VizuryEventLogger_ios]:    https://github.com/vizury/vizury-ios-sdk/tree/master/binary
 [VizuryEventLogger_ios_bitcode_enable]:    https://github.com/vizury/vizury-ios-sdk/tree/master/binary/bitcodeEnabled
 [VizuryEventLogger_ios_bitcode_disable]:    https://github.com/vizury/vizury-ios-sdk/tree/master/binary/bitcodeDisabled
 [apple-dev-member-center]:  	https://developer.apple.com/membercenter/index.action
 [provisioning-profiles]:	https://firebase.google.com/docs/cloud-messaging/ios/certs
 [firebase-console]:           	https://console.firebase.google.com
