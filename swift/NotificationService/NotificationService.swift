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
        print("NotificationService bestAttempContent: " , bestAttemptContent)
        
  // 6. Add some actions and add them in a category which is then added to the notificationCategories
  //Payload에 카테고리를 추가해줘야한다
        /*
         const hello =
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
