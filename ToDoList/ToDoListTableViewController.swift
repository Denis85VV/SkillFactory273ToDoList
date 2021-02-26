//
//  ToDoListTableViewController.swift
//  ToDoList
//
//  Created by Denis on 09.02.2021.
//

import UIKit

class ToDoListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  let model = ToDoListModel()
  let tableView = UITableView()
  
  let plusButton = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: nil)
  let editButton = UIBarButtonItem(image: editOff, style: .plain, target: self, action: nil)
  let arrowButton = UIBarButtonItem(image: arrowUp, style: .plain, target: self, action: nil)
  
  static let plusImage = UIImage(systemName: "plus")
  static let editOn = UIImage(systemName: "pencil.slash")
  static let editOff = UIImage(systemName: "pencil")
  static let arrowUp = UIImage(systemName: "arrow.up")
  static let arrowDown = UIImage(systemName: "arrow.down")
  public let arrayOfImages = ["bellsprout","bullbasaur","caterpie","charmander","dratini","eevee","jigglypuff","mankey","meowth","mew","pidgey","pikachu-2","psyduck","rattata","snorlax","squirtle","venonat","weedle","zubat"]
  
  var popUpAction = UIAlertController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationItem.rightBarButtonItems = [plusButton, editButton, arrowButton]
    self.navigationItem.title = "Tasks"
    
    tableView.delegate = self
    tableView.dataSource = self
    
    plusButton.target = self
    plusButton.action = #selector(addTaskButtonAction(_:))
    editButton.target = self
    editButton.action = #selector(editButtonAction(_:))
    arrowButton.target = self
    arrowButton.action = #selector(sortingTasksButtonAction(_:))
    
    view.addSubview(tableView)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
    tableView.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
    tableView.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
    tableView.separatorColor = .gray
    
    tableView.register(CustomToDoListCell.self, forCellReuseIdentifier: "contactCell")
    
  }
  
  // MARK: - Table View Data Source
  
  func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return model.toDoItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! CustomToDoListCell
    // Configure the cell...
    cell.itemLabel.text = model.toDoItems[indexPath.row].string
    let currentItem = model.toDoItems[indexPath.row]
    cell.itemLabel.text = currentItem.string
    cell.imgView.image = UIImage(named: arrayOfImages[indexPath.row])
    cell.accessoryType = currentItem.completed ? .checkmark : .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if model.changeState(at: indexPath.row) == true {
      tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
      tableView.cellForRow(at: indexPath)?.tintColor = .systemGreen
    } else {
      tableView.cellForRow(at: indexPath)?.accessoryType = .none
      tableView.cellForRow(at: indexPath)?.tintColor = .none
    }
  }
  
  // Override to support conditional editing of the table view.
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
  }
  
  // Override to support editing the table view.
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == UITableViewCell.EditingStyle.delete {
      // Delete the row from the data source
      model.toDoItems.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    } // else if editingStyle == .insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    // }
  }
  
  // Override to support rearranging the table view.
  func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    model.moveItem(fromIndex: fromIndexPath.row, toIndex: to.row)
    tableView.reloadData()
  }
  
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (action, view, completionHandler) in
      self?.editCellContent(indexPath: indexPath)
      completionHandler(true)
    }
    editAction.backgroundColor = .systemBlue
    return UISwipeActionsConfiguration(actions: [editAction])
  }
  
  func editCellContent(indexPath: IndexPath) {
    let cell = tableView(tableView, cellForRowAt: indexPath) as! CustomToDoListCell
    popUpAction = UIAlertController(title: "Edit your task", message: nil, preferredStyle: .alert)
    popUpAction.addTextField(configurationHandler: { (textField) -> Void in
      textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
      textField.text = cell.itemLabel.text
    })
    let cancelPopUpAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let editPopUpAction = UIAlertAction(title: "Submit", style: .default) { (createAlert) in
      guard let textFields = self.popUpAction.textFields, textFields.count > 0 else{
        return
      }
      guard let textValue = self.popUpAction.textFields?[0].text else {
        return
      }
      
      self.model.updateItem(at: indexPath.row, with: textValue)
      self.tableView.reloadData()
    }
    popUpAction.addAction(cancelPopUpAction)
    popUpAction.addAction(editPopUpAction)
    present(popUpAction, animated: true, completion: nil)
  }
  
  // MARK: - Button Actions
  
  @objc func alertTextFieldDidChange(_ sender: UITextField) {
    guard let senderText = sender.text, popUpAction.actions.indices.contains(1) else {
      return
    }
    let action = popUpAction.actions[1]
    action.isEnabled = senderText.count > 0
  }
  
  @objc func addTaskButtonAction(_ sender: Any) {
    popUpAction = UIAlertController(title: "Add a new note", message: nil, preferredStyle: .alert)
    popUpAction.addTextField { (textField: UITextField) in
      textField.placeholder = "Put your note here"
      textField.addTarget(self, action: #selector(self.alertTextFieldDidChange(_:)), for: .editingChanged)
    }
    let createPopUpAction = UIAlertAction(title: "Add", style: .default) { (createAlert) in
      // add new task
      guard let unwrTextFieldValue = self.popUpAction.textFields?[0].text else {
        return
      }
      
      self.model.addItem(itemName: unwrTextFieldValue)
      self.model.sortByTitle()
      self.tableView.reloadData()
    }
    let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    popUpAction.addAction(cancelAlertAction)
    popUpAction.addAction(createPopUpAction)
    present(popUpAction, animated: true, completion: nil)
    createPopUpAction.isEnabled = false
  }
  
  @objc func editButtonAction(_ sender: Any) {
    tableView.setEditing(!tableView.isEditing, animated: true)
    model.editButtonClicked = !model.editButtonClicked
    editButton.image = model.editButtonClicked ? ToDoListTableViewController.editOn : ToDoListTableViewController.editOff
  }
  
  @objc func sortingTasksButtonAction(_ sender: Any) {
    model.sortedAscending = !model.sortedAscending
    arrowButton.image = model.sortedAscending ? ToDoListTableViewController.arrowUp : ToDoListTableViewController.arrowDown
    model.sortByTitle()
    tableView.reloadData()
  }
  
}

// MARK: - Cell Protocol Stubs

extension ToDoListTableViewController: CustomToDoListCellDelegate {
  
  func editCellFunc(cell: CustomToDoListCell) {
    let indexPath = tableView.indexPath(for: cell)
    guard let unwrIndexPath = indexPath else {
      return
    }
    self.editCellContent(indexPath: unwrIndexPath)
    print("Item edited")
  }
  
  func deleteCellFunc(cell: CustomToDoListCell) {
    let indexPath = tableView.indexPath(for: cell)
    guard let unwrIndexPath = indexPath else {
      return
    }
    model.removeItem(at: unwrIndexPath.row)
    print("Item deleted")
    tableView.reloadData()
  }
  
}
