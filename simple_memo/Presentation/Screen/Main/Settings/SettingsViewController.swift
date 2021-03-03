import UIKit

class SettingsViewController: UIViewController, StoryboardInstantiable {
    
    static var storyboard: AppStoryboard = .settings
    
    @IBOutlet weak var labelToggleTheme: UILabel!
    @IBOutlet weak var switchToggleTheme: UISwitch!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var labelFeatureTop: UILabel!
    @IBOutlet weak var labelFeatureBottom: UILabel!
    
    override func viewDidLoad() {
        setupSwitchToggleTheme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    private func setupUI() {
        labelToggleTheme.text = NSLocalizedString("SettingsViewController_labelToggleTheme", comment: "")
        labelFeatureTop.text = NSLocalizedString("SettingsViewController_labelFeatureTop", comment: "")
        labelFeatureBottom.text = NSLocalizedString("SettingsViewController_labelFeatureBottom", comment: "")
    }
    
    private func setupSwitchToggleTheme() {
        switchToggleTheme.isOn = ThemeManager.isDarkTheme
        switchToggleTheme.addTarget(self, action: #selector(switchChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func switchChanged(switchToggleTheme: UISwitch) {
        if switchToggleTheme.isOn {
            ThemeManager.applyDarkTheme()
        } else {
            ThemeManager.applyLightTheme()
        }
    }
    
    @IBAction func applyDarkTheme(_ sender: Any) {
        ThemeManager.applyDarkTheme()
    }
    
    @IBAction func applyLightTheme(_ sender: Any) {
        ThemeManager.applyLightTheme()
    }
    
    @IBAction func logOut(_ sender: Any) {
        let appCoordinator = (UIApplication.shared.delegate as? AppDelegate)?.appCoordinator
        appCoordinator?.showAuthentification()
    }
}
