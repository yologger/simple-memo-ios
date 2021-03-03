import RxSwift
import RxCocoa

protocol MemoRepository {
    func getAllMemos() -> Single<Array<Memo>>
    func getMaxPosition() -> Single<Int>
    func createMemo(title: String, content: String, position: Int) -> Completable
    func deleteMemos(memos: Array<Memo>) -> Completable
    func updateMemos(memos: Array<Memo>) -> Completable
    func getMemoById(id: Int) -> Single<Memo>
    func updateMemo(id: Int, title: String, content: String) -> Completable
    func deleteMemoById(id: Int) -> Completable
}
