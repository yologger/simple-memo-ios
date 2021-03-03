import UIKit

class MainCoordinator : BaseCoordinator {
    
    var rootViewController: UITabBarController?
    
    private let homeViewModel: HomeViewModel
    
    init (homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    override func start() {
        let homeViewController = getHomeViewController()
        let settingsViewController = getSettingsViewController()
        
        rootViewController = UITabBarController()
        rootViewController?.setViewControllers([homeViewController, settingsViewController], animated: true)
        
    }
    
    private func getHomeViewController() -> UIViewController {
        // self.removeChildCoordinators()
        let coordinator = AppDelegate.diContainer.resolve(HomeCoordinator.self)!
        self.start(coordinator: coordinator)
        let homeViewController = coordinator.rootViewController!
        let title = NSLocalizedString("MainCoordinator_tabitem_home", comment: "")
        let image = UIImage(named: "Icon_home_outlined")
        let selectedImage = UIImage(named: "Icon_home_filled")
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        homeViewController.tabBarItem = tabBarItem
        return homeViewController
    }
    
    private func getSettingsViewController() -> UIViewController {
        // self.removeChildCoordinators()
        let coordinator = AppDelegate.diContainer.resolve(SettingsCoordinator.self)!
        self.start(coordinator: coordinator)
        let settingsViewController = coordinator.rootViewController!
        let title = NSLocalizedString("MainCoordinator_tabitem_settings", comment: "")
        let image = UIImage(named: "Icon_settings_outlined")
        let selectedImage = UIImage(named: "Icon_settings_filled")
        let tabBarItem = UITabBarItem(title: title, image: image, selectedImage: selectedImage)
        settingsViewController.tabBarItem = tabBarItem
        return settingsViewController
    }
}
