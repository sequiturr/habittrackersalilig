//
//  HabitListView.swift
//  HabitTracker-Salilig
//
//  Created by Charle Salilig on 5/22/26.
//

import SwiftUI

struct HabitListView: View {
    
    @StateObject var viewModel = HabitListViewModel()
    @State var showAddhabitForm: Bool = false
    @State var isEditMode: Bool = false
    @State var selectedHabit: Habit? = nil
    
    var body: some View {
        
        ScrollView {
        VStack (alignment:.leading, spacing : 30) {
            //start
            
            Text("Let's start the day.")
                .font(.title)
                .fontWeight(.bold)
            
            //Date
            VStack (spacing: 10){
                Text("Today is \(viewModel.dateString)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.orange)
                
                //Streak
                Text("🔥 \(viewModel.streak) Day Streak!")
            }
            
            
            //Habit Title
            
            LazyVStack (spacing: 20) {
                ForEach (viewModel.habits) { habit in
                    HabitButtonView(habit: habit, isEditMode: $isEditMode)
                    {
                        selectedHabit = habit
                        showAddhabitForm = true
                    }
                }
            }
            
            //Add habit
            HStack {
                Spacer()
                Button (
                    action: {
                        selectedHabit = nil
                        showAddhabitForm.toggle()
                    },
                    label: {
                        Image(systemName: "plus.circle.fill")
                            .font(Font.system(size: 30))
                    }
                )
            }
            
            Spacer()
        }
        .padding(40)
        }
        
        .sheet(isPresented: $showAddhabitForm, onDismiss: viewModel.onAddHabitDismissed) {
            AddHabitView(habitToEdit: selectedHabit)
                .id(selectedHabit?.id ?? "AddMode")
                .presentationDragIndicator(.visible)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing,) {
                Button(isEditMode ? "Done" : "Edit") {
                    isEditMode.toggle()
                    viewModel.refresh()
                }
            }
        }
    }
}

#Preview {
    HabitListView()
}
