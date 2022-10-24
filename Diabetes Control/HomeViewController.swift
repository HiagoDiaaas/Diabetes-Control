import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomCOnstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingCOnstraint: NSLayoutConstraint!
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var bloodSugarButton: UIButton!
    
    var arrayData = [EventItem]()
    
    //var arrayData: [Model] = []
    var isBottomSheetShown = false

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        
        customTableView()
        navigationController?.navigationBar.barStyle = .black
        
//        let data: [Model] = [Model(iconImage: UIImage(systemName: "syringe.fill")!, title: "20", dateAndTime: "Today", type: "Long"),        Model(iconImage: UIImage(systemName: "syringe.fill")!, title: "43", dateAndTime: "15/10/2022 20:30", type: "Long"),
//                             Model(iconImage: UIImage(systemName: "syringe.fill")!, title: "80", dateAndTime: "Monday", type: "Fast")]
//        arrayData = data
        //        if let myArray = NSKeyedUnarchiver.unarchivedObject(ofClass: <#T##NSCoding.Protocol#>, from: <#T##Data#>)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: @IBActions
    @IBAction func bloodSugarButtonTapped(_ sender: Any) {
        self.heightConstraint.constant = 0
        self.isBottomSheetShown = false
       
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.delegate = self
        vc.title = "Blood Sugar"
        vc.eventType = "Moment"
        vc.eventValue = "Value in mg/dL"
        vc.pickerViewOptions = ["Before Meal", "After Meal"]
        vc.sfSymbolIdentifier = "drop.fill"
        vc.image = UIImage(systemName: vc.sfSymbolIdentifier)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func insulinButtonTapped(_ sender: Any) {
        self.heightConstraint.constant = 0
        self.isBottomSheetShown = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.delegate = self
        vc.title = "Insulin"
        vc.eventType = "Type"
        vc.eventValue = "Value in U"
        vc.pickerViewOptions = ["Short-acting", "Long-acting", "Mix", "NPH"]
        vc.sfSymbolIdentifier = "syringe.fill"
        vc.image = UIImage(systemName: vc.sfSymbolIdentifier)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func carbsButtonTapped(_ sender: Any) {
        self.heightConstraint.constant = 0
        self.isBottomSheetShown = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.delegate = self
        vc.title = "Carbs"
        vc.eventValue = "Value in Grams"
        vc.isPickerViewHidden = true
        vc.pickerViewOptions = [""]
        vc.sfSymbolIdentifier = "fork.knife.circle.fill"
        vc.image = UIImage(systemName: vc.sfSymbolIdentifier)
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func exerciseButtonTapped(_ sender: Any) {
        self.heightConstraint.constant = 0
        self.isBottomSheetShown = false
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.delegate = self
        vc.title = "Exercise"
        vc.eventType = "Intensity"
        vc.eventValue = "Duration in Minutes"
        vc.pickerViewOptions = ["Light", "Moderate", "Intense"]
        vc.sfSymbolIdentifier = "figure.run"
        vc.image = UIImage(systemName: vc.sfSymbolIdentifier)
        navigationController?.pushViewController(vc, animated: true)
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
    
    // MARK: Methods
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
              let sfSymbolString = arrayData.reversed()[indexPath.row].sfSymbolIdentifier
              cell.iconImageView.image = UIImage(systemName: sfSymbolString!)
            
            if cell.iconImageView.image == UIImage(systemName: "syringe.fill") {
                cell.valueLabel.text = "\(arrayData.reversed()[indexPath.row].title!)U"
            }
            if cell.iconImageView.image == UIImage(systemName: "drop.fill") {
                cell.valueLabel.text = "\(arrayData.reversed()[indexPath.row].title!)mg/dl"
            }
            if cell.iconImageView.image == UIImage(systemName: "figure.run") {
                cell.valueLabel.text = "\(arrayData.reversed()[indexPath.row].title!)min"
            }
            if cell.iconImageView.image == UIImage(systemName: "fork.knife.circle.fill") {
                cell.valueLabel.text = "\(arrayData.reversed()[indexPath.row].title!)g"

            }
            cell.dateAndTimeLabel.text = arrayData.reversed()[indexPath.row].dateAndTime
            cell.typeLabel.text = arrayData.reversed()[indexPath.row].type

            return cell
        }
            
        return UITableViewCell()
    }
}

extension HomeViewController: UITableViewDelegate {
    
}

extension HomeViewController: DetailViewControllerDelegate {
    func saveData(dateValue: String, value: String, type: String, sfSimbolString: String) {
        //let data: Model = Model(iconImage: imageIcon, title: value, dateAndTime: dateValue, type: type)
        //self.arrayData.append(data)
        createItem(sfSymbolIdentifier: sfSimbolString, title: value, dateAndTime: dateValue, type: type)
        
        // TODO: Save to user defaults / core data
        //        let archiver = NSKeyedArchiver(requiringSecureCoding: true)
        //        if let dataForArray = try? NSKeyedArchiver.archivedData(withRootObject: self.arrayData, requiringSecureCoding: true) {
        //            archiver.encode(dataForArray, forKey: "arrayData")
        //        }
        //        let data = archiver.encodedData


        
        self.homeTableView.reloadData()
    }
    
    // MARK: CORE DATA

    func getAllItems() {
        do {
            arrayData = try context.fetch(EventItem.fetchRequest())
            
            DispatchQueue.main.async {
                self.homeTableView.reloadData()
            }
            
        
        }
        catch {
            
        }
        
        
    }
    
    func createItem(sfSymbolIdentifier: String, title: String, dateAndTime: String, type: String) {
        let newItem = EventItem(context: context)
        newItem.sfSymbolIdentifier = sfSymbolIdentifier
        newItem.title = title
        newItem.dateAndTime = dateAndTime
        newItem.type = type
        do {
            try context.save()
            getAllItems()
        }
        catch {
            
        }
        
    }
    
    func deleteItem(item: EventItem) {
        context.delete(item)
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            
        }
        
    }
    
    func updateItem(item: EventItem, newSfSymbolIdentifier: String, newTitle: String, newDateAndTime: String, newType: String) {
        item.sfSymbolIdentifier = newSfSymbolIdentifier
        item.title = newTitle
        item.dateAndTime = newDateAndTime
        item.type = newType
        
        
        do {
            try context.save()
            getAllItems()
        }
        catch {
            
        }
    }
    
    
    func resetAllRecords(in EventItem : String)
        {

            
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: EventItem)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            do
            {
                try context.execute(deleteRequest)
                try context.save()
            }
            catch
            {
                print ("There was an error")
            }
        }
    
}
