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
    var eventService = EventService()
    var event = Event()
    var events: [Event] = []
    var isFromCoreData = false
    var isSynced = true

    
    var isBottomSheetShown = false

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllItems()
        //resetAllRecords(in: "EventItem")
        getAllEvents()
        customTableView()
        navigationController?.navigationBar.barStyle = .black
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: @IBActions
    
    
    @IBAction func shareAction(_ sender: Any) {
        print("Start exporting...")
        
        let file_name = "diabetes_data.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(file_name)
        
        var csvHead = "Event Type, Value, Unit, Additional Value, Date and Time\n"
        
        var number = 0
        
        for event in arrayData.reversed() {
            number += 1
            
            if event.sfSymbolIdentifier == "drop.fill" {
                csvHead.append("Blood Sugar, \(event.title!), mg/dl, \(event.type!), \(event.dateAndTime!)\n")
            }
            
            if event.sfSymbolIdentifier == "syringe.fill" {
                csvHead.append("Insulin, \(event.title!), U, \(event.type!), \(event.dateAndTime!)\n")
            }
            
            if event.sfSymbolIdentifier == "fork.knife.circle.fill" {
                csvHead.append("Carbs, \(event.title!), grams, none, \(event.dateAndTime!)\n")
            }
            
            if event.sfSymbolIdentifier == "figure.run" {
                csvHead.append("Exercise, \(event.title!), minutes, \(event.type!), \(event.dateAndTime!)\n")
            }
            
        
            
        }
        
        do {
            
            try csvHead.write(to: path!, atomically: true, encoding: .utf8)
            let exportSheet = UIActivityViewController(activityItems: [path as Any], applicationActivities: nil)
            self.present(exportSheet, animated: true, completion: nil)
            print("Exported")
            
        } catch {
            print("Error")
        }
        
    }
    
    
    
    
    
    
    
    @IBAction func bloodSugarButtonTapped(_ sender: Any) {
        self.heightConstraint.constant = 0
        self.isBottomSheetShown = false
       
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.delegate = self
        vc.title = "Blood Sugar"
        vc.eventTypeText = "Moment"
        vc.isFromTableView = false
        vc.eventValueText = "Value in mg/dL"
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
        vc.eventTypeText = "Type"
        vc.isFromTableView = false
        vc.eventValueText = "Value in U"
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
        vc.isCarbs = true
        vc.eventValueText = "Value in Grams"
        vc.isFromTableView = false
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
        vc.eventTypeText = "Intensity"
        vc.isFromTableView = false
        vc.eventValueText = "Duration in Minutes"
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
                
            }
        } else {
            UIView.animate(withDuration: 0.1, animations: {
                self.heightConstraint.constant = 400
                self.view.layoutIfNeeded()
            }) {(status) in
                self.isBottomSheetShown = true
               
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

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if isFromCoreData {
            let item = arrayData.reversed()[indexPath.row]
            
        
            if editingStyle == .delete {

                self.deleteItem(item: item)
               

            }
            
        } else {
            if arrayData.reversed()[indexPath.row].title == events.reversed()[indexPath.row].value {
                let item = arrayData.reversed()[indexPath.row]
                let eventId = self.events.reversed()[indexPath.row].id
            
                if editingStyle == .delete {

                    self.deleteItem(item: item)
                    self.deleteEvent(id: eventId ?? 0)

                }
                
            } else {print ("Error")}
            
            
            
        }
        
        
        

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        homeTableView.deselectRow(at: indexPath, animated: true)
        
        if isFromCoreData {
            
            let item = self.arrayData.reversed()[indexPath.row]
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            vc.valueTextFieldText = self.arrayData.reversed()[indexPath.row].title
            vc.dateString = self.arrayData.reversed()[indexPath.row].dateAndTime
            vc.pickerOptionChoosed = self.arrayData.reversed()[indexPath.row].type
            let sfSymbolString = self.arrayData.reversed()[indexPath.row].sfSymbolIdentifier
            vc.image = UIImage(systemName: sfSymbolString!)
         
            
            if self.arrayData.reversed()[indexPath.row].type == "Before Meal" ||
                self.arrayData.reversed()[indexPath.row].type == "After Meal"
            {
                vc.pickerViewOptions = ["Before Meal", "After Meal"]
                vc.eventValueText = "Value in mg/dL"
                vc.title = "Blood Sugar"
                vc.eventTypeText = "Moment"
                vc.sfSymbolIdentifier = "drop.fill"
                
            }
            
            if self.arrayData.reversed()[indexPath.row].type == "Short-acting" ||
                self.arrayData.reversed()[indexPath.row].type == "Long-acting" ||
                self.arrayData.reversed()[indexPath.row].type == "Mix" ||
                self.arrayData.reversed()[indexPath.row].type == "NPH"
            {
                vc.pickerViewOptions = ["Short-acting", "Long-acting", "Mix", "NPH"]
                vc.eventValueText = "Value in U"
                vc.title = "Insulin"
                vc.eventTypeText = "Type"
                vc.sfSymbolIdentifier = "syringe.fill"
                
            }
            
            if self.arrayData.reversed()[indexPath.row].type == "Light" ||
                self.arrayData.reversed()[indexPath.row].type == "Moderate" ||
                self.arrayData.reversed()[indexPath.row].type == "Intense"
            {
                vc.pickerViewOptions = ["Light", "Moderate", "Intense"]
                vc.eventValueText = "Duration in Minutes"
                vc.title = "Exercise"
                vc.eventTypeText = "Intensity"
                vc.sfSymbolIdentifier = "figure.run"
            }
            
            if self.arrayData.reversed()[indexPath.row].sfSymbolIdentifier == "fork.knife.circle.fill"
            {
                vc.isPickerViewHidden = true
                vc.eventValueText = "Value in Grams"
                vc.title = "Carbs"
                vc.isCarbs = true
                vc.sfSymbolIdentifier = "fork.knife.circle.fill"
            }
            
            vc.delegate = self
            vc.indexPath = item
            vc.isFromTableView = true
            navigationController?.pushViewController(vc, animated: true)
            
        } else {
            let eventId = self.events.reversed()[indexPath.row].id
            
            let item = self.arrayData.reversed()[indexPath.row]
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            vc.valueTextFieldText = self.events.reversed()[indexPath.row].value
            vc.dateString = self.events.reversed()[indexPath.row].dateAndTime
            vc.pickerOptionChoosed = self.events.reversed()[indexPath.row].type
            let sfSymbolString = self.events.reversed()[indexPath.row].sfSymbolIdentifier
            vc.image = UIImage(systemName: sfSymbolString!)
         
            
            if self.events.reversed()[indexPath.row].type == "Before Meal" ||
                self.events.reversed()[indexPath.row].type == "After Meal"
            {
                vc.pickerViewOptions = ["Before Meal", "After Meal"]
                vc.eventValueText = "Value in mg/dL"
                vc.title = "Blood Sugar"
                vc.eventTypeText = "Moment"
                vc.sfSymbolIdentifier = "drop.fill"
                
            }
            
            if self.events.reversed()[indexPath.row].type == "Short-acting" ||
                self.events.reversed()[indexPath.row].type == "Long-acting" ||
                self.events.reversed()[indexPath.row].type == "Mix" ||
                self.events.reversed()[indexPath.row].type == "NPH"
            {
                vc.pickerViewOptions = ["Short-acting", "Long-acting", "Mix", "NPH"]
                vc.eventValueText = "Value in U"
                vc.title = "Insulin"
                vc.eventTypeText = "Type"
                vc.sfSymbolIdentifier = "syringe.fill"
                
            }
            
            if self.events.reversed()[indexPath.row].type == "Light" ||
                self.events.reversed()[indexPath.row].type == "Moderate" ||
                self.events.reversed()[indexPath.row].type == "Intense"
            {
                vc.pickerViewOptions = ["Light", "Moderate", "Intense"]
                vc.eventValueText = "Duration in Minutes"
                vc.title = "Exercise"
                vc.eventTypeText = "Intensity"
                vc.sfSymbolIdentifier = "figure.run"
            }
            
            if self.events.reversed()[indexPath.row].sfSymbolIdentifier == "fork.knife.circle.fill"
            {
                vc.isPickerViewHidden = true
                vc.eventValueText = "Value in Grams"
                vc.title = "Carbs"
                vc.isCarbs = true
                vc.sfSymbolIdentifier = "fork.knife.circle.fill"
            }
            
            vc.delegate = self
            vc.indexPath = item
            vc.isFromTableView = true
            vc.eventId = eventId
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 1
        }
        if isFromCoreData {
            return arrayData.count
        } else {
            return events.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell {
            if isFromCoreData {
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
            } else {
                
                let sfSymbolString = events.reversed()[indexPath.row].sfSymbolIdentifier
                cell.iconImageView.image = UIImage(systemName: sfSymbolString!)
                
                if cell.iconImageView.image == UIImage(systemName: "syringe.fill") {
                    cell.valueLabel.text = "\(events.reversed()[indexPath.row].value!)U"
                }
                if cell.iconImageView.image == UIImage(systemName: "drop.fill") {
                    cell.valueLabel.text = "\(events.reversed()[indexPath.row].value!)mg/dl"
                }
                if cell.iconImageView.image == UIImage(systemName: "figure.run") {
                    cell.valueLabel.text = "\(events.reversed()[indexPath.row].value!)min"
                }
                if cell.iconImageView.image == UIImage(systemName: "fork.knife.circle.fill") {
                    cell.valueLabel.text = "\(events.reversed()[indexPath.row].value!)g"

                }
                cell.dateAndTimeLabel.text = events.reversed()[indexPath.row].dateAndTime
                cell.typeLabel.text = events.reversed()[indexPath.row].type

                return cell
            }
        }
            
        return UITableViewCell()
    }
}

extension HomeViewController: DetailViewControllerDelegate {
    func saveData(dateValue: String,
                  value: String,
                  type: String,
                  sfSimbolString: String) {
        self.createItem(sfSymbolIdentifier: sfSimbolString, title: value, dateAndTime: dateValue, type: type)
        
        event.id = nil
        event.sfSymbolIdentifier = sfSimbolString
        event.value = value
        event.dateAndTime = dateValue
        event.type = type
        self.createEvent()
        self.createEvents()
        
        self.homeTableView.reloadData()
    }
    
    func updateData(item: EventItem,
                    newSfSymbolIdentifier: String,
                    newTitle: String,
                    newDateAndTime: String,
                    newType: String,
                    id: Int
                    ) {
        self.updateItem(item: item,
                   newSfSymbolIdentifier: newSfSymbolIdentifier,
                   newTitle: newTitle,
                   newDateAndTime: newDateAndTime,
                   newType: newType
            
        )
        
        event.id = id
        event.sfSymbolIdentifier = newSfSymbolIdentifier
        event.value = newTitle
        event.dateAndTime = newDateAndTime
        event.type = newType
        
        self.updateEvent()
        
        self.homeTableView.reloadData()
    }
    
    // MARK: CRUD API FUNCTIONS
    
    
    func getAllEvents() {
        eventService.getAllEvents() { (res) in
            switch res {
            case .success(let events):
                if self.isSynced {
                    //self.deleteAllEvents()
                    self.eventService.deleteAllEvents(){ (res) in
                            switch res {
                            case .success(_):
                                print("sucesso delete events")
                                self.eventService.createEvents(event: events){ (res) in
                                        switch res {
                                        case .success(_):
                                            self.events = events
                                            print("sucesso create events")
                                            self.eventService.getAllEvents() { (res) in
                                                switch res {
                                                case .success(let events):
                                                    self.events = events
                                                    self.homeTableView.reloadData()
                                                    self.isFromCoreData = false
                                                    self.isSynced = false
                                                case .failure(_):
                                                    self.isFromCoreData = true
                                                    self.getAllItems()
                                                    
                                                    
                                                }
                                            }
                                            
                                        case .failure(_):
                                            print("error create events")
                                        }
                                    }
                                print("success")
                            case .failure(_):
                                print("error delete all events")
                            }
                        }
                    
                    
                    //self.createEvents()
                    
                    
                } else {
                    self.eventService.getAllEvents() { (res) in
                        switch res {
                        case .success(let events):
                            self.events = events
                            self.homeTableView.reloadData()
                        case .failure(_):
                            self.isFromCoreData = true
                            self.getAllItems()
                            
                        }
                    }
                    
                }
                
            case .failure(_):
                self.isFromCoreData = true
                self.getAllItems()
                
            }
        }
        
        
    }
    
    
//    func getAllEvents() {
//        eventService.getAllEvents() { (res) in
//            switch res {
//            case .success(let events):
//                self.events = events
//                self.homeTableView.reloadData()
//            case .failure(_):
//                self.isFromCoreData = true
//                self.getAllItems()
//
//            }
//        }
//    }
    
    
    @objc func createEvent() {
        eventService.createEvent(event: event){ (res) in
                switch res {
                case .success(_):
                    self.getAllEvents()
                case .failure(_):
                    print("error create event")
                }
            }
        
    }
    
    
    @objc func createEvents() {
        eventService.createEvents(event: events){ (res) in
                switch res {
                case .success(_):
                    //self.getAllEvents()
                    print("sucesso create events")
                case .failure(_):
                    print("error create events")
                }
            }
        
    }
    
    
    @objc func deleteAllEvents() {
        eventService.deleteAllEvents(){ (res) in
                switch res {
                case .success(_):
                    //self.getAllEvents()
                    print("success")
                case .failure(_):
                    print("error delete all events")
                }
            }
        
    }
    
    
    
    @objc func updateEvent() {
        eventService.updateEvent(id: event.id!, event: event){ (res) in
                switch res {
                case .success(_):
                    self.getAllEvents()
                case .failure(_):
                    print("error update event")
                }
            }
        
    }
    
    @objc func deleteEvent(id: Int) {
        eventService.deleteEvent(id: id) { (res) in
            switch res {
            case .success(_):
                self.getAllEvents()
            case .failure(_):
                self.isFromCoreData = true
               
            }
        }
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
