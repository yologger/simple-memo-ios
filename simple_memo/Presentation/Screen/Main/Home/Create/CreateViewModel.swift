import UIKit
import RxSwift

class CreateViewModel: BaseViewModel {
    
    private var memoRepository: MemoRepository
    let event = PublishSubject<CreateVMEvent>()
    
    let title = PublishSubject<String>()
    let content = PublishSubject<String>()
    
    private var maxPosition: Int = 0
        
    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
        super.init()
        getMaxPosition()
    }
    
    func close() {
        event.onNext(.CLOSE)
    }
    
    func getMaxPosition() {
        memoRepository.getMaxPosition()
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] position in
                self?.maxPosition = position
            }, onFailure: { error in
                
            }, onDisposed: {
                
            }).disposed(by: disposeBag)
    }
    
    func save(title: String, content: String) {
        
        var newTitle: String
        
        if (title == "") {
            let strArr = content.components(separatedBy: " ")
            newTitle = strArr[0]
        } else {
            newTitle = title
        }
        
        maxPosition += 1
        memoRepository.createMemo(title: newTitle, content: content, position: maxPosition)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .observe(on: MainScheduler.instance)
            .subscribe(onCompleted: { [weak self] in
                self?.event.onNext(.DELETE_SUCCESS)
            }, onError: { [weak self] error in
                self?.event.onNext(.DELETE_FAILURE)
            }, onDisposed: {
                
            }).disposed(by: disposeBag)
    }
}
