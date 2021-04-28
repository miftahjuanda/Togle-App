//
//  AddTaskViewController.swift
//  Togle App
//
//  Created by Diffa Desyawan on 28/04/21.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var taskTimeTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    let datePicker = UIDatePicker()
    let focusTimePicker = UIPickerView()
    
    var mainScreenProtocol : MainScreenProtocol?
    private var db : FogleDB?
    var dateTime : String?
    
    var focusTimes : [Int] = []
    var focusTime : Int = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDataFocusTime()
        focusTimePicker.delegate = self
        focusTimePicker.dataSource = self
        db = FogleDB()
        createDatePicker()
        createFocusTimePicker()
    }
    
    
    @IBAction func actionBackButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func actionDoneButton(_ sender: Any) {
        let title : String = taskNameTextField.text ?? ""
        let status : String = FogleStatus.todo.rawValue
        let time : String = "\(focusTime)"
        let date : String = dateTime ?? ""
        let note : String = notesTextView.text ?? ""
        
        let fogleModel : FogleModel = FogleModel(title: title, status: status, date: date, time: time, note: note)
        db?.addFogleData(fogleModel: fogleModel)
        self.navigationController?.popToRootViewController(animated: true)
        mainScreenProtocol?.reloadData()
    }
    
    @IBAction func actionChooseIcon(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.backgroundColor = UIColor.white
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(actionDatePickerDone))
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
        
        toolbar.setItems([cancelBtn, doneBtn], animated: true)
        dateTextField.inputAccessoryView = toolbar
        
        dateTextField.inputView = datePicker
        
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = .current
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    func createFocusTimePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.backgroundColor = UIColor.white
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(actionFocusTimeDone))
        
        toolbar.setItems([doneBtn], animated: true)
        taskTimeTextField.inputAccessoryView = toolbar
        taskTimeTextField.inputView = focusTimePicker
    }
    
    @objc func actionFocusTimeDone(){
        taskTimeTextField.text = "\(focusTime) minutes"
        self.view.endEditing(true)
    }
    
    @objc func actionDatePickerCancel(){
        self.view.endEditing(true)
    }
    
    
    @objc func actionDatePickerDone() {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        dateTime = "\(datePicker.date)"
        dateTextField.text = "\(formatter.string(from: datePicker.date))"
        self.view.endEditing(true)
    }
    
    func addDataFocusTime(){
        var startTime : Int = 15
        let maxTime : Int = 185
        
        while startTime != maxTime {
            focusTimes.append(startTime)
            startTime = startTime + 5
        }
    }
    
}

extension AddTaskViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return focusTimes.count
        }
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(focusTimes[row])"
        }
        
        return "Minutes"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if !focusTimes.isEmpty {
            focusTime = focusTimes[row]
        }
    }
    
    
}
