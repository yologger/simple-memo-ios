import UIKit
import Foundation

struct ThemeManager {
    
    static var isDarkTheme: Bool {
        get {
            if let isDarkTheme = UserDefaults.standard.value(forKey: Constant.Key.ThemeKey) as? Bool {
                return isDarkTheme
            } else {
                return false
            }
        }
    }
    
    static func setup() {
        if let isDarkTheme = UserDefaults.standard.value(forKey: Constant.Key.ThemeKey) as? Bool {
            if (isDarkTheme) {
                let appCoordinator = (UIApplication.shared.delegate as? AppDelegate)?.appCoordinator
                appCoordinator?.applyDarkTheme()
            } else {
                let appCoordinator = (UIApplication.shared.delegate as? AppDelegate)?.appCoordinator
                appCoordinator?.applyLightTheme()
            }
        } else {
            let appCoordinator = (UIApplication.shared.delegate as? AppDelegate)?.appCoordinator
            appCoordinator?.applyLightTheme()
        }
        
        ThemeManager.setupStyle()
    }
    
    private static func setupStyle() {
        UILabel.appearance().textColor = AppColor.Text
        
        UIButton.appearance().tintColor = AppColor.Button
        
        UITabBar.appearance().tintColor = AppColor.TabBar.TintColor
        UITabBar.appearance().barTintColor = AppColor.TabBar.BarTintColor
        
        UISwitch.appearance().onTintColor = AppColor.Primary
        UISwitch.appearance().thumbTintColor = AppColor.Switch.thumbTintColor
    }
    
    static func applyLightTheme() {
        UserDefaults.standard.setValue(false, forKey: Constant.Key.ThemeKey)
        UserDefaults.standard.synchronize()
        let appCoordinator = (UIApplication.shared.delegate as? AppDelegate)?.appCoordinator
        appCoordinator?.applyLightTheme()
//        let sharedApplication = UIApplication.shared
//        sharedApplication.delegate?.window??.overrideUserInterfaceStyle = .light
    }
    
    static func applyDarkTheme() {
        UserDefaults.standard.setValue(true, forKey: Constant.Key.ThemeKey)
        UserDefaults.standard.synchronize()
        let appCoordinator = (UIApplication.shared.delegate as? AppDelegate)?.appCoordinator
        appCoordinator?.applyDarkTheme()
//        let sharedApplication = UIApplication.shared
//        sharedApplication.delegate?.window??.overrideUserInterfaceStyle = .dark
    }
}
