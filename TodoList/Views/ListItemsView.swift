//
//  ListItemsView.swift
//  TodoList
//
//  Created by Morgan Harris-Stoertz on 2023-04-11.
//
import Blackbird
import SwiftUI

struct ListItemsView: View {
    //MARK: Stored properties
    //needed to query database
    @Environment(\.blackbirdDatabase) var db: Blackbird.Database?
    
    @BlackbirdLiveModels var todoItems: Blackbird.LiveResults<TodoItem>
    
    //MARK: Computed properties
    var body: some View {
        List{
            ForEach(todoItems.results) {currentItem in
                Label(title: {
                    Text(currentItem.description)
                }, icon: {
                    if currentItem.completed == true {
                        Image(systemName: "checkmark.circle")
                    } else {
                        Image(systemName: "circle")
                    }
                })
                .onTapGesture {
                    Task {
                        try await db!.transaction { core in
                            //Change the status for this person to the opposite of its current value
                            try core.query("UPDATE TodoItem SET completed = (?) Where id = (?)",
                                           !currentItem.completed,
                                           currentItem.id)
                        }
                    }
                }
            }
            .onDelete(perform: removeRows)
        }
    }
    
    //MARK: initializer(s)
    init(filterOn searchText: String){
        //initialize the live model
        _todoItems = BlackbirdLiveModels({ db in
            try await TodoItem.read(from: db, sqlWhere: "description LIKE ?, %\(searchText)%")
        })
        
    }
    
    //MARK: functions
    func removeRows(at offsets: IndexSet){
        Task{
            try await db!.transaction { core in
                //get the id of the item that must be deleted
                var idList = ""
                for offset in offsets {
                    idList += "\(todoItems.results[offset].id),"
                }
                
                //remove the final comma
                print(idList)
                idList.removeLast()
                print(idList)
                
                //Delete the row(s) from the data base
                try core.query("DELETE FROM TodoItem Where id IN (?)", idList)
            }
        }
    }
}

struct ListItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemsView(filterOn: "Go")
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}
