import Swinject
import SwinjectAutoregistration

extension Container {
    func registerDataSources() {
        self.autoregister(MemoDao.self, initializer: MemoDaoImpl.init)
    }
}
