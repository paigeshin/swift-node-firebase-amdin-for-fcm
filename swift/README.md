# ios_push_notification_super_example

[ios Push Notification on Notion](https://www.notion.so/Remote-Push-Message-pure-version-40f6fd635d5246fba96caa748128eba7)

[https://medium.com/flawless-app-stories/ios-remote-push-notifications-in-a-nutshell-d05f5ccac252](https://medium.com/flawless-app-stories/ios-remote-push-notifications-in-a-nutshell-d05f5ccac252)

⇒ 내가 읽었던 article 중에 정말 최강이였음

[https://developer.apple.com/documentation/usernotifications/unnotificationcategory](https://developer.apple.com/documentation/usernotifications/unnotificationcategory)

⇒ payload schema를 참고함.

[https://github.com/paigeshin/ios_push_notification_super_example](https://github.com/paigeshin/ios_push_notification_super_example)

[https://medium.com/flawless-app-stories/ios-remote-push-notifications-in-a-nutshell-d05f5ccac252](https://medium.com/flawless-app-stories/ios-remote-push-notifications-in-a-nutshell-d05f5ccac252)

⇒ 내가 읽었던 article 중에 정말 최강이였음

[https://developer.apple.com/documentation/usernotifications/unnotificationcategory](https://developer.apple.com/documentation/usernotifications/unnotificationcategory)

⇒ payload schema를 참고함.

# What you can do with Push Notification

- Display a message
- Play a sound
- Set a badge icon on your app
- Provide actions the user can act upon with or without opening the app
- Show an image or other type of media
- Be silent but ask the app to perform some action in the background

### Tools to test

- APNS Pusher (You can find it on Mac App Store)

# Steps

### Step 1 - Enable APNs

- Enable APNs

⇒ Capabilities, Push Notification

### Step 2 - get APN Certificate

- Request a Certificate From a Certificate Autority

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/fb661848-774e-4b1c-b4b8-01064ab7b527/Untitled.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/fb661848-774e-4b1c-b4b8-01064ab7b527/Untitled.png)

⇒ Create `CertificateSigningRequest` file

- Go To Certificates, Identifiers Tap on Apple Development
- Click on `Push Notification Configure`

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/db30a607-7afc-4c21-a891-1ddf6a65fe82/Untitled.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/db30a607-7afc-4c21-a891-1ddf6a65fe82/Untitled.png)

❗️Note that `Development SSL Certificate` and `Production SSL Certificate` is different.

- Upload `CertificateSigningRequest`

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/cda1d4d0-4fed-48c9-9281-caaf5722980a/Untitled.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/cda1d4d0-4fed-48c9-9281-caaf5722980a/Untitled.png)

- Download `cer` file and double clikc on it to install on your key-chain

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/68b87d38-2ac7-4857-acb6-1c2b5aecb8c3/Untitled.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/68b87d38-2ac7-4857-acb6-1c2b5aecb8c3/Untitled.png)

ℹ️ In a nutshell

1. Request Authorization
2. Upload it on Apple App
3. Download Certificate
4. Install in on your key-chain

### Step 3

- write some code

```swift
//
//  AppDelegate.swift
//  push_notification
//
//  Created by shin seunghyun on 2020/08/19.
//  Copyright © 2020 paige sofrtware. All rights reserved.
//
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        regiseterForPushNotification()
        ///Reset Application Badge Number whenever user opens an app
        UIApplication.shared.applicationIconBadgeNumber = 0
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func regiseterForPushNotification() {
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission granted: ", granted)
            guard granted else {
                print("Permission rejected")
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
        }
        
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //ios 13 미만
    func applicationDidBecomeActive(_ application: UIApplication) {
        ///Reset Application Badge Number whenever user opens an app
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 1. Convert device token to string
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        // 2. Print device token to use for PNs payloads
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 1. Print out error if PNs registration not successful
        print("Failed to register for remote notifications with error: \(error)")
    }
    
    
    /// Handle user actions on Push Notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.actionIdentifier == "like" {
            print("Handle like action identifier")
        } else if response.actionIdentifier == "save" {
            print("Handle save action identifier")
        } else {
            print("No custom action identifiers chosen")
        }
        // Make sure completionHandler method is at the bottom of this func
        completionHandler()
    }
    
}
```

### Configure Basic Message

```json
{
	"aps": {
		"alert": "Tseting.. (0)",
		"badge": 1,
		"sound": "default"
	}
}
```

# Advanced

### What is payload?

- JSON Dataformat

```json
{ 
	"aps": {
		"alert":"Testing.. (0)",
		"badge":1,
		"sound":"default",
		"category": "beautifulgirl", 
		"mutable-content": 1,
		"attachment-url": "https://www.goodfreephotos.com/albums/people/beautiful-girl-with-long-hair-and-pretty-eyes.jpg"
	}
 }
```

### Configure Advaced Message - `mutable-content`

```json
{ 
   "aps": {
			"alert":"Testing.. (0)",
			"badge":1,
			"sound":"default",
			"mutable-content": 1,
			"attachment-url": "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pinterest.com.au%2Fpin%2F495536765244215974%2F&psig=AOvVaw2dbyTUEg-pnhbcSE4N_a04&ust=1597926024936000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCKCc0Lugp-sCFQAAAAAdAAAAABAN"
   }
}
```

### Notification Service Extension

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/a6ff9014-cfa2-4277-afff-e240515112ef/Untitled.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/a6ff9014-cfa2-4277-afff-e240515112ef/Untitled.png)

### code

```swift
//
//  NotificationService.swift
//  NotificationService
//
//  Created by shin seunghyun on 2020/08/19.
//  Copyright © 2020 paige sofrtware. All rights reserved.
//
import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent, // 1. Make sure bestAttemptContent is not nil
            let apsData = bestAttemptContent.userInfo["aps"] as? [String: Any], // 2. Dig in the payload to get the data
            let attachmentURLAsString = apsData["attachment-url"] as? String, // 3. The attachment-url, message에 있는 field 이름임.
            let attachmentURL = URL(string: attachmentURLAsString) else { // 4. And parse it to URL
                return
        }
        
  // 6. Add some actions and add them in a category which is then added to the notificationCategories
  //Payload에 카테고리를 추가해줘야한다
        /*
         const hello =
             {
                 "aps": {
                     "alert":"Testing.. (0)",
                     "badge":1,
                     "sound":"default",
                     "category": "unicorning",
                     "mutable-content": 1,
                     "attachment-url": "https://www.goodfreephotos.com/albums/people/beautiful-girl-with-long-hair-and-pretty-eyes.jpg"
                 }
          }
         */
  let likeAction = UNNotificationAction(identifier: "like", title: "Like", options: [])
  let saveAction = UNNotificationAction(identifier: "save", title: "Save", options: [])
  let category = UNNotificationCategory(identifier: "beautifulgirl", actions: [likeAction, saveAction], intentIdentifiers: [], options: [])
  UNUserNotificationCenter.current().setNotificationCategories([category])
        
        // 5. Download the image and pass it to attachments if not nil
        downloadImageFrom(url: attachmentURL) { (attachment) in
            if attachment != nil {
                /// Add Actions
                bestAttemptContent.attachments = [attachment!]
                contentHandler(bestAttemptContent)
            }
        }
        
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}

//MARK: - Helper Functions
extension NotificationService {
    
    /**** Attachment에서 들어온 정보를 Local에다가 저장하고 그 Attachment의 정보를 외부에다가 다시 보내준다. ****/
    /// Use this function to donwload an image and present it in a notification
    ///
    /// - Parameters:
    ///  - url: the url of the picture
    ///  - completion: return the image in the form of UNNotificationAttachment to be added to the bestAttemptContent attachments eventually
    private func downloadImageFrom(url: URL, with completionHandler: @escaping(UNNotificationAttachment?) -> Void) {
        let task = URLSession.shared.downloadTask(with: url) { (downloadedUrl, response, error) in
            // 1. Test URL and escape if URL not OK
            guard let downloadedUrl = downloadedUrl else {
                completionHandler(nil)
                return
            }
            // 2. Get current user's temporary directory path
            var urlPath = URL(fileURLWithPath: NSTemporaryDirectory())
            // 3. Add proper extension to url path, in hte case .jpg  (The system validates the content of attached files before scheduling the corresponding notification request. If an attached file is corrupted, invalid, or of an unsupported file type, the notification request is not scheduled for delivery.)
            let uniqueURLEnding = ProcessInfo.processInfo.globallyUniqueString + ".jpg"
            urlPath = urlPath.appendingPathComponent(uniqueURLEnding)
            
            // 4. Move downloadedUrl to newly created urlPath
            try? FileManager.default.moveItem(at: downloadedUrl, to: urlPath)
            
            // 5. Try adding getting the attachment(attachment from message) and pass it to the completion handler
            do {
                /// - Parameters:
                ///  - identifer: The unique identifier of the attachment. Use this string to identify the attachment later. If you specify an empty string, this method creates a unique identifier string for you.
                ///  - URL: The URL of the file you want to attach to the notification. The URL must be `a file URL` and the file must be readable by the current process. This parameter must not be nil. For a list of supported file types, see Supported File Types.
                ///  - options: A dictionary of options related to the attached file. Use the options to specify meta information about the attachment, such as the clipping rectangle to use for the resulting thumbnail.
                let attachment = try UNNotificationAttachment(identifier: "", url: urlPath, options: nil)
                completionHandler(attachment)
            } catch {
                completionHandler(nil)
            }
        }
        task.resume()
    }
    
}
```

❗️message `payload`  에 `category`  를 추가해줘야 해줄 수 있다. 아니면 절대 불가능함.

# **Conclusion**

After so much work done, probably it is best to go for a short conclusion, right? That is, I hope I not only helped you familiarize yourselves with APNs but also got you to put “*Digging deeper in the APNs and playing with some ideas*” topic on your bucket list! Because trust me, there is so much more to it 😃.

# **Update providing additional clarification regarding APNs certificates**

I received some positive criticism pointing out that I was not clear enough when setting up the Unicorner demo app’s APNs certificates. And yes, I need to stress that when **testing and building the app using Xcode, I used a development certificate**. **If you decide to release a beta version using TestFlight, or a production version in the AppStore, you need to use a production certificate and not a development one**!

It is also worth mentioning that there is another way to set up your **Push Notifications** and that is using an **APNs Auth Key**. Doing that has two main benefits:

- No need to re-generate the push certificate every year.
- One auth key can be used for all your apps — this avoids the complication of maintaining different certificates.

If you think that an **APNS Auth Key** would work better for you, [follow these easy set-up instructions](https://developer.clevertap.com/docs/how-to-create-an-ios-apns-auth-key).

# Additional Information

- Can I increment the number of badges displayed?

There’s no way to “increment” the number. The number you provide in the notification is what will be set on the badge. This is built-in to how push notifications operate on the OS in general I believe.

You’ll want to think about what the badge number is based on. Is it a number of unread messages? What constitutes “reading” a message? Because a user will not want that badge to stay there forever (and you need to tell your app when to clear it).

In our app, the badge number is based on unread messages. When a user receives a message, it starts with an unread flag set to true in our database. We send out a push notification with the badge number set to the total number of messages in the database for that user where unread is set to true.

When the user downloads the messages, the same API call that downloads the messages also flips the unread flag to false for all messages that are downloaded. At the same time the user downloads the messages in the app, the app also receives an updated count of the unread messages. Then we call setBadgeNumberAsync ([https://docs.expo.io/versions/latest/sdk/notifications#exponotificationssetbadgenumberasyncnumber 766](https://docs.expo.io/versions/latest/sdk/notifications#exponotificationssetbadgenumberasyncnumber)) with the updated number.

# My Conclusion

- 내가 배포하는 앱에 push notification certificate가 있다.

### SNS 서비스

- Client에서 아래와 같은 형태의 데이터를 device token과 유저정보를 가지고 나의 node server로 보낸다.  (like 같은 것을 누름) ⇒ 아마도 상대 device token 값을 알아낼 필요가 있음.. (post라던지)

```json
{ 
	"aps": {
		"alert":"Testing.. (0)",
		"badge":1,
		"sound":"default",
		"category": "beautifulgirl", 
		"mutable-content": 1,
		"attachment-url": "https://www.goodfreephotos.com/albums/people/beautiful-girl-with-long-hair-and-pretty-eyes.jpg"
	}
 }
```

- Node Server에서 APN Server로 위의 payload를 보낸다.
- APN Server에서 device token에 해당되는 곳에 push message를 보낸다.

### Alarm 서비스

- 나의 node server는 유저가 가입할 때 던져주는 device token을 받아서 저장하고 있다.
- setTimeout 같은 API를 이용해서 1시간마다 db를 체크
- 유저가 선택한 시간 값에 걸리는 것이 있다면 APN 서버에 device token과 함께 payload를 던진다.