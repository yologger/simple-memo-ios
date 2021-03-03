import UIKit


class SettingsCoordinator: BaseCoordinator {
    
    var rootViewController: SettingsViewController?
    
    override func start() {
        rootViewController = SettingsViewController.instantiate()
    }
}
