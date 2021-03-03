import UIKit

class ReorderViewController: BaseViewController, StoryboardInstantiable {
    
    static var storyboard: AppStoryboard = .reorder
    var viewModel: ReorderViewModel?
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewDivider: UIView!
    
    var memos = Array<Memo>()
    var deletedMemos = Array<Memo>()
    
    override func viewDidLoad() {
        setupBinding()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        viewModel?.getAllMemos()
    }
    
    func setupBinding() {
        buttonCancel.rx.tap.bind { [weak self] in
            self?.viewModel?.close()
        }.disposed(by: disposeBag)
    }
    
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "MemoCell", bundle: nil), forCellReuseIdentifier: "MemoCell")
        self.tableView.isEditing = true
        
        guard let vm = viewModel else { return }
        vm.memos.subscribe(onNext: { [weak self] memos in
            self?.memos = memos
            self?.tableView.reloadData()
        }, onError: { error in
            
        }, onCompleted: {
            
        }, onDisposed: {
            
        }).disposed(by: disposeBag)
    }
    
    func setupUI() {
        viewDivider.backgroundColor = AppColor.Divider
        buttonCancel.tintColor = AppColor.NavigationBar.itemColor
        buttonCancel.setTitle(NSLocalizedString("ReorderViewController_button_cancel", comment: ""), for: .normal)
        buttonSave.tintColor = AppColor.NavigationBar.itemColor
        buttonSave.setTitle(NSLocalizedString("ReorderViewController_button_save", comment: ""), for: .normal)
    }
    
    @IBAction func onSave(_ sender: Any) {
        guard let vm = viewModel else { return }
        vm.save(memos: memos, deletedMemos: deletedMemos)
    }
}

extension ReorderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as! MemoCell
        cell.labelTitle.text = memos[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let target = memos.remove(at: indexPath.row)
        deletedMemos.append(target)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let targetMemo = self.memos[sourceIndexPath.row]
        self.memos.remove(at: sourceIndexPath.row)
        self.memos.insert(targetMemo, at: destinationIndexPath.row)
    }
}

