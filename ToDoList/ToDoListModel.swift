//
//  Model.swift
//  ToDoList
//
//  Created by Denis on 09.02.2021.
//

import Foundation
import UIKit

class ToDoListItem {
  var string: String
  var completed: Bool
  
  init(string: String, completed: Bool) {
    self.string = string
    self.completed = completed
  }
}

class ToDoListModel {
  
  var editButtonClicked: Bool = false
  
  var toDoItems: [ToDoListItem] = [
    ToDoListItem(string: "First note", completed: false),
    ToDoListItem(string: "Second note", completed: false),
    ToDoListItem(string: "Third note", completed: false),
  ]
  
  var sortedAscending: Bool = true
  
  func addItem(itemName: String, isCompleted: Bool = false) {
    toDoItems.append(ToDoListItem(string: itemName, completed: isCompleted))
  }
  
  func removeItem(at index: Int) {
    toDoItems.remove(at: index)
  }
  
  func moveItem(fromIndex: Int, toIndex: Int) {
    let from = toDoItems[fromIndex]
    toDoItems.remove(at: fromIndex)
    toDoItems.insert(from, at: toIndex)
  }
  
  func updateItem(at index: Int, with string: String) {
    toDoItems[index].string = string
  }
  
  func changeState(at item: Int) -> Bool {
    toDoItems[item].completed = !toDoItems[item].completed
    return toDoItems[item].completed
  }
  
  func sortByTitle() {
    toDoItems.sort {
      sortedAscending ? $0.string < $1.string : $0.string > $1.string
    }
  }
  
  func search() {
    
  }
}
