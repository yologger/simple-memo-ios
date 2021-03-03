import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    deinit {
        self.disposeBag = DisposeBag()
    }
}
