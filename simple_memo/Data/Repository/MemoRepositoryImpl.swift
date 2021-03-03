import RxSwift
import RxCocoa

class MemoRepositoryImpl {
    
    let memoDao: MemoDao
    
    init(memoDao: MemoDao) {
        self.memoDao = memoDao
    }
}

extension MemoRepositoryImpl: MemoRepository {
    
    func getAllMemos() -> Single<Array<Memo>> {
        return memoDao.getAll().map { memoEntities in
            memoEntities.map { memoEntity in
                Memo(id: memoEntity.id, title: memoEntity.title, content: memoEntity.content, position: memoEntity.position)
            }
        }
    }
    
    func createMemo(title: String, content: String, position: Int) -> Completable {
        return memoDao.create(title: title, content: content, position: position)
    }
    
    func getMaxPosition() -> Single<Int> {
        return memoDao.getMaxPosition()
    }
    
    func deleteMemos(memos: Array<Memo>) -> Completable {
        let memoEntities = memos.map { memo in
            MemoEntity(id: memo.id, title: memo.title, content: memo.content, position: memo.position)
        }
        return memoDao.deleteMemos(memos: memoEntities)
    }
    
    func updateMemos(memos: Array<Memo>) -> Completable {
        let memoEntities = memos.map { memo in
            MemoEntity(id: memo.id, title: memo.title, content: memo.content, position: memo.position)
        }
        return memoDao.updateMemos(memos: memoEntities)
    }
    
    func getMemoById(id: Int) -> Single<Memo> {
        return memoDao.getMemoById(id: id).map { memoEntity in
            return Memo(id: memoEntity.id, title: memoEntity.title, content: memoEntity.content, position: memoEntity.position)
        }
    }
    
    func updateMemo(id: Int, title: String, content: String) -> Completable {
        return memoDao.updateMemo(id: id, title: title, content: content)
    }
    
    func deleteMemoById(id: Int) -> Completable {
        return memoDao.deleteMemoById(id: id)
    }
}
