import UIKit
import RxSwift

class ReorderViewModel: BaseViewModel {
    
    private var memoRepository: MemoRepository
        
    init(memoRepository: MemoRepository) {
        self.memoRepository = memoRepository
        super.init()
    }

    let event = PublishSubject<ReorderVMEvent>()
    let memos = PublishSubject<Array<Memo>>()
    
    func getAllMemos() {
        memoRepository.getAllMemos()
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .default))
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] (memos) in
                self?.memos.onNext(memos)
                print(memos)
            } onFailure: { (error) in
                
            } onDisposed: {
                
            }.disposed(by: disposeBag)
    }

    func close() {
        event.onNext(.CLOSE)
    }
    
    func save(memos: Array<Memo>, deletedMemos: Array<Memo>) {
        print("SAVE")
        
        var newMemos = Array<Memo>()
        
        for (index, memo) in memos.enumerated() {
            let newMemo = Memo(id: memo.id, title: memo.title, content: memo.content, position: index)
            newMemos.append(newMemo)
        }
        
        memoRepository
            .deleteMemos(memos: deletedMemos)
            .andThen(memoRepository.updateMemos(memos: newMemos))
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
