import UIKit
import RxSwift

class DetailViewModel: BaseViewModel {
    
    let event = PublishSubject<DetailVMEvent>()
    
    private var memoRepository: MemoRepository
    
    let title = PublishSubject<String>()
    let content = PublishSubject<String>()
        
    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
        super.init()
    }
    
    func close() {
        event.onNext(.CLOSE)
    }
    
    func openEdit(memoId: Int) {
        event.onNext(.SHOW_EDIT(memoId))
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
    
    func deleteMemoById(id: Int) {
        memoRepository.deleteMemoById(id: id)
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
