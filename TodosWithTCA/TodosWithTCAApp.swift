//
//  TodosWithTCAApp.swift
//  TodosWithTCA
//
//  Created by 佐藤真 on 2023/03/23.
//

import ComposableArchitecture
import SwiftUI

@main
struct TodosWithTCAApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(
                    initialState: Todos.State(
                        todos: [Todo(
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
                        ),]
                    ),
                    reducer: Todos()._printChanges()
                )
            )
        }
    }
}
