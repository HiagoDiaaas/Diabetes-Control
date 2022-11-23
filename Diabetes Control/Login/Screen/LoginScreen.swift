import UIKit


protocol LoginScreenProtocol:AnyObject{
    func actionLoginButton()
    
}

class LoginScreen: UIView {
    
    weak var delegate:LoginScreenProtocol?
    
    func delegate(delegate: LoginScreenProtocol?) {
        self.delegate = delegate
    }
    
    lazy var loginLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.text = "Diabetes Control"
        return label
    }()
    
    lazy var logoAppImageView:UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "cross.circle.fill")
        image.tintColor = .white
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var emailTextField:UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.keyboardType = .emailAddress
        textField.textColor = .black
        
        
        return textField
    }()
    
    lazy var passwordTextField:UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.autocorrectionType = .no
        passwordTextField.backgroundColor = .white
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.keyboardType = .default
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textColor = .black
        
        
        return passwordTextField
    }()
    
    lazy var loginButton:UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log in", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.black, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 7.5
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(self.loginButtonTapped), for: .touchUpInside)
        
        
        
        return button
    }()
    
    
    lazy var emailLabel:UILabel = {
        let emailLabel = UILabel()
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.textColor = .white
        emailLabel.text = "Enter Email Address"
        emailLabel.font = UIFont.systemFont(ofSize: 20)
        
        
        return emailLabel
    }()
    
    lazy var passwordLabel:UILabel = {
        let passwordLabel = UILabel()
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.textColor = .white
        passwordLabel.text = "Enter Password"
        passwordLabel.font = UIFont.systemFont(ofSize: 20)
        
        
        return passwordLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configSuperView()
        self.setUpConstraints()
        
    }
    
    private func configSuperView() {
        self.addSubview(self.loginLabel)
        self.addSubview(self.logoAppImageView)
        self.addSubview(self.emailLabel)
        self.addSubview(self.emailTextField)
        self.addSubview(self.passwordLabel)
        self.addSubview(self.passwordTextField)
        self.addSubview(self.loginButton)
        
    }
    
    public func configTextFieldDelegate(delegate: UITextFieldDelegate) {
        self.emailTextField.delegate = delegate
        self.passwordTextField.delegate = delegate
    }
    
    @objc private func loginButtonTapped() {
        self.delegate?.actionLoginButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            
            self.loginLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                                constant: 20),
            self.loginLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            
            self.logoAppImageView.topAnchor.constraint(equalTo: self.loginLabel.bottomAnchor,
                                                       constant: 20),
            self.logoAppImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                           constant: 60),
            self.logoAppImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                           constant: -60),
            self.logoAppImageView.heightAnchor.constraint(equalToConstant: 200),
            
            
            self.emailLabel.topAnchor.constraint(equalTo: self.logoAppImageView.bottomAnchor,
                                                     constant: 20),
            self.emailLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                         constant: 20),
            self.emailLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                         constant: -20),
            self.emailLabel.heightAnchor.constraint(equalToConstant: 45),
            
            
            self.emailTextField.topAnchor.constraint(equalTo: self.emailLabel.bottomAnchor),
            self.emailTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                         constant: 20),
            self.emailTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                         constant: -20),
            self.emailTextField.heightAnchor.constraint(equalToConstant: 45),
            
            
            self.passwordLabel.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor,
                                                     constant: 15),
            self.passwordLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                                         constant: 20),
            self.passwordLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                         constant: -20),
            self.passwordLabel.heightAnchor.constraint(equalToConstant: 45),
            
            
            self.passwordTextField.topAnchor.constraint(equalTo: self.passwordLabel.bottomAnchor),
            self.passwordTextField.leadingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor),
            self.passwordTextField.trailingAnchor.constraint(equalTo: self.emailTextField.trailingAnchor),
            self.passwordTextField.heightAnchor.constraint(equalTo: self.emailTextField.heightAnchor),
            
            
            self.loginButton.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor,
                                                        constant: 15),
            self.loginButton.leadingAnchor.constraint(equalTo: self.emailTextField.leadingAnchor),
            self.loginButton.trailingAnchor.constraint(equalTo: self.emailTextField.trailingAnchor),
            self.loginButton.heightAnchor.constraint(equalTo: self.emailTextField.heightAnchor)
            
            
            
            
            
            
        ])
    }

 

}
