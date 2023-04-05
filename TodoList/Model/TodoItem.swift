//
//  TodoItem.swift
//  TodoList
//
//  Created by Morgan Harris-Stoertz on 2023-04-04.
//

import Blackbird
import Foundation

struct TodoItem: BlackbirdModel {
    @BlackbirdColumn var id: Int
    @BlackbirdColumn var description: String
    @BlackbirdColumn var completed: Bool
}


//struct TodoItem: Identifiable{
//    var id: Int
//    var description: String
//    var completed: Bool
//}
//
//var existingTodoItems = [
//TodoItem(id: 1, description: "Study for Physics test", completed: false),
//TodoItem(id: 2, description: "Finish Computer Science assignment", completed: true),
//TodoItem(id: 3, description: "Go for a run", completed: false),
//]



