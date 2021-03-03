import UIKit
import Swinject
import SwinjectAutoregistration

extension Container {
    func registerViewModels() {
        self.autoregister(HomeViewModel.self, initializer: HomeViewModel.init)
        self.autoregister(LogInViewModel.self, initializer: LogInViewModel.init)
        self.autoregister(CreateViewModel.self, initializer: CreateViewModel.init)
        self.autoregister(ReorderViewModel.self, initializer: ReorderViewModel.init)
        self.autoregister(DetailViewModel.self, initializer: DetailViewModel.init)
        self.autoregister(EditViewModel.self, initializer: EditViewModel.init)
    }
}
