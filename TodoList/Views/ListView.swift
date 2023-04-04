//
//  ListView.swift
//  TodoList
//
//  Created by Morgan Harris-Stoertz on 2023-04-04.
//

import SwiftUI

struct ListView: View {
    
    //MARK: Computed properties
    var body: some View {
        
        NavigationView{
            VStack{
                HStack{
                    TextField("Enter a to-do item", text: Binding.constant(""))
                    
                    Button(action: {
                    }, label: {
                        Text("ADD")
                            .font(.caption)
                    })
                }
                .padding(20)
                
                List{
                    HStack{
                        Image(systemName: "circle")
                        Text("Study for Physics quiz")
                    }
                    
                    HStack{
                        Image (systemName: "checkmark.circle")
                        Text("Finish Computer Science Assignment")
                    }
                    
                    HStack{
                    Text("Go for run")
                }
            }
            
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
