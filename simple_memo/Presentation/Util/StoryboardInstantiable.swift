import Foundation
import UIKit

import Foundation

enum AppStoryboard: String {
    case logIn = "LogIn"
    case signUp = "SignUp"
    case home = "Home"
    case settings = "Settings"
    case create = "Create"
    case reorder = "Reorder"
    case edit = "Edit"
    case detail = "Detail"
}

protocol StoryboardInstantiable {
    static var storyboard: AppStoryboard { get }
    static func instantiate() -> Self
}

extension StoryboardInstantiable {
    static func instantiate() -> Self {
        let identifier = String(describing: self)
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        let viewController = uiStoryboard.instantiateViewController(withIdentifier: identifier) as! Self

        return viewController
    }
}
