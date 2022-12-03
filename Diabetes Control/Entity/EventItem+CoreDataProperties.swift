//
//  EventItem+CoreDataProperties.swift
//  Diabetes Control
//
//  Created by Hiago Santos Martins Dias on 24/10/22.
//
//

import Foundation
import CoreData


extension EventItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventItem> {
        return NSFetchRequest<EventItem>(entityName: "EventItem")
    }

    @NSManaged public var sfSymbolIdentifier: String?
    @NSManaged public var dateAndTime: String?
    @NSManaged public var value: String?
    @NSManaged public var type: String?

}

extension EventItem : Identifiable {

}
