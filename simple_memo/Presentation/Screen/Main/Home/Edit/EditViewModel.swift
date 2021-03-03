import UIKit
import RxSwift
import RxCocoa

class EditViewModel: BaseViewModel {
    
    private var memoRepository: MemoRepository
    
    let event = PublishSubject<EditVMEvent>()
    
    let title = PublishSubject<String>()
    let content = PublishSubject<String>()
    
    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
        super.init()
    }
    
    func close() {
        event.onNext(.CLOSE)
    }
    
    func getMemoById(id: Int) {
        memoRepository.getMemoById(id: id)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] memo in
                let title = memo.title
                let content = memo.content
                self?.title.onNext(title)
                self?.content.onNext(content)
            }, onFailure: { error in
                print("onError")
                print(error.localizedDescription)
            }, onDisposed: {
                
            }).disposed(by: disposeBag)
    }
    
    func update(id: Int, title: String, content: String) {
        memoRepository.updateMemo(id: id, title: title, content: content)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .observe(on: MainScheduler.instance)
            .subscribe(onCompleted: { [weak self] in
                self?.event.onNext(.UPDATE_SUCCESS)
            }, onError: { [weak self] error in
                self?.event.onNext(.UPDATE_FAILURE)
            }, onDisposed: {
                
            }).disposed(by: disposeBag)
    }
}
