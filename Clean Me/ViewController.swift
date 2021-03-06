//
//  ViewController.swift
//  Clean Me
//
//  Created by Kevin De Koninck on 17/01/2017.
//  Copyright © 2017 Kevin De Koninck. All rights reserved.
//

import Cocoa
import DJProgressHUD_OSX
import STPrivilegedTask
import ITSwitch

class ViewController: NSViewController {
    let blueColor = NSColor.init(red: 45.0/255, green: 135.0/255, blue: 250.0/255, alpha: 0.7)
    
    //MARK: OUTLETS
    @IBOutlet weak var EmptyTrashSize: NSTextField!
    @IBOutlet weak var downloadedMailAttachementsSize: NSTextField!
    @IBOutlet weak var xcodeSize: NSTextField!
    @IBOutlet weak var bashHistorySize: NSTextField!
    @IBOutlet weak var terminalCacheSize: NSTextField!
    @IBOutlet weak var userApplicationLogsSize: NSTextField!
    @IBOutlet weak var userApplicationCacheSize: NSTextField!
    @IBOutlet weak var UserCacheSize: NSTextField!
    @IBOutlet weak var userLogsSize: NSTextField!
    @IBOutlet weak var systemCacheSize: NSTextField!
    @IBOutlet weak var systemLogsSize: NSTextField!
    @IBOutlet weak var UserPreferencesSize: NSTextField!
    @IBOutlet weak var globalTempSize: NSTextField!
    @IBOutlet weak var totalSize: NSTextField!
    @IBOutlet weak var totalText: NSTextField!
    @IBOutlet weak var downloadsFolderSize: NSTextField!
    @IBOutlet weak var spotlightSize: NSTextField!
    @IBOutlet weak var docRevSize: NSTextField!
    
    
    @IBOutlet weak var EmptyTrashSwitch: ITSwitch!
    @IBOutlet weak var downloadedMailAttachementsSwitch: ITSwitch!
    @IBOutlet weak var xcodeSwitch: ITSwitch!
    @IBOutlet weak var bashHistorySwitch: ITSwitch!
    @IBOutlet weak var terminalCacheSwitch: ITSwitch!
    @IBOutlet weak var userApplicationLogsSwitch: ITSwitch!
    @IBOutlet weak var userApplicationCacheSwitch: ITSwitch!
    @IBOutlet weak var UserCacheSwitch: ITSwitch!
    @IBOutlet weak var userLogsSwitch: ITSwitch!
    @IBOutlet weak var systemCacheSwitch: ITSwitch!
    @IBOutlet weak var systemLogsSwitch: ITSwitch!
    @IBOutlet weak var UserPreferencesSwitch: ITSwitch!
    @IBOutlet weak var globalTempSwitch: ITSwitch!
    @IBOutlet weak var downloadsFolderSwitch: ITSwitch!
    @IBOutlet weak var spotlightSwitch: ITSwitch!
    @IBOutlet weak var docRevSwitch: ITSwitch!
    
    
    //MARK: DEFENITIONS
    var cleanMe = CleanMe()
    
    //MARK: APPLICATION FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
    
        EmptyTrashSwitch.checked = true
        downloadedMailAttachementsSwitch.checked = true
        bashHistorySwitch.checked = true
        userApplicationLogsSwitch.checked = true
        userLogsSwitch.checked = true
        
        EmptyTrashSwitch.tintColor = blueColor
        downloadedMailAttachementsSwitch.tintColor = blueColor
        xcodeSwitch.tintColor = blueColor
        bashHistorySwitch.tintColor = blueColor
        terminalCacheSwitch.tintColor = blueColor
        userApplicationLogsSwitch.tintColor = blueColor
        userApplicationCacheSwitch.tintColor = blueColor
        UserCacheSwitch.tintColor = blueColor
        userLogsSwitch.tintColor = blueColor
        systemCacheSwitch.tintColor = blueColor
        systemLogsSwitch.tintColor = blueColor
        UserPreferencesSwitch.tintColor = blueColor
        globalTempSwitch.tintColor = blueColor
        downloadsFolderSwitch.tintColor = blueColor
        spotlightSwitch.tintColor = blueColor
        docRevSwitch.tintColor = blueColor
        
        clearSizes()
        setToolTips()
        
