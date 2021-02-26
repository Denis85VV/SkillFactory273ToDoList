//
//  CustomToDoListCell.swift
//  ToDoList
//
//  Created by Denis on 09.02.2021.
//

import UIKit

protocol CustomToDoListCellDelegate {
    func editCellFunc(cell: CustomToDoListCell)
    func deleteCellFunc(cell: CustomToDoListCell)
}

class CustomToDoListCell: UITableViewCell {
  
  var delegate: CustomToDoListCellDelegate?

  let itemLabel: UILabel = {
      let label = UILabel()
      label.textColor = .black
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
  }()
  
  let editItem: UIButton = {
      let button = UIButton()
      let image = UIImage(systemName: "square.and.pencil")
      button.setImage(image, for: .normal)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
  }()
  
  let deleteItem: UIButton = {
    let button = UIButton()
    let image = UIImage(systemName: "trash.fill")
    button.setImage(image, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    return button
  }()
  
  let imgView: UIImageView = {
    let image = UIImageView()
    image.image = UIImage(named: "bellsprout")
    image.translatesAutoresizingMaskIntoConstraints = false
    return image
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(editItem)
    contentView.addSubview(itemLabel)
    contentView.addSubview(deleteItem)
    contentView.addSubview(imgView)
    
    editItem.addTarget(self, action: #selector(editCell(_:)), for: .touchUpInside)
    deleteItem.addTarget(self, action: #selector(deleteCell(_:)), for: .touchUpInside)
    
    // MARK: - Constraints
    
    editItem.widthAnchor.constraint(equalToConstant:30).isActive = true
    editItem.heightAnchor.constraint(equalToConstant:30).isActive = true
    editItem.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-55).isActive = true
    editItem.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
  
    itemLabel.leftAnchor.constraint(equalTo:self.contentView.leftAnchor, constant:70).isActive = true
    itemLabel.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor).isActive = true
    itemLabel.trailingAnchor.constraint(equalTo:editItem.trailingAnchor).isActive = true
    itemLabel.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true

    deleteItem.widthAnchor.constraint(equalToConstant:30).isActive = true
    deleteItem.heightAnchor.constraint(equalToConstant:30).isActive = true
    deleteItem.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-15).isActive = true
    deleteItem.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
    
    imgView.widthAnchor.constraint(equalToConstant:40).isActive = true
    imgView.heightAnchor.constraint(equalToConstant:40).isActive = true
    imgView.leftAnchor.constraint(equalTo:self.contentView.leftAnchor, constant:20).isActive = true

  }
  // MARK: - Button Actions in Cell

  @objc func deleteCell(_ sender: UIButton) {
    delegate?.deleteCellFunc(cell: self)
    print("Delete button pressed")
  }
  
  @objc func editCell(_ sender: UIButton) {
    delegate?.editCellFunc(cell: self)
    print("Edit button pressed")
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
}
