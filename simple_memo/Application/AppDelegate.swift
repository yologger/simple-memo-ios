import UIKit
import Swinject
import SwinjectAutoregistration
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    static var diContainer = Container()
    var appCoordinator: AppCoordinator?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupDI()
        setupCoordinator()
        return true
    }
    
    func setupDI() {
        AppDelegate.diContainer.registerDependencies()
    }
    
    func setupCoordinator() {
        appCoordinator = AppDelegate.diContainer.resolve(AppCoordinator.self)
        appCoordinator?.start()
    }
}

