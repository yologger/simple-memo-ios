import UIKit

class EditViewController: BaseViewController, StoryboardInstantiable {
    
    static var storyboard: AppStoryboard = .edit
    var viewModel: EditViewModel?
    
    var memoId: Int?
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textViewContent: UITextView!
    @IBOutlet weak var viewDividerTop: UIView!
    @IBOutlet weak var viewDividerBottom: UIView!
    @IBOutlet weak var constraintForKeyboard: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        setupBinding()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let id = memoId, let vm = viewModel {
            vm.getMemoById(id: id)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupUI() {
        viewDividerTop.backgroundColor = AppColor.Divider
        viewDividerBottom.backgroundColor = AppColor.Divider
        buttonCancel.tintColor = AppColor.NavigationBar.itemColor
        buttonCancel.setTitle(NSLocalizedString("EditViewController_button_cancel", comment: ""), for: .normal)
        buttonSave.setTitle(NSLocalizedString("EditViewController_button_save", comment: ""), for: .normal)
        buttonSave.tintColor = AppColor.NavigationBar.itemColor
        textViewContent.placeholder = NSLocalizedString("EditViewController_placeholder_content", comment: "")
        textViewContent.placeholderColor = AppColor.Grey.Default
        textFieldTitle.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("EditViewController_placeholder_title", comment: ""), attributes: [NSAttributedString.Key.foregroundColor : AppColor.Grey.Default])
    }
    
    private func setupBinding() {
        
        guard let vm = viewModel else { return }
        // guard let id = memoId else { return }
        
        buttonCancel.rx.tap.bind { [weak self] in
            self?.viewModel?.close()
        }.disposed(by: disposeBag)
        
        vm.title
            .subscribe(onNext: { [weak self] title in
                self?.textFieldTitle.text = title
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
        
    }
    
    @IBAction func save(_ sender: Any) {
        guard
            let vm = viewModel,
            let title = textFieldTitle.text,
            let content = textViewContent.text,
            let id = memoId
        else { return }
        
        if (title == "" && content == "") {
            vm.close()
            return
        } else {
            vm.update(id: id, title: title, content: content)
            return
        }
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification){
        let notiInfo = notification.userInfo!
        let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let keyboardHeight = keyboardFrame.height - self.view.safeAreaInsets.bottom
        let keyboardAnimationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        UIView.animate(withDuration: keyboardAnimationDuration) {
            // self.inputViewBottomMargin.constant = height
            self.constraintForKeyboard.constant = keyboardHeight
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification){
        let notiInfo = notification.userInfo!
        let keyboardAnimationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        UIView.animate(withDuration: keyboardAnimationDuration) {
            self.constraintForKeyboard.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
