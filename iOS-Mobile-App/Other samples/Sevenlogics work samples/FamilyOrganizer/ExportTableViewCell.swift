//
//  ExportTableViewCell.swift
//  FamilyOrganizer
//
//  Created by James Sun on 7/7/16.
//  Copyright © 2016 Sevenlogics. All rights reserved.
//

import Foundation

class ExportTableViewCell: UITableViewCell
{
    @IBOutlet var nameLabel:UILabel?
    @IBOutlet var valueTextField:UITextField?
    @IBOutlet var valueSwitch:UISwitch?
    @IBOutlet var valueLabel:UILabel?
    @IBOutlet var iconImage:UIImageView?
    
    var bottomDividerView:UIView?
    
    let PADDING = 25.0 as CGFloat
    
    var showBottomDivider:Bool! = false
    
    func layoutBottomDivider(tableSections:NSArray,indexPath:NSIndexPath)
    {
        let tableViewSection = tableSections[indexPath.section] as! TableViewSection
        
        self.showBottomDivider = ((tableViewSection.data.count - 1) == indexPath.row)
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clearColor()
        self.nameLabel?.textColor = GRAY_2_COLOR
        
        self.valueLabel?.textColor = VALUE_BASE_COLOR
        self.valueTextField?.textColor = VALUE_BASE_COLOR
        self.valueSwitch?.onTintColor = CALENDAR_BASE_COLOR
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        if nil != self.valueTextField
        {
            ViewHelper.view(self.valueTextField, setX: CGRectGetWidth(self.frame) - CGRectGetWidth(self.valueTextField!.frame) - PADDING)
        }
        
        if nil != self.valueLabel
        {
            ViewHelper.view(self.valueLabel, setX: CGRectGetWidth(self.frame) - CGRectGetWidth(self.valueLabel!.frame) - PADDING)
        }
        
        if nil != self.valueSwitch
        {
            ViewHelper.view(self.valueSwitch, setX: CGRectGetWidth(self.frame) - CGRectGetWidth(self.valueSwitch!.frame) - PADDING)
        }
        
        ViewHelper.view(self.nameLabel, setX:PADDING)
        
        if self.iconImage != nil
        {
            self.contentView.addSubview(self.iconImage!)
        }
        
        if self.showBottomDivider!
        {
            if nil == self.bottomDividerView
            {
                self.bottomDividerView = UIView(frame: CGRectMake(0, 0, self.contentView.frame.size.width, 1.0))
                
                self.bottomDividerView!.backgroundColor = UIColor.clearColor()
                
                //let lineView = UIView(frame:CGRectMake(0, 0, self.contentView.frame.size.width - 30.0, 1.0))
                let lineView = UIView(frame:CGRectMake(0, 0, self.contentView.frame.size.width + 10.0, 1.0))
                lineView.backgroundColor = UIColor(white: 0.0, alpha: 0.1)
                
                self.bottomDividerView!.addSubview(lineView)
                ViewHelper.view(lineView, setX:30.0)
                
                self.contentView.addSubview(self.bottomDividerView!)
            }
            
            self.bottomDividerView?.hidden = false
            
            ViewHelper.view(self.bottomDividerView!, setY: CGRectGetMaxY(self.contentView.frame) - CGRectGetHeight(self.bottomDividerView!.frame))
        }
        else
        {
            self.bottomDividerView?.hidden = true
        }
    }
}