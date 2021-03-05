import FMDB
import RxSwift
import RxCocoa

class MemoDaoImpl {
    
    lazy var fmdb: FMDatabase! = {
        let fileMgr = FileManager.default
        // Document Directory
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docPath = dirPaths[0] as String
        let dbPath = docPath.appending("db.sqlite")
        // Check whether 'db.sqlite' exists in Document Directory
        if !fileMgr.fileExists(atPath: dbPath) {
            // If not exist, copy from App Bundle to Document Directory
            let dbSource = Bundle.main.path(forResource: "db", ofType: "sqlite")
            try! fileMgr.copyItem(atPath: dbSource!, toPath: dbPath)
        }
        let db = FMDatabase(path: dbPath)
        return db
    }()
    
    init() {
        self.fmdb.open()
    }
    
    deinit {
        self.fmdb.close()
    }
}

extension MemoDaoImpl: MemoDao {
    
    func create(title: String, content: String, position: Int) -> Completable {
        return Completable.create { emitter in
            do {
                let sql = "INSERT INTO memo(title, content, position) VALUES(?, ?, ?)"
                try self.fmdb.executeUpdate(sql, values: [title, content, position])
                emitter(.completed)
            } catch let error as NSError {
                emitter(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func getAll() -> Single<Array<MemoEntity>> {
        return Single.create { emitter in
            do {
                let sql = "SELECT * FROM memo ORDER BY position ASC"
                let resultSet = try self.fmdb.executeQuery(sql, values: nil)
                var memoEntities = Array<MemoEntity>()
                while resultSet.next() {
                    let id = Int(resultSet.int(forColumn: "id"))
                    let title = resultSet.string(forColumn: "title")!
                    let content = resultSet.string(forColumn: "content")!
                    let position = Int(resultSet.int(forColumn: "position"))
                    let memoEntity = MemoEntity(id: id, title: title, content: content, position: position)
                    memoEntities.append(memoEntity)
                }
                emitter(.success(memoEntities))
            } catch let error as NSError {
                emitter(.failure(error))
            }
            return Disposables.create()
        }
        
    }
    
    func getMaxPosition() -> Single<Int> {
        return Single.create { emitter in
            do {
                let sql = "SELECT MAX(position) FROM memo"
                let result = try self.fmdb.executeQuery(sql, values: nil)
                result.next()
                let position = Int(result.int(forColumnIndex: 0))
                emitter(.success(position))
            } catch let error as NSError {
                emitter(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    func deleteMemos(memos: Array<MemoEntity>) -> Completable {
        return Completable.create { [weak self] emitter in
            do {
                for memo in memos {
                    let sql = "DELETE FROM memo WHERE id = ?"
                    try self?.fmdb.executeUpdate(sql, values: [memo.id])
                }
                emitter(.completed)
            } catch let error as NSError {
                emitter(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func deleteMemoById(id: Int) -> Completable {
        return Completable.create { [weak self] emitter in
            do {
                let sql = "DELETE FROM memo WHERE id = ?"
                try self?.fmdb.executeUpdate(sql, values: [id])
                emitter(.completed)
            } catch let error as NSError {
                emitter(.error(error))
            }
            return Disposables.create()
        }
    }
    
    func updateMemos(memos: Array<MemoEntity>) -> Completable {
        return Completable.create { [weak self] emitter in
            do {
                for memo in memos {
                    let sql = "UPDATE memo SET position = ? WHERE id = ?"
                    try self?.fmdb.executeUpdate(sql, values: [memo.position, memo.id])
                }
                emitter(.completed)
            } catch let error as NSError {
                emitter(.error(error))
            }
            return Disposables.create()
        }
    }
    
    
    func getMemoById(id: Int) -> Single<MemoEntity> {
        return Single.create { [weak self] emitter in
            do {
                let sql = "SELECT * FROM memo WHERE id = ? LIMIT 1"
                let resultSet = try self?.fmdb.executeQuery(sql, values: [id])
                resultSet?.next()
                let id = Int(resultSet!.int(forColumn: "id"))
                let title = resultSet!.string(forColumn: "title")!
                let content = resultSet!.string(forColumn: "content")!
                let position = Int(resultSet!.int(forColumn: "position"))
                let memoEntity = MemoEntity(id: id, title: title, content: content, position: position)
                emitter(.success(memoEntity))
            } catch let error as NSError {
                emitter(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    func updateMemo(id: Int, title: String, content: String) -> Completable {
        return Completable.create { [weak self] emitter in
            do {
                let sql = "UPDATE memo set title = ?, content = ? WHERE id = ?"
                try self?.fmdb.executeUpdate(sql, values: [title, content, id])
                emitter(.completed)
            } catch let error as NSError {
                emitter(.error(error))
            }
            return Disposables.create()
        }
    }
}
