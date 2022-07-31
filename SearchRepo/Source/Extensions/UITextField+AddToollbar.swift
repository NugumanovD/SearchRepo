//
//  UITextField+AddToollbar.swift
//  SearchRepo
//
//  Created by Dmitry Nugumanov on 30.07.2022.
//

import UIKit

extension UITextField {
  
  func addDoneButtonOnKeyboard(){
    let doneToolbar: UIToolbar = UIToolbar(
      frame: CGRect.init(
        x: 0,
        y: 0,
        width: UIScreen.main.bounds.width,
        height: 50
      )
    )
    doneToolbar.barStyle = .default
    
    let flexSpace = UIBarButtonItem(
      barButtonSystemItem: .flexibleSpace,
      target: nil,
      action: nil
    )
    let done: UIBarButtonItem = UIBarButtonItem(
      title: "Done",
      style: .done,
      target: self,
      action: #selector(self.doneButtonAction)
    )
    
    let items = [flexSpace, done]
    doneToolbar.items = items
    doneToolbar.sizeToFit()
    
    self.inputAccessoryView = doneToolbar
  }
  
  @objc func doneButtonAction() {
    self.resignFirstResponder()
  }
  
}
