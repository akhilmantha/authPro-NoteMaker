//
//  Note.swift
//  TouchMeIn
//
//  Created by akhil mantha on 12/06/17.
//  Copyright © 2017 iT Guy Technologies. All rights reserved.
//

import Foundation
import CoreData

class Note: NSManagedObject {
  
  @NSManaged var noteText: String
  @NSManaged var date: Date
  
}
