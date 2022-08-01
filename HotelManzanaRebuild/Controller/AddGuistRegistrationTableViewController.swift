//
//  GuistRegistrationTableViewController.swift
//  HotelManzanaRebuild
//
//  Created by Ahmed Yamany on 31/07/2022.
//

import UIKit


protocol RoomTypeTableViewControllerDelegate{
    func roomTypeTableViewController(controller: RoomTypeTableViewController, roomType: RoomType?)
}
class AddGuistRegistrationTableViewController: UITableViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    // Basic Informatiom Section
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    // Registraion Date Section
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    // Number Of Guists Section
    @IBOutlet weak var adultsNumberLabel: UILabel!
    @IBOutlet weak var adultsNumebrSteper: UIStepper!
    @IBOutlet weak var cheldrinNumberLabel: UILabel!
    @IBOutlet weak var cheldrinNumberSteper: UIStepper!
    // Wi-Fi Section
    @IBOutlet weak var wifiSwitcher: UISwitch!
    // Room Type Section
    @IBOutlet weak var roomTypeLabel: UILabel!
    // Chargers section
    // Number Of Nights
    @IBOutlet weak var numberOfDaysLabel: UILabel!
    @IBOutlet weak var numberOfDaysDate: UILabel!
    // Roome Type
    @IBOutlet weak var roomTypeTotalPrice: UILabel!
    @IBOutlet weak var selectedRoomTypeInformation: UILabel!
    // Wi-Fi
    @IBOutlet weak var wifiTotalPrice: UILabel!
    @IBOutlet weak var wifiStatus: UILabel!
    // registration Total Price
    @IBOutlet weak var RegistraiontotalPrice: UILabel!
    
    
    // MARK: - vars
    var delegate: AddGuistRegistrationTableViewControllerDelegate?
    var roomType: RoomType?
    var registration: Registration?
    
    // datePicker cells indexPath
    let indexPathForCheckInLabel = IndexPath(row: 0, section: 1)
    let indexPathForCheckInPicker = IndexPath(row: 1, section: 1)
    let indexPathForCheckOutLabel = IndexPath(row: 2, section: 1)
    let indexPathForCheckOutPicker = IndexPath(row: 3, section: 1)
    
    // datePicker is visible
    var checkInPickerIsvisible = false{
        didSet{
            checkInDatePicker.isHidden = !checkInPickerIsvisible
        }
    }
    var checkOutPickerIsvisible = false{
        didSet{
            checkOutDatePicker.isHidden = !checkOutPickerIsvisible
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday

        updateViews()
        updateDateView()
        updateGuistsSteperLabels()
        updateRoomTypeLabel()
        updateChargers()
        updateDoneBtn()


    }
    
    // MARK: - IBActions
    
    @IBAction func doneBtnPressed(_ sender: UIBarButtonItem) {
        let firstName = firstNameTF.text ?? ""
        let lastName = lastNameTF.text ?? ""
        let email = emailTF.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let adultsNumber = Int(adultsNumebrSteper.value)
        let cheldrenNumber = Int(cheldrinNumberSteper.value)
        let hasWifi = wifiSwitcher.isOn
        let roomType = self.roomType!
        if self.registration == nil {
            
        self.registration = Registration(firstName: firstName, lastName: lastName, email: email, checkInDate: checkInDate, checkOutDate: checkOutDate, numberOfAdults: adultsNumber, numberOfChildren: cheldrenNumber, wifi: hasWifi, roomType: roomType)
        }else{
            self.registration?.firstName = firstName
            self.registration?.lastName = lastName
            self.registration?.email = email
            self.registration?.checkInDate = checkInDate
            self.registration?.checkOutDate = checkOutDate
            self.registration?.numberOfAdults = adultsNumber
            self.registration?.numberOfChildren = cheldrenNumber
            self.registration?.wifi = hasWifi
            self.registration?.roomType = roomType
            
        }
        
        self.delegate?.addGuistRegistrationTableViewController(controller: self, registration: self.registration!)
        dismiss(animated: true)
    }
    
    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true) {
            self.delegate?.deselectTabelRow()

        }
    }
    
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDateView()
        updateChargers()
    }
    
    @IBAction func gustsSteperChanged(_ sender: UIStepper) {
        updateGuistsSteperLabels()
        updateDoneBtn()
    }
    
    
    @IBAction func wifiSwiterTapped(_ sender: UISwitch) {
        updateChargers()
    }
    // MARK: - HelperFunction
    func updateDoneBtn(){
        doneBtn.isEnabled = self.roomType != nil && adultsNumebrSteper.value > 0 && cheldrinNumberSteper.value > 0
    }
    
    func updateDateView(){
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)
        
        checkInDateLabel.text = checkInDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        
        checkOutDateLabel.text = checkOutDatePicker.date.formatted(date: .abbreviated, time: .omitted)
    }
    
    func updateGuistsSteperLabels(){
        adultsNumberLabel.text = "\(Int(adultsNumebrSteper.value))"
        cheldrinNumberLabel.text = "\(Int(cheldrinNumberSteper.value))"
    }
    
    func updateViews(){
        if let registration = self.registration {
            firstNameTF.text = registration.firstName
            lastNameTF.text = registration.lastName
            emailTF.text = registration.email
            checkInDatePicker.date = registration.checkInDate
            checkOutDatePicker.date = registration.checkOutDate
            adultsNumebrSteper.value = Double(registration.numberOfAdults)
            cheldrinNumberSteper.value = Double(registration.numberOfChildren)
            wifiSwitcher.isOn = registration.wifi
            self.roomType = registration.roomType
            
        
        }
    }
    
    func updateRoomTypeLabel(){
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
        }else{
            roomTypeLabel.text = "Not Set"
        }
    }
    
    
    func updateChargers(){
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        
        // count days between checkin and checkout dates
        let calendar = Calendar.current
        let date1 = calendar.startOfDay(for: checkInDate)
        let date2 = calendar.startOfDay(for: checkOutDate)

        let components = calendar.dateComponents([.day], from: date1, to: date2)
        
        // change number of nights
        numberOfDaysLabel.text = "\(components.day ?? 0)"
        numberOfDaysDate.text = "\(checkInDate.formatted(date: .numeric, time: .omitted)) - \(checkOutDate.formatted(date: .numeric, time: .omitted))"
        
        // change room type
        let roomTypePrice = (roomType?.price ?? 0) * (components.day ?? 0)
        
        roomTypeTotalPrice.text = "\(roomTypePrice)"
        
        var roomTypetotalString: String {
            
            guard let name = roomType?.name, let price = roomType?.price else{return ""}
                    
            return "\(name) @ $\(price)/night"
        }
        selectedRoomTypeInformation.text = roomTypetotalString

            
        // change wifi
        var wifiPrice: Int?
        if wifiSwitcher.isOn{
            wifiPrice = (components.day ?? 0) * 10
            wifiTotalPrice.text = "$ \(wifiPrice!)"
            wifiStatus.text = "Yes"
            
        }else{
            wifiTotalPrice.text = "0"
            wifiStatus.text = "No"
        }
        
        RegistraiontotalPrice.text = "$ \(roomTypePrice + (wifiPrice ?? 0))"
        
       
        
    }
    
    // MARK: - tableview delegates
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath{
            // hide checkIn cell
            case indexPathForCheckInPicker where checkInPickerIsvisible == false:
                return 0
            // hide checkOut cell
            case indexPathForCheckOutPicker where checkOutPickerIsvisible == false:
                return 0
        
            default:
                // automatic dimension for other cells
                return UITableView.automaticDimension
            
    }

    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath{
        case indexPathForCheckInLabel:
            // toggle visibilty
            checkInPickerIsvisible.toggle()
            if checkOutPickerIsvisible{
                checkOutPickerIsvisible.toggle()
            }
        case indexPathForCheckOutLabel:
            checkOutPickerIsvisible.toggle()
            if checkInPickerIsvisible{
                checkInPickerIsvisible.toggle()
            }
        case IndexPath(row: 0, section: 4):
            let RoomTypeVC = storyboard?.instantiateViewController(withIdentifier: "RoomTypeVC") as! RoomTypeTableViewController
            RoomTypeVC.roomType = self.roomType
            RoomTypeVC.delegate = self
            
            navigationController?.pushViewController(RoomTypeVC, animated: true)
            
        default:
            print("")
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }


}


extension AddGuistRegistrationTableViewController: RoomTypeTableViewControllerDelegate{
    func roomTypeTableViewController(controller: RoomTypeTableViewController, roomType: RoomType?) {
        self.roomType = roomType
        updateRoomTypeLabel()
        updateChargers()
        updateDoneBtn()
        
    }
    
    
}

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}
