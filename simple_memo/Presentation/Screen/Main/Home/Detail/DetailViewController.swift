import UIKit
import RxSwift
import RxCocoa
import Toast_Swift

class DetailViewController: BaseViewController, StoryboardInstantiable {
    
    static var storyboard: AppStoryboard = .detail
    var viewModel: DetailViewModel?
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var textViewContent: UITextView!
    @IBOutlet weak var viewDividerFirst: UIView!
    @IBOutlet weak var viewDividerSecond: UIView!
    
    var memoId: Int?
    
    override func viewDidLoad() {
        setupUI()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let id = memoId, let vm = viewModel {
            vm.getMemoById(id: id)
        }
    }
    
    private func setupUI() {
        
        textViewContent.isEditable = false
        textViewContent.isSelectable = false
        
        let singleTapGestureForContent = UITapGestureRecognizer(target: self, action: #selector(didContentSingleTap))
        singleTapGestureForContent.numberOfTapsRequired = 1
        textViewContent.addGestureRecognizer(singleTapGestureForContent)
        
        let doubleTapGestureForContent = UITapGestureRecognizer(target: self, action: #selector(didContentDoubleTap))
        doubleTapGestureForContent.numberOfTapsRequired = 2
        textViewContent.addGestureRecognizer(doubleTapGestureForContent)
        
        singleTapGestureForContent.require(toFail: doubleTapGestureForContent)
        
        labelTitle.isUserInteractionEnabled = true
        
        let singleTapGestureForTitle = UITapGestureRecognizer(target: self, action: #selector(didTitleSingleTap))
        singleTapGestureForTitle.numberOfTapsRequired = 1
        labelTitle.addGestureRecognizer(singleTapGestureForTitle)
        
        let doubleTapGestureForTitle = UITapGestureRecognizer(target: self, action: #selector(didTitleDoubleTap))
        doubleTapGestureForTitle.numberOfTapsRequired = 2
        labelTitle.addGestureRecognizer(doubleTapGestureForTitle)
        
        singleTapGestureForContent.require(toFail: doubleTapGestureForContent)
        
        viewDividerFirst.backgroundColor = AppColor.Divider
        viewDividerSecond.backgroundColor = AppColor.Divider
        
        buttonClose.tintColor = AppColor.NavigationBar.itemColor
        buttonClose.setTitle(NSLocalizedString("DetailViewController_button_close", comment: ""), for: .normal)
        buttonDelete.tintColor = AppColor.NavigationBar.itemColor
        buttonDelete.setTitle(NSLocalizedString("DetailViewController_button_delete", comment: ""), for: .normal)
        buttonEdit.tintColor = AppColor.NavigationBar.itemColor
        buttonEdit.setTitle(NSLocalizedString("DetailViewController_button_edit", comment: ""), for: .normal)
    }
    
    private func setupBinding() {
        
        guard let vm = viewModel else { return }
        guard let id = memoId else { return }
        
        buttonClose.rx.tap.bind { [weak self] in
            self?.viewModel?.close()
        }.disposed(by: disposeBag)
        
        buttonEdit.rx.tap.bind { [weak self] in
            self?.viewModel?.openEdit(memoId: id)
        }.disposed(by: disposeBag)
    
        textViewContent.rx.text.orEmpty
            .bind(to: vm.content)
            .disposed(by: disposeBag)
        
        vm.title
            .subscribe(onNext: { [weak self] title in
                self?.labelTitle.text = title
            }, onError: { error in
                
            }, onCompleted: {
                
            }, onDisposed: {
                
            }).disposed(by: disposeBag)
        
        vm.content
            .subscribe(onNext: { [weak self] content in
                self?.textViewContent.text = content
            }, onError: { error in
                
            }, onCompleted: {
                
            }, onDisposed: {
                
            }).disposed(by: disposeBag)
        
        vm.event
            .subscribe(onNext: { event in
                switch(event) {
                case .DELETE_SUCCESS: self.view.makeToast("DELETED SUCCESSFULLY", duration: 1.0, position: .center)
                case .DELETE_FAILURE: self.view.makeToast("UNKNOWN ERROR", duration: 1.0, position: .center)
                default : break
                }
            }, onError: { error in
                
            }, onCompleted: {
                
            }, onDisposed: {
                
            }).disposed(by: disposeBag)
    }
    
    @objc func didContentSingleTap() {
        var style = ToastStyle()
        style.backgroundColor = AppColor.Grey.Dark
        self.view.makeToast(NSLocalizedString("DetailViewController_message_tap", comment: ""), duration: 1.0, position: .center, style: style)
    }
    
    @objc func didContentDoubleTap() {
        self.view.hideAllToasts()
        guard let vm = viewModel else { return }
        guard let id = memoId else { return }
        vm.openEdit(memoId: id)
    }
    
    
    @objc func didTitleSingleTap() {
        var style = ToastStyle()
        style.backgroundColor = AppColor.Grey.Dark
        self.view.makeToast(NSLocalizedString("DetailViewController_message_tap", comment: ""), duration: 1.0, position: .center, style: style)
    }
    
    @objc func didTitleDoubleTap() {
        self.view.hideAllToasts()
        guard let vm = viewModel else { return }
        guard let id = memoId else { return }
        vm.openEdit(memoId: id)
    }
    
    @IBAction func deleteMemo(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: NSLocalizedString("DetailViewController_message_delete", comment: ""), preferredStyle: .alert)
        let successAction = UIAlertAction(title: NSLocalizedString("DetailViewController_button_ok", comment: ""), style: .default) { [weak self] (action) in
            if let id = self?.memoId {
                self?.viewModel?.deleteMemoById(id: id)
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("DetailViewController_button_cancel", comment: ""), style: .cancel) { (action) in
            
        }
        
        alert.addAction(successAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
