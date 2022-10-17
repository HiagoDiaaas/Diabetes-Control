import UIKit

class HomeViewController: UIViewController {
    
    var isBottomSheetShown = false
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomCOnstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingCOnstraint: NSLayoutConstraint!
    
    
    
    
    @IBOutlet weak var homeTableView: UITableView!
    var arrayData: [Model] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customTableView()
        navigationController?.navigationBar.barStyle = .black
        let data: [Model] = [Model(title: "20", dateAndTime: "Today", type: "Long"),
                             Model(title: "43", dateAndTime: "15/10/2022 20:30", type: "Long"),
                             Model(title: "80", dateAndTime: "Monday", type: "Fast"),
                             Model(title: "80", dateAndTime: "Monday", type: "Fast"),
                             Model(title: "80", dateAndTime: "Monday", type: "Fast"),
                             Model(title: "80", dateAndTime: "Monday", type: "Fast"),
                             Model(title: "80", dateAndTime: "Monday", type: "Fast"),
                             Model(title: "80", dateAndTime: "Monday", type: "Fast"),
                             Model(title: "80", dateAndTime: "Monday", type: "Fast"),
                             Model(title: "80", dateAndTime: "Monday", type: "Fast"),
                             Model(title: "80", dateAndTime: "Wednesdat", type: "Long")]
        arrayData = data
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    @IBAction func openEventMenu(_ sender: Any) {
        if (isBottomSheetShown) {
            UIView.animate(withDuration: 0.3, animations: {
                self.heightConstraint.constant = 0
                self.view.layoutIfNeeded()
            }) {(status) in
                self.isBottomSheetShown = false
                //completion code
            }
        } else {
            UIView.animate(withDuration: 0.1, animations: {
                self.heightConstraint.constant = 400
                self.view.layoutIfNeeded()
            }) {(status) in
                self.isBottomSheetShown = true
                //completion code
            }
        }
        
        
        
    }
    
    
    
    private func customTableView() {
        homeTableView.dataSource = self
        homeTableView.delegate = self
        let textFieldCell = UINib(nibName: "CustomTableViewCell",
                                      bundle: nil)
        self.homeTableView.register(textFieldCell,
                                    forCellReuseIdentifier: "CustomTableViewCell")
        
    }
    
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        return arrayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell {
            cell.valueLabel.text = arrayData[indexPath.row].title
            cell.dateAndTimeLabel.text = arrayData[indexPath.row].dateAndTime
            cell.typeLabel.text = arrayData[indexPath.row].type
//            if indexPath.row == 3 {
//                cell.valueLabel?.isHidden = true
//
//            }
            return cell
        }
        
            
        return UITableViewCell()
    }
    
    
}

extension HomeViewController: UITableViewDelegate {
    
}
