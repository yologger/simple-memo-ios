import UIKit
import Foundation

extension UIColor {
    
    static func colorFromHexString (_ hex:String) -> UIColor {
        
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

enum AppColor {
    
    static var Black = UIColor.colorFromHexString("#000000")
    static var White = UIColor.colorFromHexString("#ffffff")
    
    enum Yellow {
        static var Light = UIColor.colorFromHexString("#FFF2C5")
        static var Default = UIColor.colorFromHexString("#FDEBAE")
        static var Dark = UIColor.colorFromHexString("#FDE594")
    }
    
    enum Grey {
        static var Light = UIColor.colorFromHexString("#bfbfbf")
        static var Default = UIColor.colorFromHexString("#808080")
        static var Dark = UIColor.colorFromHexString("#262626")
    }
    
    static var Primary: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if (UITraitCollection.userInterfaceStyle == .dark) {
                return AppColor.Yellow.Default
            } else {
                return AppColor.Black
            }
        }
    }()
    
    static var PrimaryVariant: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if (UITraitCollection.userInterfaceStyle == .dark) {
                return AppColor.Black
            } else {
                return UIColor.yellow
            }
        }
    }()

    static var OnPrimary: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if (UITraitCollection.userInterfaceStyle == .dark) {
                return AppColor.Black
            } else {
                return AppColor.White
            }
        }
    }()
    
    static var Secondary: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if (UITraitCollection.userInterfaceStyle == .dark) {
                return AppColor.Yellow.Default
            } else {
                return AppColor.Black
            }
        }
    }()
    
    static var SecondaryVariant: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if (UITraitCollection.userInterfaceStyle == .dark) {
                return AppColor.Black
            } else {
                return UIColor.yellow
            }
        }
    }()

    static var OnSecondary: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if (UITraitCollection.userInterfaceStyle == .dark) {
                return AppColor.Black
            } else {
                return AppColor.White
            }
        }
    }()
    
    static var Text: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if (UITraitCollection.userInterfaceStyle == .dark) {
                return AppColor.White
            } else {
                return AppColor.Black
            }
        }
    }()
    
    static var Button: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if (UITraitCollection.userInterfaceStyle == .dark) {
                return AppColor.White
            } else {
                return AppColor.Black
            }
        }
    }()
    
    enum TabBar {
        static var TintColor: UIColor = AppColor.Primary
        static var BarTintColor: UIColor = {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if (UITraitCollection.userInterfaceStyle == .dark) {
                    return AppColor.Black
                } else {
                    return AppColor.White
                }
            }
        }()
    }
    
    enum Switch {
        static var thumbTintColor: UIColor = {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if (UITraitCollection.userInterfaceStyle == .dark) {
                    return AppColor.Grey.Dark
                } else {
                    return AppColor.White
                }
            }
        }()
    }
    
    enum NavigationBar {
        static var itemColor: UIColor = AppColor.Primary
        static var backgroundColor: UIColor = {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if (UITraitCollection.userInterfaceStyle == .dark) {
                    return AppColor.Grey.Dark
                } else {
                    return AppColor.White
                }
            }
        }()
    }
    
    static var Divider: UIColor = {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if (UITraitCollection.userInterfaceStyle == .dark) {
                return AppColor.Grey.Dark
            } else {
                return AppColor.Black
            }
        }
    }()
}
