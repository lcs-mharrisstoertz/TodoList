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
 
    
    // the item currently being added
    @State var newItemDescription: String = ""
    
    @State var searchText = ""
    
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
                
                ListItemsView(filterOn: searchText)
                .searchable(text: $searchText)
                
            }
            .navigationTitle("To do")
        }
    }
    
    
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environment(\.blackbirdDatabase, AppDatabase.instance)
    }
}
