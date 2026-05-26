//
//  main.swift
//  ToDoCLI
//
//  Created by Валерия Пономарева on 25.05.2026.
//

import Foundation

print("ToDoCLI")

// MARK: - Command Enum

enum Command: String {
    case add
    case list
    case delete
    case clear
    case save
    case exit
    
    static let aliases: [String: Command] = [
        "1": .add,
        "2": .list,
        "3": .delete,
        "4": .clear,
        "5": .save,
        "6": .exit,
        "quit": .exit,
        "q": .exit
    ]
    
    init?(from input: String) {
        let cleaned = input.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if let command = Command(rawValue: cleaned) {
            self = command
        } else if let aliased = Command.aliases[cleaned] {
            self = aliased
        } else {
            return nil
        }
    }
}

// MARK: - Task Structure

struct Task: Codable {
    let id: Int
    var text: String
    var category: String
    var isCompleted: Bool = false
    
    var description: String {
        let status = isCompleted ? "✅" : "⏳"
        return "[\(category)] \(text)"
    }
}

// MARK: - ToDoList Structure

struct ToDoList {
    private var tasks: [Task] = []
    private var nextID: Int = 1
    private let filename: String = "tasks.json"
    
    // MARK: - Private Helpers
    
    private func getValidatedInput(prompt: String, allowEmpty: Bool = false) -> String? {
        print(prompt, terminator: "")
        let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if allowEmpty {
            return input
        }
        
        guard let input = input, !input.isEmpty else {
            print("❌ Input cannot be empty")
            return nil
        }
        return input
    }
    
    private func getTaskNumber() -> Int? {
        guard let input = getValidatedInput(prompt: "Delete number of task: "),
              let number = Int(input) else {
            print("❌ Enter a valid number")
            return nil
        }
        
        let index = number - 1
        guard index >= 0 && index < tasks.count else {
            print("❌ Task number \(number) does not exist")
            return nil
        }
        return index
    }
    
    private mutating func loadTasks() {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filename)),
              let decoded = try? JSONDecoder().decode([Task].self, from: data) else {
            print("📭 No saved tasks found")
            return
        }
        tasks = decoded
        if let maxID = tasks.map({ $0.id }).max() {
            nextID = maxID + 1
        }
        print("✅ Loaded \(tasks.count) task(s) from file")
    }
    
    private func saveTasks() {
        do {
            let encoded = try JSONEncoder().encode(tasks)
            try encoded.write(to: URL(fileURLWithPath: filename))
            print("✅ Saved \(tasks.count) task(s) to \(filename)")
        } catch {
            print("❌ Error saving: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Commands
    
    mutating func add() {
        guard let text = getValidatedInput(prompt: "Add task: ") else { return }
        
        let category = getValidatedInput(prompt: "Category (work/personal/other): ", allowEmpty: true) ?? "other"
        
        let task = Task(id: nextID, text: text, category: category)
        tasks.append(task)
        nextID += 1
        print("✅ Added: \(task.description)")
    }
    
    func list() {
        if tasks.isEmpty {
            print("📭 No tasks")
        } else {
            let grouped = Dictionary(grouping: tasks, by: { $0.category })
            
            for (category, catTasks) in grouped.sorted(by: { $0.key < $1.key }) {
                print("\n📁 \(category.uppercased()) (\(catTasks.count)):")
                for task in catTasks {
                    print("  [\(task.isCompleted ? "✅" : "⏳")] \(task.text)")
                }
            }
            
            print("\n📊 Total: \(tasks.count) task\(tasks.count == 1 ? "" : "s")")
        }
    }
    
    mutating func delete() {
        guard !tasks.isEmpty else {
            print("📭 No tasks to delete")
            return
        }
        
        guard let index = getTaskNumber() else { return }
        let removed = tasks.remove(at: index)
        print("🗑️ Deleted: \(removed.description)")
    }
    
    mutating func clear() {
        guard !tasks.isEmpty else {
            print("📭 No tasks to clear")
            return
        }
        
        print("⚠️ Delete all tasks? (y/n): ", terminator: "")
        guard let confirm = readLine()?.lowercased(),
              confirm == "y" || confirm == "yes" else {
            print("❌ Cancelled")
            return
        }
        
        tasks.removeAll()
        print("🗑️ All tasks deleted")
    }
    
    mutating func save() {
        saveTasks()
    }
    
    func exit() {
        print("💾 Auto-saving before exit...")
        saveTasks()
        print("👋 By, vale.ponick!")
    }
    
    // MARK: - Main Loop
    
    mutating func run() {
        loadTasks()
        
        while true {
            print("\n📝 ToDoCLI: ➕ add | 📋 list | ✖️ delete | 🧹 clear | 💾 save | 🏁 exit")
            print("> ", terminator: "")
            
            guard let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let command = Command(from: input) else {
                print("❌ Unknown command. Use: add, list, delete, clear, save, exit")
                continue
            }
            
            switch command {
            case .add: add()
            case .list: list()
            case .delete: delete()
            case .clear: clear()
            case .save: save()
            case .exit:
                exit()
                return
            }
        }
    }
}

// MARK: - Program Entry Point

var todo = ToDoList()
todo.run()
