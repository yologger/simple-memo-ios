import UIKit
import JJFloatingActionButton
import SnapKit
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController, StoryboardInstantiable {
    
    static var storyboard: AppStoryboard = .home
    var viewModel: HomeViewModel?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFAB()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel?.getAllMemos()
    }
    
    private func setupFAB() {
        let fab = JJFloatingActionButton()
        fab.buttonImageColor = AppColor.OnPrimary
        fab.buttonColor = AppColor.Primary
        fab.configureDefaultItem { item in
            item.buttonImageColor = AppColor.OnPrimary
            item.buttonColor = AppColor.Primary
        }
        fab.addItem(title: NSLocalizedString("HomeViewController_fab_create", comment: ""), image: UIImage(named: "Icon_create_filled")?.withRenderingMode(.alwaysTemplate)) { [weak self] item in
            guard let vm = self?.viewModel else { return }
            vm.showCreate()
        }
        fab.addItem(title: NSLocalizedString("HomeViewController_fab_edit", comment: ""), image: UIImage(named: "Icon_reorder_filled")?.withRenderingMode(.alwaysTemplate)) { [weak self] item in
            guard let vm = self?.viewModel else { return }
            vm.showReorder()
        }
        view.addSubview(fab)
        
        fab.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            make.right.equalTo(self.view.safeAreaLayoutGuide.snp.right).offset(-24)
        }
    }
    
    func setupTableView() {
        guard let vm = viewModel else { return }
        
        self.tableView.register(UINib(nibName: "MemoCell", bundle: nil), forCellReuseIdentifier: "MemoCell")

        vm.memos.bind(to: tableView.rx.items(cellIdentifier: "MemoCell", cellType: MemoCell.self)) { row, memo, cell in
            cell.labelTitle.text = memo.title
        }.disposed(by: self.disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                if let targetId = self?.viewModel?._memos[indexPath.row].id {
                    self?.viewModel?.showDetail(memoId: targetId)
                }
            }, onError: { error in
                
            }, onCompleted: {
                
            }, onDisposed: {
                
            }).disposed(by: disposeBag)
    }
    
    @IBAction func showCreate(_ sender: Any) {
        let createViewController = CreateViewController.instantiate()
        createViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(createViewController, animated: true)
    }
}
