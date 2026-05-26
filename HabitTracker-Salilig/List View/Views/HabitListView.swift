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
            
            Text(viewModel.greeting)
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
                
                // Daily Progress Bar
                let completedCount = viewModel.habits.filter { $0.isCompleted }.count
                let totalCount = viewModel.habits.count
                if totalCount > 0 {
                    VStack(spacing: 5) {
                        ProgressView(value: Double(completedCount), total: Double(totalCount))
                            .tint(.green)
                        Text("\(completedCount) of \(totalCount) completed")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    .padding(.top, 5)
                    .padding(.horizontal, 20)
                }
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