        createAndUpdateSymbolicLinks()
    }
    
    override func awakeFromNib() {
        if self.view.layer != nil {
            let color : CGColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.view.layer?.backgroundColor = color
        }
    }
    
    override func viewWillDisappear() {
        removeSymbolicLinks()
    }
    
    func clearSizes(){
        EmptyTrashSize.stringValue = ""
        downloadedMailAttachementsSize.stringValue = ""
        xcodeSize.stringValue = ""
        bashHistorySize.stringValue = ""
        terminalCacheSize.stringValue = ""
        userApplicationLogsSize.stringValue = ""
        userApplicationCacheSize.stringValue = ""
        UserCacheSize.stringValue = ""
        userLogsSize.stringValue = ""
        systemCacheSize.stringValue = ""
        systemLogsSize.stringValue = ""
        UserPreferencesSize.stringValue = ""
        globalTempSize.stringValue = ""
        totalSize.stringValue = ""
        totalText.stringValue = ""
        downloadsFolderSize.stringValue = ""
        spotlightSize.stringValue = ""
        docRevSize.stringValue = ""
    }
    
    func setToolTips(){
        EmptyTrashSwitch.toolTip = trashToolTip
        downloadedMailAttachementsSwitch.toolTip = mailsToolTip
        xcodeSwitch.toolTip = xcodeToolTip
        bashHistorySwitch.toolTip = bashToolTip
        terminalCacheSwitch.toolTip = terminalToolTip
        userApplicationLogsSwitch.toolTip = userAppLogsTooltip
        userApplicationCacheSwitch.toolTip = userAppCacheToolTip
        UserCacheSwitch.toolTip = userCacheToolTip
        userLogsSwitch.toolTip = userAppLogsTooltip
        systemCacheSwitch.toolTip = systemCacheToolTip
        systemLogsSwitch.toolTip = systemLogsToolTip
        UserPreferencesSwitch.toolTip = userPrefsToolTip
        globalTempSwitch.toolTip = globalTempToolTip
        downloadsFolderSwitch.toolTip = downloadsToolTip
        spotlightSwitch.toolTip = spotlightTooltip
        docRevSwitch.toolTip = docRevTooltip
    }
    
    func createAndUpdateSymbolicLinks(){
        
        removeSymbolicLinks()
        
        //create temp folders for symbolic links to app cache and app logs
        _ = cleanMe.execute(command: "mkdir " + symbolicUserAppLogsPath + " " + symbolicUserAppCachePath, asRoot: false)
        
        //Create symbolic links
        _ = cleanMe.execute(command: "for x in $(ls ~/Library/Containers/); do [ -d ~/Library/Containers/$x/Data/Library/Logs/ ] && ln -s ~/Library/Containers/$x/Data/Library/Logs/ " + symbolicUserAppLogsPath + "$x; done;", asRoot: false)
        _ = cleanMe.execute(command: "for x in $(ls ~/Library/Containers/); do [ -d ~/Library/Containers/$x/Data/Library/Caches/ ] && ln -s ~/Library/Containers/$x/Data/Library/Caches/ " + symbolicUserAppCachePath + "$x; done;", asRoot: false)
    }
    
    func removeSymbolicLinks(){
        _ = cleanMe.execute(command: "rm -rf " + symbolicUserAppLogsPath + " " + symbolicUserAppCachePath, asRoot: false)
    }
    
    
    
    //MARK: POPUPS

    func showOKPopUp(title: String, text: String) {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = title
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.warning
        myPopup.addButton(withTitle: "OK")
        myPopup.runModal()

    }
    
    func popUpOKCancel(question: String, text: String, firstBtn: String, secondBtn: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = question
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlertStyle.critical
        myPopup.addButton(withTitle: firstBtn)
        myPopup.addButton(withTitle: secondBtn)
        return myPopup.runModal() == NSAlertFirstButtonReturn
    }
    
    
    
    //MARK: ACTIONS
    @IBAction func openBtnClicked(_ sender: NSButton) {
        cleanMe.openInFinder(Path: PATHkey[sender.tag])
    }

    @IBAction func cleanBtnClicked(_ sender: Any) {
        defer {
            DJProgressHUD.dismiss()
            createAndUpdateSymbolicLinks() //Recreate symbolic links for app chache and logs
        }
        
        // Check all switches
        var PathKeys = [Int]()
        if(EmptyTrashSwitch.checked){ PathKeys.append(0) }
        if(downloadedMailAttachementsSwitch.checked){ PathKeys.append(1) }
        if(xcodeSwitch.checked){ PathKeys.append(2) }
        if(bashHistorySwitch.checked){ PathKeys.append(3) }
        if(terminalCacheSwitch.checked){ PathKeys.append(4) }
        if(userApplicationLogsSwitch.checked){ PathKeys.append(5) }
        if(userApplicationCacheSwitch.checked){ PathKeys.append(6) }
        if(UserCacheSwitch.checked){ PathKeys.append(7) }
        if(userLogsSwitch.checked){ PathKeys.append(8) }
        if(systemCacheSwitch.checked){ PathKeys.append(9) }
        if(systemLogsSwitch.checked){ PathKeys.append(10) }
        if(globalTempSwitch.checked){ PathKeys.append(11) }
        if(UserPreferencesSwitch.checked){ PathKeys.append(12) }
        if(downloadsFolderSwitch.checked){ PathKeys.append(13) }
        if(spotlightSwitch.checked){ PathKeys.append(14) }
        if(docRevSwitch.checked){ PathKeys.append(15) }
        
        // Check for empty array (see GitHub Issue #4)
        if(PathKeys.count == 0){
            DJProgressHUD.showStatus("Eurgh...", from: self.view)
            showOKPopUp(title: "Whoops...", text: "You didn't select anything...")
            return
        }
        
        // Check if a user wants to continue
        if(popUpOKCancel(question: "CAUTION", text: "Are you sure you want to continue?\n\nClean Me uses the command 'rm -rf folder_name' to clean out your system. With this, there is no undo button (files will be deleted immediately instead of going to the Trash).", firstBtn: "Cancel", secondBtn: "I understand")){
            return
        }
        
        DJProgressHUD.showStatus("Cleaning", from: self.view)
        
        clearSizes()
        
        let diskSizeBeforeInMB = Int(cleanMe.getSizeOfUsedDiskSpaceInMB().replacingOccurrences(of: "\n", with: ""))!

        // Do the cleaning
        cleanMe.deleteItems(checkedItemsArray: PathKeys)
    
    
        // Display results
        DJProgressHUD.showStatus("Finishing", from: self.view)
        var sizeCleanedInMB = Int(cleanMe.getSizeOfUsedDiskSpaceInMB().replacingOccurrences(of: "\n", with: ""))! - diskSizeBeforeInMB
        let sizeCleanedInGB = Double(round(Double(sizeCleanedInMB) / 1024.0 * 100)/100)
        
        if(sizeCleanedInMB < 0) { sizeCleanedInMB = 0 }
        var popUpText = ""
        if (sizeCleanedInMB  < 1025){
            popUpText = "\(sizeCleanedInMB) MB"
        } else {
            popUpText = "\(sizeCleanedInMB) MB (roughly \(sizeCleanedInGB) GB)"
        }
        showOKPopUp(title: "Success!", text: "Total of " + popUpText + " cleaned.")
    }
    
    @IBAction func AnalyzeBtnClicked(_ sender: NSButton) {
        DJProgressHUD.showStatus("Analyzing", from: self.view)
        defer {
            DJProgressHUD.dismiss()
        }
        
        clearSizes()
        cleanMe.calculateSizes()
        
        EmptyTrashSize.stringValue = processSize(sizeInMB: cleanMe.sizesMB["trash"]!)
        downloadedMailAttachementsSize.stringValue = processSize(sizeInMB: cleanMe.sizesMB["mails"]!)
        xcodeSize.stringValue = processSize(sizeInMB: cleanMe.sizesMB["xcode"]!)
        bashHistorySize.stringValue = processSize(sizeInMB: cleanMe.sizesMB["bash"]!)
        terminalCacheSize.stringValue = processSize(sizeInMB: cleanMe.sizesMB["terminal"]!)
        userApplicationLogsSize.stringValue =  processSize(sizeInMB: cleanMe.sizesMB["userAppLogs"]!)
        userApplicationCacheSize.stringValue = processSize(sizeInMB: cleanMe.sizesMB["userAppCache"]!)
        UserCacheSize.stringValue = processSize(sizeInMB: cleanMe.sizesMB["userCache"]!)
        userLogsSize.stringValue = processSize(sizeInMB: cleanMe.sizesMB["userLogs"]!)
        systemCacheSize.stringValue = processSize(sizeInMB: cleanMe.sizesMB["systemCache"]!)
        systemLogsSize.stringValue = processSize(sizeInMB: cleanMe.sizesMB["systemLogs"]!)
        UserPreferencesSize.stringValue = processSize(sizeInMB: cleanMe.sizesMB["userPrefs"]!)
        globalTempSize.stringValue = processSize(sizeInMB: cleanMe.sizesMB["globalTemp"]!)
        downloadsFolderSize.stringValue = processSize(sizeInMB: cleanMe.sizesMB["downloads"]!)
        spotlightSize.stringValue = processSize(sizeInMB: cleanMe.sizesMB["spotlight"]!)
        docRevSize.stringValue = processSize(sizeInMB: cleanMe.sizesMB["docRev"]!)
        
        totalText.stringValue = "TOTAL:"
        
        totalSize.stringValue = processSize(sizeInMB: cleanMe.sizesMB["TOTAL"]!)
    }
    
    func convertMBtoGBAndRoundTo2DigitsAfterComma(sizeInMB: String) -> Double {
        return Double(round(Double(sizeInMB)!/1024.0 * 100)/100)
    }
    
    func processSize(sizeInMB: String) -> String {
        if(Double(sizeInMB)! > 1024){
            return "\(convertMBtoGBAndRoundTo2DigitsAfterComma(sizeInMB: sizeInMB)) GB"
        } else {
            return "\(sizeInMB) MB"
        }
    }
 
}
