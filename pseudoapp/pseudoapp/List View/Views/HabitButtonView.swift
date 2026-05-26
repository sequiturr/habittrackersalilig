//
//  HabitButtonView.swift
//  HabitTracker-Salilig
//
//  Created by Charle Salilig on 5/22/26.
//

import SwiftUI

struct HabitButtonView: View {
    
    @ObservedObject var viewModel: HabitButtonViewModel
    @Binding var isEditMode: Bool
    @State private var showDeleteAlert = false
    
    var onEditTap: () -> Void
    
    init(habit: Habit, isEditMode: Binding<Bool>, onEditTap: @escaping () -> Void = {}) {
        self.viewModel = HabitButtonViewModel(habit: habit)
        self._isEditMode = isEditMode
        self.onEditTap = onEditTap
    }
    
    var body: some View {
        Button(action: {
            if isEditMode {
                onEditTap()
            } else {
                viewModel.buttonHabitTapped()
            }
        }) {
            HStack {
                Text(viewModel.habit.emoji)
                    .font(Font.system(size: 50))
                
                VStack(alignment: .leading) {
                    Text(viewModel.habit.title)
                        .font(Font.system(size: 20, weight: .bold))
                        .multilineTextAlignment(.leading)
                    Text(viewModel.habit.description)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color(.label))
                    Text("\(viewModel.habit.streak) Days Streak")
                }
                Spacer()
                
                if (viewModel.habit.isCompleted && !isEditMode) {
                    Text("✅")
                        .font(Font.system(size: 40))
                        .padding()
                }
                
                if (isEditMode && !viewModel.isDeleted) {
                    Button(
                        action: {
                            showDeleteAlert = true
                    },
                        label: {
                            Image(systemName: "trash")
                                .font(Font.system(size: 30))
                                .foregroundStyle(.red)
                                .padding()
                    })
                    
                    .buttonStyle(.borderless)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(15)
            .shadow(color: Color(.systemGray), radius: 3)
            .opacity(viewModel.buttonOpacity)
        }

        .alert("Delete Habit", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteHabit()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to delete this habit?")
        }
    }
}

#Preview {
    HabitButtonView(habit: DeveloperPreview.habits[0], isEditMode: .constant(true))
}
