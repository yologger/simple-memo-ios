import UIKit

class LogInViewController: UIViewController, StoryboardInstantiable {
    
    static var storyboard: AppStoryboard = .logIn
    
    @IBAction func logIn(_ sender: Any) {
        let appCoordinator = (UIApplication.shared.delegate as? AppDelegate)?.appCoordinator
        appCoordinator?.showMain()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("LogInViewController: viewDidDisappear()")
    }
    
    deinit {
        print("LogInViewController: deinit {}")
    }
}
