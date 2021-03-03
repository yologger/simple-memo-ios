import UIKit
import Swinject
import SwinjectAutoregistration

extension Container {
    func registerCoordinators() {
        self.autoregister(AppCoordinator.self, initializer: AppCoordinator.init)
        self.autoregister(AuthentificationCoordinator.self, initializer: AuthentificationCoordinator.init)
        self.autoregister(MainCoordinator.self, initializer: MainCoordinator.init)
        self.autoregister(HomeCoordinator.self, initializer: HomeCoordinator.init)
        self.autoregister(SettingsCoordinator.self, initializer: SettingsCoordinator.init)
    }
}
