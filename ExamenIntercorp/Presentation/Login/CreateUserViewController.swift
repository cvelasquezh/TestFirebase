//
//  CreateUserViewController.swift
//  ExamenIntercorp
//
//  Created by Cesar Velasquez on 5/7/19.
//  Copyright © 2019 Intercorp. All rights reserved.
//

import UIKit
import JGProgressHUD
class CreateUserViewController: UIViewController {
    
    var name: String? = ""
    var username: String? = ""
    var email: String? = ""
    
    let dateFormatter:DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()
    
    let imageBackground :UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "background")
      imageview.contentMode = UIViewContentMode.scaleAspectFill
      return imageview
    }()
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    let txtName:INTTextField = {
        let textField = INTTextField()
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.placeholder = "Ingrese Nombre"
        return textField
    }()
    
    let txtLastName:INTTextField = {
        let textField = INTTextField()
        textField.placeholder = "Ingrese Apellidos"
        textField.borderStyle = UITextBorderStyle.roundedRect
        return textField
    }()
    
    let txtAge:INTTextField = {
      let txtAge = INTTextField()
        txtAge.borderStyle = UITextBorderStyle.roundedRect
        txtAge.placeholder = "Ingrese edad"
        txtAge.keyboardType = UIKeyboardType.numberPad
      return txtAge
    }()
    
    
    let datePicker:UIDatePicker = {
      let datePicker = UIDatePicker()
      datePicker.datePickerMode = UIDatePickerMode.date
      return datePicker
    }()
    
    let txtBirthday:INTTextField = {
        let textField = INTTextField()
        textField.textColor = UIColor.gray
        textField.borderStyle = UITextBorderStyle.roundedRect
        textField.placeholder = "Ingrese fecha de nacimiento"
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        textField.inputAccessoryView = toolbar
        return textField
    }()
    
    
    
    let btnCreateUser:UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("Crear Usuario", for: .normal)
        button.titleLabel?.font = UIFont.boldINTFont(ofSize: 16)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.INTblue()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        button.tintColor = .white
        button.contentMode = .scaleAspectFit
        
        button.addTarget(self, action: #selector(createUserWithFacebook), for: .touchUpInside)
        return button
        
    }()
    
    func validate() -> Bool {
        if self.txtName.text == ""{
            INTProgress.showAlert(on: self, style: UIAlertControllerStyle.alert,
                                  title: "Error al ingresar datos", message: "Debe ingresar un nombre")
            return false
        }
        if self.txtLastName.text == ""{
            INTProgress.showAlert(on: self, style: UIAlertControllerStyle.alert,
                                  title: "Error al ingresar datos", message: "Debe ingresar su apellido")
            return false
        }
        
        if self.txtAge.text == "" {
            INTProgress.showAlert(on: self, style: UIAlertControllerStyle.alert,
                                  title: "Error al ingresar datos", message: "Debe ingresar su edad")
            
            return false
        }
        if self.txtBirthday.text == ""{
            INTProgress.showAlert(on: self, style: UIAlertControllerStyle.alert,
                                  title: "Error al ingresar datos", message: "Debe ingresar su fecha de cumpleaños")
            return false
        }
        
        if self.dateFormatter.date(from: self.txtBirthday.text ?? "") != nil {
            let birthday = self.dateFormatter.date(from: self.txtBirthday.text!)!
            let now = Date()
            let calendar = Calendar.current
            let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
            let age = ageComponents.year!
            if age != Int(self.txtAge.text!) {
                INTProgress.showAlert(on: self, style: UIAlertControllerStyle.alert,
                                      title: "Error al ingresar datos", message: "Debe ingresar su edad correcta")
                return false
            }
        }
        return true
    }

    @objc func donedatePicker(){
       // let formatter = DateFormatter()
        //formatter.dateFormat = "dd/MM/yyyy"
        self.txtBirthday.text = self.dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @objc func createUserWithFacebook() {
        
        if validate() {
            self.saveUserInFirebase()
        }
        
    }

    func saveUserInFirebase(){
        self.hud.show(in: self.view)
        self.hud.textLabel.text = "Creando Usuario..."
        self.hud.interactionType = .blockAllTouches
        let user = INTUser(name: self.txtName.text!, lastname: self.txtLastName.text!, email: self.email!, fecNac: self.txtBirthday.text! , age:self.txtAge.text!)
        INTDatabaseManager().saveUser(user: user, success: { (state) in
            
        INTProgress.dismissHud(self.hud, text: "Usuario creado", detailText: "\(user.name) tu usuario ha sido creado con exito", delay: 3)
            
        }) { (messagge) in
            INTProgress.dismissHud(self.hud, text: "Error", detailText: "Error al guardar información \(String(describing: messagge))", delay: 3)
        }
    }
   

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        navigationItem.title = "Crear Usuario"
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = false
        self.txtBirthday.inputView = self.datePicker
        setupViews()
    }
    
    fileprivate func setupViews() {
        view.addSubview(txtName)
        view.addSubview(txtLastName)
        view.addSubview(txtAge)
        view.addSubview(txtBirthday)
        view.addSubview(btnCreateUser)
        view.addSubview(imageBackground)
        view.sendSubview(toBack: imageBackground)
        txtAge.delegate = self
        
        txtName.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 40, leftConstant: 20, bottomConstant: 0, rightConstant: 20, widthConstant: 0, heightConstant: 40)
        txtLastName.anchor(txtName.bottomAnchor, left: txtName.leftAnchor, bottom: nil, right: txtName.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        txtAge.anchor(txtLastName.bottomAnchor, left: txtName.leftAnchor, bottom: nil, right: txtName.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)
        
        txtBirthday.anchor(txtAge.bottomAnchor, left: txtName.leftAnchor, bottom: nil, right: txtName.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)

        btnCreateUser.anchor(txtBirthday.bottomAnchor, left: txtName.leftAnchor, bottom: nil, right: txtName.rightAnchor, topConstant: 30, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        //imageview Backgorund
        imageBackground.translatesAutoresizingMaskIntoConstraints = false
        imageBackground.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageBackground.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageBackground.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
    }
    
}

extension CreateUserViewController:UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.txtAge {
            let lenght = string.count
            if lenght + textField.text!.count <= 2{
                return true
            }
        }
        return false
    }
}
