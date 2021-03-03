import UIKit
import RxSwift

class BaseViewModel {
    var disposeBag = DisposeBag()
    
    deinit {
        disposeBag = DisposeBag()
    }
}
