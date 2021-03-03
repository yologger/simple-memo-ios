import UIKit

class AuthentificationCoordinator: BaseCoordinator {
    
    var rootViewController: UINavigationController?
    
    override func start() {
        rootViewController = UINavigationController()
        let logInViewController = LogInViewController.instantiate()
        rootViewController?.setViewControllers([logInViewController], animated: true)
    }
  
    
    deinit {
        print("AuthentificationCoordinator: deinit{}")
    }
}
