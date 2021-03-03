import UIKit

class AppCoordinator: BaseCoordinator {
        
    private let window = UIWindow(frame: UIScreen.main.bounds)
    
    private let authentificationCoordinator: AuthentificationCoordinator
    private let mainCoordinator: MainCoordinator
    
    init (authentificationCoordinator: AuthentificationCoordinator, mainCoordinator: MainCoordinator) {
        self.authentificationCoordinator = authentificationCoordinator
        self.mainCoordinator = mainCoordinator
    }
    
    let isLoggedIn = true
    
    override func start() {
        if (isLoggedIn) {
            showMain()
        } else {
            showAuthentification()
        }
        ThemeManager.setup()
    }
    
    func showMain() {        
        removeChildCoordinators()
        let coordinator = mainCoordinator
        self.start(coordinator: coordinator)
        let rootViewController = coordinator.rootViewController!
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    func showAuthentification() {
        removeChildCoordinators()
        let coordinator = authentificationCoordinator
        self.start(coordinator: coordinator)
        let rootViewController = coordinator.rootViewController!
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
    
    func applyLightTheme() {
        window.overrideUserInterfaceStyle = .light
    }
    
    override func removeChildCoordinators() {
        super.removeChildCoordinators()
    }
    
    func applyDarkTheme() {
        window.overrideUserInterfaceStyle = .dark
    }
}






