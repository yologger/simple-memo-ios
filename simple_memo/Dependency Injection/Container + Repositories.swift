import Swinject
import SwinjectAutoregistration

extension Container {
    func registerRepositories() {
        self.autoregister(MemoRepository.self, initializer: MemoRepositoryImpl.init).inObjectScope(.container)
    }
}
