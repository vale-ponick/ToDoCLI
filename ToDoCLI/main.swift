//
//  main.swift
//  ToDoCLI
//
//  Created by Валерия Пономарева on 25.05.2026.
//

import Foundation

print("ToDoCLI")

// MARK: - данные
var tasks: [String] = [] // массив здля хранения адач

func addTask() -> String? { // Одна функция —> одна ответственность
    while true {
        print("Add task: ", terminator: "") // подсказка юзеру
        
        let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let input = input, !input.isEmpty else {
            print("❌ Please enter a non-empty task")
            continue
        }
        return input
    }
}

// MARK: - Main loop
while true {
    print("\n 📝 ToDoCLI: ➕ add | 📋 list | ✖️ delete | 🏁 exit | 🧹 clear")
    print("> ", terminator: "")
    
    let command = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) // преобразуем ввод юзера
    
    switch command {
    case "add", "1":
        if let newTask = addTask() {
            tasks.append(newTask)
            print("✅ Added: \(newTask)")
        }
    case "list", "2":
        if tasks.isEmpty {
            print("No task")
        } else {
            for (index, task) in tasks.enumerated() { // ?
                print("\(index + 1). \(task)")
            }
        }
    case "delete", "3":
        if tasks.isEmpty {
            print("No task")
            continue
        }
        print("Delete number of task: ", terminator: "")
        let input = readLine()?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let input = input, let number = Int(input)  else {
            print("Emter a valid number: ")
            continue
        }
        let index = number - 1
        guard index >= 0 && index < tasks.count else {
            print("Task number \(number) does not exist")
            continue
        }
            let removed = tasks.remove(at: index)
            print("Deleted: \(removed)")
        
    case "clear", "5":
        print("⚠️ Dwleteall tasks? (y/n): ", terminator: "")
        let confirm = readLine()?.lowercased()
        if confirm == "y" || confirm == "yes" {
            tasks.removeAll()
            print("All tasks deleted")
        } else {
            print("Cancelled")
        }
        
    case "exit", "quit", "4":
        print("By, vale.ponick!")
        break
        
    default:
        print("Unknown command. Use: add, list, delete, exit")
    }
}
