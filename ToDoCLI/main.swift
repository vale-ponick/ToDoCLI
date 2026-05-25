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
