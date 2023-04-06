//
//  ListView.swift
//  TodoList
//
//  Created by Morgan Harris-Stoertz on 2023-04-04.
//

import Blackbird
import SwiftUI

struct ListView: View {
    
    //MARK: Stored properties
    
    @Environment(\.blackbirdDatabase) var db:
    Blackbird.Database? 
    
    // the list of items to be completed
    @BlackbirdLiveModels({ db in
        try await TodoItem.read(from: db)
    }) var todoItems
    
    // the item currently being added
    @State var newItemDescription: String = ""
    
    //MARK: Computed properties
    var body: some View {
        
        NavigationView{
            VStack{
                HStack{
                    TextField("Enter a to-do item", text: $newItemDescription)
                    
                    Button(action: {
                        Task{
                            //write to the data base
                            try await db!.transaction { core in
                                try core.query("INSERT INTO TodoItem (description) VALUES (?)", newItemDescription)
                            }
                            
                        //clear the input field
                            newItemDescription = ""
                        }
                    }, label: {
                        Text("ADD")
                            .font(.caption)
                    })
                }
                .padding(20)
                
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
                
                
//                List{
//                    HStack{
//                        Image(systemName: "circle")
//                            .foregroundColor(.blue)
//                        Text("Study for Physics quiz")
//                    }
//
//                    HStack{
//                        Image(systemName: "checkmark.circle")
//                            .foregroundColor(.blue)
//                        Text("Finish Computer Science Assignment")
//                    }
//
//                    HStack{
//                        Image(systemName: "circle")
//                            .foregroundColor(.blue)
//                        Text("Go for run")
//                    }
//                }
            }
            .navigationTitle("To do")
        }
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

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
