//
//
//  CalendarBug
//
//  Created by Swift on 25.11.2017.
//  Copyright © 2017 Swift. All rights reserved.
//

import  UIKit
import JTAppleCalendar

class CellView: JTAppleCell {
    @IBOutlet var selectedView: UIView!
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var tagList: TagListView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
    }
    
    
}
