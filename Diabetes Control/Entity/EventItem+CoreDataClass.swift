//
//  EventItem+CoreDataClass.swift
//  Diabetes Control
//
//  Created by Hiago Santos Martins Dias on 24/10/22.
//
//

import Foundation
import CoreData

@objc(EventItem)
public class EventItem: NSManagedObject, Decodable {
    
    enum CodingKeys: String, CodingKey {
        case sfSymbolIdentifier
        case dateAndTime
        case value
        case type
    
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let contextUserInfoKey = CodingUserInfoKey.context else { fatalError("cannot find context key") }
        
        guard let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext else { fatalError("cannot Retrieve context") }
        
        guard let entity = NSEntityDescription.entity(forEntityName: "EventModel", in: managedObjectContext) else { fatalError() }
        
        self.init(entity: entity, insertInto: nil)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.sfSymbolIdentifier = try values.decode(String.self, forKey: .sfSymbolIdentifier)
        self.dateAndTime = try values.decode(String.self, forKey: .dateAndTime)
        self.value = try values.decode(String.self, forKey: .value)
        self.type = try values.decode(String.self, forKey: .type)
        
        
    }
    
    
    
    

}

extension EventItem: Encodable{
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.sfSymbolIdentifier, forKey: .sfSymbolIdentifier)
        try container.encodeIfPresent(self.dateAndTime, forKey: .dateAndTime)
        try container.encodeIfPresent(self.type, forKey: .type)
        try container.encode(self.value, forKey: .value)
        
    }
}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
