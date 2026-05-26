//
//  AddHabitView.swift
//  HabitTracker-Salilig
//
//  Created by Charle Salilig on 5/22/26.
//

import SwiftUI

struct AddHabitView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = AddHabitViewModel()
    
    var habitToEdit: Habit? = nil
    
    
    var body: some View {
        
        VStack (alignment: .center, spacing: 15) {
            //emoji picker
            TextField("📖", text: $viewModel.emoji.max(1))
                .frame(width: 70)
                .font(.system(size: 60).bold())
                .padding(.top, 30)
            
            //title
            TextField("Title", text: $viewModel.title.max(25))
                .font(Font.system(.title).bold())
            
            //desc
            TextField("Description", text: $viewModel.desc.max(50), axis: .vertical)
                .font(Font.system(.body).bold())
                .multilineTextAlignment(.leading)
            
            //error
            if viewModel.isError.count > 0 {
                Text(viewModel.isError)
                    .foregroundStyle(Color.red)
            }
            
            
            //add/save button
                        Button(
                            action: {
                                // check updating or adding
                                if habitToEdit != nil {
                                    if (viewModel.updateHabit()) {
                                        dismiss()
                                    }
                                } else {
                                    if (viewModel.addHabit()) {
                                        dismiss()
                                    }
                                }
                            },
                            label: {
                                // save / add
                                Text(habitToEdit == nil ? "Add Habit" : "Save Changes")
                                    .padding()
                                    .background(.blue)
                                    .foregroundStyle(.white)
                                    .cornerRadius(10)
                            })
                        
                    }
                    .padding(30)
                    // add field when editing
                    .onAppear {
                        if let habit = habitToEdit {
                            viewModel.emoji = habit.emoji
                            viewModel.title = habit.title
                            viewModel.desc = habit.description
                            viewModel.editingHabitId = habit.id
                        }
                    }
        Spacer()
    }
}

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.prefix(limit))
            }
        }
        return self
    }
}

#Preview {
    AddHabitView()
}
