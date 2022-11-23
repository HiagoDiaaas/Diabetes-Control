import UIKit

class Event: NSObject, Codable {
    
    var id: Int?
    var sfSymbolIdentifier: String?
    var dateAndTime: String?
    var value: String?
    var type: String?
    
    
    override init() {
        super.init()
    }
    
}

