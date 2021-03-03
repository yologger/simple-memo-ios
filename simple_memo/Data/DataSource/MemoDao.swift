import RxSwift
import RxCocoa

protocol MemoDao {
    func getMaxPosition() -> Single<Int>
    func getAll() -> Single<Array<MemoEntity>>
    func create(title: String, content: String, position: Int) -> Completable
    func deleteMemos(memos: Array<MemoEntity>) -> Completable
    func updateMemos(memos: Array<MemoEntity>) -> Completable
    func getMemoById(id: Int) -> Single<MemoEntity>
    func updateMemo(id: Int, title: String, content: String) -> Completable
    func deleteMemoById(id: Int) -> Completable
}
