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
    @IBOutlet weak var uinav: UINavigationItem!

    let datePicker = UIDatePicker()
    let focusTimePicker = UIPickerView()
    
    var mainScreenProtocol : MainScreenProtocol?
    private var db : FogleDB?
    
    var focusTimes : [Int] = []
    var focusTime : Int = 15
    
    var isEdit : Bool = false
    var editData : FogleModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isEdit {
            setData()
        }
        
        addDataFocusTime()
        focusTimePicker.delegate = self
        focusTimePicker.dataSource = self
        db = FogleDB()
        createDatePicker()
        createFocusTimePicker()
    }
    
    func setData(){
        uinav.title = "Edit Task"
        taskTimeTextField.text = convertToMinutesAndSecond(totalSecond: Int(editData?.targetTime ?? 0))
        taskNameTextField.text = editData?.title ?? ""
        dateTextField.text = editData?.date ?? ""
        notesTextView.text = editData?.note ?? ""
        
    }
    
    
    @IBAction func actionBackButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func actionDoneButton(_ sender: Any) {

        let title : String = taskNameTextField.text ?? ""
        let status : String = FogleStatus.todo.rawValue
        let currentTime : Int64 = 0
        let targetTime : Int64 = Int64(focusTime * 60)
        let date : String = formatDate()
        let note : String = notesTextView.text ?? ""
        
        let taskTime : String = taskTimeTextField.text ?? ""
        let dateText : String = dateTextField.text ?? ""
        if !title.isEmpty && !taskTime.isEmpty && !dateText.isEmpty{
            if isEdit{
            
                let id : String =  editData?.id ?? ""
                
                let fogleModel : FogleModel = FogleModel(id: id ,title: title, status: status, date: date, currentTime: currentTime, targetTime: targetTime, note: note, result: FogleResult.none.rawValue)
                db?.editFogleData(fogleModel: fogleModel)
                setReminder(fogle: fogleModel)
                
                self.navigationController?.popToRootViewController(animated: true)
                mainScreenProtocol?.reloadData()
            } else {
                let fogleModel : FogleModel = FogleModel(title: title, status: status, date: date, currentTime: currentTime, targetTime: targetTime, note: note, result: FogleResult.none.rawValue)
                db?.addFogleData(fogleModel: fogleModel)
                setReminder(fogle: fogleModel)

                self.navigationController?.popToRootViewController(animated: true)
                mainScreenProtocol?.reloadData()

            }
            
        }
        else {
            print("Masih Kosong")
            alertButton(title: "Ooppss!", message: "Check for empty input field", completion: {
                alertController in
                
                let cancelAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func actionChooseIcon(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.backgroundColor = UIColor.white
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(actionDatePickerDone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(actionDatePickerCancel))
        
        toolbar.setItems([cancelBtn, spaceButton, doneBtn], animated: true)
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
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelBtn = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(actionDatePickerCancel))

        
        toolbar.setItems([cancelBtn, spaceButton, doneBtn], animated: true)
        taskTimeTextField.inputAccessoryView = toolbar
        taskTimeTextField.inputView = focusTimePicker
    }
    
    @objc func actionFocusTimeDone(){
        taskTimeTextField.text = "\(focusTime) minutes"
        self.view.endEditing(true)
    }
    
    @objc func actionDatePickerCancel(){
        view.endEditing(true)
    }
    
    
    @objc func actionDatePickerDone() {
        dateTextField.text = "\(formatDate())"
        self.view.endEditing(true)
    }
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        return formatter.string(from: datePicker.date)
    }
    
    func addDataFocusTime(){
        var startTime : Int = 15
        let maxTime : Int = 185
        
        while startTime != maxTime {
            focusTimes.append(startTime)
            startTime = startTime + 5
        }
    }
    
    func setReminder(fogle : FogleModel){
        let content = UNMutableNotificationContent()
        content.title = fogle.title
        content.sound = .default
        content.body = fogle.note
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: datePicker.date.addingTimeInterval(5)), repeats: false)
        
        let request = UNNotificationRequest(identifier: "\(fogle.id)", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            error in
            
            if error != nil {
                print("Some error : \(error)")
            }
        })
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
