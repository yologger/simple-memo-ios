import UIKit
import UITextView_Placeholder

class CreateViewController: BaseViewController, StoryboardInstantiable {
    
    static var storyboard: AppStoryboard = .create
    var viewModel: CreateViewModel?
    
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textViewContent: UITextView!
    @IBOutlet weak var viewForKeyboard: UIView!
    @IBOutlet weak var viewDividerFirst: UIView!
    @IBOutlet weak var viewDividerSecond: UIView!
    @IBOutlet weak var constraintForKeyboard: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupBinding() {
        guard let vm = viewModel else { return }
        
        buttonCancel.rx.tap.bind { [weak self] in
            self?.viewModel?.close()
        }.disposed(by: self.disposeBag)
        
        textFieldTitle.rx.text.orEmpty
            .bind(to: vm.title)
            .disposed(by: disposeBag)
        
        textViewContent.rx.text.orEmpty
            .bind(to: vm.content)
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        viewDividerFirst.backgroundColor = AppColor.Divider
        viewDividerSecond.backgroundColor = AppColor.Divider
        buttonSave.tintColor = AppColor.NavigationBar.itemColor
        buttonSave.setTitle(NSLocalizedString("CreateViewController_button_save", comment: ""), for: .normal)
        buttonCancel.tintColor = AppColor.NavigationBar.itemColor
        buttonCancel.setTitle(NSLocalizedString("CreateViewController_button_cancel", comment: ""), for: .normal)
        textViewContent.placeholder = NSLocalizedString("CreateViewController_placeholder_content", comment: "")
        textViewContent.placeholderColor = AppColor.Grey.Default
        textFieldTitle.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("CreateViewController_placeholder_title", comment: ""), attributes: [NSAttributedString.Key.foregroundColor : AppColor.Grey.Default])
        
    
    }
    
    @IBAction func save(_ sender: Any) {
        guard let vm = viewModel, let title = textFieldTitle.text, let content = textViewContent.text else { return }
        
        let trimmedTitle = title.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
        let trimmedContent = content.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
        
        if (trimmedTitle == "" && trimmedContent == "") {
            vm.close()
        } else {
            vm.save(title: trimmedTitle, content: trimmedContent)
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
