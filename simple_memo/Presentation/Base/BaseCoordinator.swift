import Foundation
import UIKit
import RxSwift
import RxCocoa

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    func start()
    func start(coordinator: Coordinator)
    func removeChildCoordinators()
    func didFinish(coordinator: Coordinator)
}

class BaseCoordinator: Coordinator {
    
    var disposeBag = DisposeBag()
        
    var parentCoordinator: Coordinator?
    var childCoordinators = [Coordinator]()
    
    func start() {
        fatalError("Start method should be implemented.")
    }
    
    func start(coordinator: Coordinator) {
        self.childCoordinators += [coordinator]
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func removeChildCoordinators() {
        self.childCoordinators.forEach { $0.removeChildCoordinators() }
        self.childCoordinators.removeAll()
    }
    
    func didFinish(coordinator: Coordinator) {
        if let index = self.childCoordinators.firstIndex(where: { $0 === coordinator }) {
            self.childCoordinators.remove(at: index)
        }
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
}
