//
//  CustomCells.swift
//  SampleUI
//
//  Created by Jason Yeoh on 05/09/2019.
//  Copyright © 2019 Jason Yeoh. All rights reserved.
//

import Foundation
import UIKit
import Eureka

public enum WeekDay {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
}

public class WeekDayCell : Cell<Set<Day>>, CellType {
    
    @IBOutlet var sundayButton: UIButton!
    @IBOutlet var mondayButton: UIButton!
    @IBOutlet var tuesdayButton: UIButton!
    @IBOutlet var wednesdayButton: UIButton!
    @IBOutlet var thursdayButton: UIButton!
    @IBOutlet var fridayButton: UIButton!
    @IBOutlet var saturdayButton: UIButton!
    
    open override func setup() {
        height = { 60 }
        row.title = nil
        super.setup()
        selectionStyle = .none
        for subview in contentView.subviews {
            if let button = subview as? UIButton {
                button.setImage(UIImage(named: "checkedDay"), for: .selected)
                button.setImage(UIImage(named: "uncheckedDay"), for: .normal)
                button.adjustsImageWhenHighlighted = false
                imageTopTitleBottom(button)
            }
        }
    }
    
    open override func update() {
        row.title = nil
        super.update()
        let value = row.value
        mondayButton.isSelected = value?.contains(.Monday) ?? false
        tuesdayButton.isSelected = value?.contains(.Tuesday) ?? false
        wednesdayButton.isSelected = value?.contains(.Wednesday) ?? false
        thursdayButton.isSelected = value?.contains(.Thursday) ?? false
        fridayButton.isSelected = value?.contains(.Friday) ?? false
        saturdayButton.isSelected = value?.contains(.Saturday) ?? false
        sundayButton.isSelected = value?.contains(.Sunday) ?? false
        
        mondayButton.alpha = row.isDisabled ? 0.6 : 1.0
        tuesdayButton.alpha = mondayButton.alpha
        wednesdayButton.alpha = mondayButton.alpha
        thursdayButton.alpha = mondayButton.alpha
        fridayButton.alpha = mondayButton.alpha
        saturdayButton.alpha = mondayButton.alpha
        sundayButton.alpha = mondayButton.alpha
    }
    
    @IBAction func dayTapped(_ sender: UIButton) {
        dayTapped(sender, day: getDayFromButton(sender))
    }
    
    private func getDayFromButton(_ button: UIButton) -> Day{
        switch button{
        case sundayButton:
            return .Sunday
        case mondayButton:
            return .Monday
        case tuesdayButton:
            return .Tuesday
        case wednesdayButton:
            return .Wednesday
        case thursdayButton:
            return .Thursday
        case fridayButton:
            return .Friday
        default:
            return .Saturday
        }
    }
    
    private func dayTapped(_ button: UIButton, day: Day){
        button.isSelected = !button.isSelected
        if button.isSelected{
            row.value?.insert(day)
        }
        else{
            _ = row.value?.remove(day)
        }
    }
    
    private func imageTopTitleBottom(_ button : UIButton){
        
        guard let imageSize = button.imageView?.image?.size else { return }
        let spacing : CGFloat = 3.0
        button.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
        guard let titleLabel = button.titleLabel, let title = titleLabel.text else { return }
        let titleSize = title.size(withAttributes: [.font: titleLabel.font!])
        button.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
    }
}

public final class WeekDayRow: Row<WeekDayCell>, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<WeekDayCell>(nibName: "WeekDaysCell")
    }
}


//public class CustomCell: Cell<Bool>, CellType {
//    @IBOutlet weak var button1: UIButton!
//    @IBOutlet weak var button2: UIButton!
//    @IBOutlet weak var button3: UIButton!
//
//    public override func setup() {
//        super.setup()
//        switchControl.addTarget(self, action: #selector(CustomCell.switchValueChanged), for: .valueChanged)
//    }
//
//    func switchValueChanged(){
//        row.value = switchControl.on
//        row.updateCell() // Re-draws the cell which calls 'update' bellow
//    }
//
//    public override func update() {
//        super.update()
//        backgroundColor = (row.value ?? false) ? .white : .black
//    }
//}
//
//// The custom Row also has the cell: CustomCell and its correspond value
//public final class CustomRow: Row<CustomCell>, RowType {
//    required public init(tag: String?) {
//        super.init(tag: tag)
//        // We set the cellProvider to load the .xib corresponding to our cell
//        cellProvider = CellProvider<CustomCell>(nibName: "CustomCell")
//    }
//}
