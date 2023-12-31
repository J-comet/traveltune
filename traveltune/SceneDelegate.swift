//
//  SceneDelegate.swift
//  traveltune
//
//  Created by 장혜성 on 2023/09/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.rootViewController = SplashVC(
            viewModel: SplashViewModel(
                remoteTravelSpotRepository: TravelSpotRepository(),
                localTravelSpotRepository: LocalTravelSpotRepository()
            )
        )
        window?.makeKeyAndVisible()
        
        NetworkMonitor.shared.startMonitoring(statusUpdateHandler: { status in
            switch status {
            case .satisfied:
                NetworkMonitor.shared.isConnected = true
            case .unsatisfied:
                NetworkMonitor.shared.isConnected = false
            default:
                break
            }
        })
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        NetworkMonitor.shared.stopMonitoring()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        // 알림 뱃지 제거
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        print("Foreground -> Background 로 이동중")
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("Background -> Foreground 로 이동중")
        
        /**
         현재 AVPlayer 재생상태 값 Notification 으로 전달하기
         */
        let playerStatus = switch AVPlayerManager.shared.status {
        case .playing: AVPlayerManager.RemotePlayerStatus.play.rawValue
        case .stop: AVPlayerManager.RemotePlayerStatus.stop.rawValue
        case .waitingToPlay: AVPlayerManager.RemotePlayerStatus.stop.rawValue
        }
        
        NotificationCenter.default.post(
                name: .playerStatus,
                object: nil,
                userInfo: ["status" : playerStatus]
            )
        
//        NotificationManager.shared.checkNotiPermission()
//        NotificationCenter.default.post(
//                name: .notificationStatus,
//                object: nil,
//                userInfo: ["notiStatus" : NotificationManager.shared.notificationStatus]
//            )
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

