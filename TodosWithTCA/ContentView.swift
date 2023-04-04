//
//  ContentView.swift
//  TodosWithTCA
//
//  Created by 佐藤真 on 2023/03/23.
//

import SwiftUI
import ComposableArchitecture

struct Todos: ReducerProtocol {
    struct State: Equatable {
        var todos: [Todo] = []
    }

    enum Action {
        case todoCheckboxTapped(index: Int)
        case todoTextFieldChanged(index: Int, text: String)
    }

    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            case .todoCheckboxTapped(index: let index):
                state.todos[index].isComplete.toggle()
                return .none
            case .todoTextFieldChanged(index: let index, text: let text):
                state.todos[index].description = text
                return .none
        }
    }
}

struct Todo: Equatable, Identifiable {
    var description = ""
    let id: UUID
    var isComplete = false
}

struct AppState: Equatable {
    var todos: [Todo] = []
}

struct AppEnvironment {

}

struct ContentView: View {
    let store: StoreOf<Todos>

    var body: some View {
        NavigationView {
            WithViewStore(self.store) { viewStore in
                List {
                    ForEach(Array(zip(viewStore.todos.indices, viewStore.todos)), id: \.1.id) { index, todo in
                        HStack {
                            Button {
                                viewStore.send(.todoCheckboxTapped(index: index))
                            } label: {
                                Image(systemName: todo.isComplete ? "checkmark.square" : "square")
                            }
                            .buttonStyle(.plain)
                            TextField(
                                "Untitled todo",
                                text: viewStore.binding(
                                    get: { $0.todos[index].description },
                                    send: { .todoTextFieldChanged(index: index, text: $0) }
                                )
                            )
                        }
                        .foregroundColor(todo.isComplete ? .gray : nil)
                    }
                }
                .navigationTitle("Todos")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            store: Store(
                initialState: Todos.State(
                    todos: [
                        Todo(
                            description: "Hand soup",
                            id: UUID(),
                            isComplete: false
                        ),
                        Todo(
                            description: "Eggs",
                            id: UUID(),
                            isComplete: false
                        ),
                        Todo(
                            description: "Hand Soap",
                            id: UUID(),
                            isComplete: false
                        ),
                    ]
                ),
                reducer: Todos()._printChanges()
            )
        )
    }
}
