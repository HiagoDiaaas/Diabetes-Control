//
//  SyncStatus+CoreDataProperties.swift
//  Diabetes Control
//
//  Created by Hiago Santos Martins Dias on 02/12/22.
//
//

import Foundation
import CoreData


extension SyncStatus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SyncStatus> {
        return NSFetchRequest<SyncStatus>(entityName: "SyncStatus")
    }

    @NSManaged public var isEventNew: Bool
    @NSManaged public var isEventUpdated: Bool
    @NSManaged public var isEventDeleted: Bool

}

extension SyncStatus : Identifiable {

}
