import UIKit

class ViewController: UIViewController {
    
    
    var loginScreen:LoginScreen?
    
    override func loadView() {
        self.loginScreen = LoginScreen()
        self.view = self.loginScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginScreen?.delegate(delegate: self)
        self.loginScreen?.configTextFieldDelegate(delegate: self)
        
        self.view.backgroundColor = .black
        overrideUserInterfaceStyle = .dark
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    


}

extension ViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    
}

extension ViewController:LoginScreenProtocol {
    func actionLoginButton() {
        let Storyboard  = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = Storyboard.instantiateViewController(withIdentifier: "NV")
        vc.modalPresentationStyle = .fullScreen
        show(vc, sender: nil)

        print("Login Button Tapped")
    }
    
    
}

