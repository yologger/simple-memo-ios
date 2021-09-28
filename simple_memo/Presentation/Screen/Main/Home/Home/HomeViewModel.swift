import UIKit
import RxSwift

class HomeViewModel: BaseViewModel {
    
    private var memoRepository: MemoRepository
        
    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
        super.init()
    }
    
    var _memos = Array<Memo>()
    
    let event = PublishSubject<HomeVMEvent>()
    let memos = PublishSubject<Array<Memo>>()
    
    func getAllMemos() {
        memoRepository.getAllMemos()
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (memos) in
                self?.memos.onNext(memos)
                self?._memos = memos
            } onFailure: { (error) in
    
            } onDisposed: {
                
            }.disposed(by: disposeBag)
    }
    
    func showCreate() {
        event.onNext(.SHOW_CREATE)
    }
    
    func showReorder() {
        event.onNext(.SHOW_REORDER)
    }
    
    func showDetail(memoId: Int) {
        event.onNext(.SHOW_DETAIL(memoId))
    }
}
