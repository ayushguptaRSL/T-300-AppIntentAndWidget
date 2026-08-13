// ContentView.swift
import SwiftUI

struct ContentView: View {
    private let store = TaskStore.shared

    @State private var title: String = ""
    @State private var dueDate: Date = .now
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let task = store.task {
                    VStack(spacing: 8) {
                        Text(task.title)
                            .font(.title2)
                            .bold()
                        Text("Due \(task.dueDate.formatted(.dateTime.day().month().year().hour().minute()))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Button {
                            store.clearTask()
                        } label: {
                            Label("Mark Done", systemImage: "checkmark.circle.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
                } else {
                    Text("No due task set")
                        .foregroundStyle(.secondary)
                }

                VStack(alignment: .leading, spacing: 8) {
                    TextField("Task title", text: $title)
                        .textFieldStyle(.roundedBorder)

                    DatePicker("Due", selection: $dueDate)

                    Button {
                        setTask()
                    } label: {
                        Label("Set Due Task", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("TBTask")
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background {
                store.syncLiveActivity()
            }
        }
    }

    private func setTask() {
        let trimmed = title.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        store.setTask(title: trimmed, dueDate: dueDate)
        title = ""
        dueDate = .now
    }
}
