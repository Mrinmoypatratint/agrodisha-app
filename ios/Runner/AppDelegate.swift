import UIKit
import Flutter
import FirebaseCore
import GoogleMaps
import FirebaseAuth
import FirebaseMessaging
//import shared_preferences_ios

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyD622HBVKUal9njLJ8l6NKtRN0SIhNafaw")

    GeneratedPluginRegistrant.register(with: self)

    if FirebaseApp.app() == nil {
        FirebaseApp.configure()
    }
    //GADMobileAds.sharedInstance().requestConfiguration.setSameAppKeyEnabled(false)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
/*   override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
                     let firebaseAuth = Auth.auth()
                     firebaseAuth.setAPNSToken(deviceToken, type: AuthAPNSTokenType.unknown)
           }
  override func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
                     let firebaseAuth = Auth.auth()
                     if (firebaseAuth.canHandleNotification(userInfo)){
                         print(userInfo)
                         return
                     }
          } */
 override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // NOTE: For logging
    // let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
    // print("==== didRegisterForRemoteNotificationsWithDeviceToken ====")
    // print(deviceTokenString)
    Messaging.messaging().apnsToken = deviceToken
  }

}

