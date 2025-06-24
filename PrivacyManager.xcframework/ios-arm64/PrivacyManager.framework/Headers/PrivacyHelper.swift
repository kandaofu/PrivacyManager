//
//   PrivacyHelper.swift
//   PrivacyManager
//
//   Created by Apple on 2025/6/20
//   
//
   

import UIKit

public class PrivacyHelper: NSObject {
    
    /// open  system setting page
    public static func openSettingAlert(title:String,message:String="",buttonText:String="OK",hasCancelButton:Bool = false){
        PrivacyRouter.shared.showPermissionAlert(title: title, message: message, buttonText: buttonText,hasCancel: hasCancelButton)
    }
    
    /// getImage form ablum or camera
    public static func getPhoto(inViewController vc:UIViewController,result:@escaping((_ image:UIImage)->Void)){
        PhotoPickerHelper.present(from: vc) { image in
            result(image)
        }
    }
    
    /// getContactinfo fullName & phoneNumber
    public static func getContactInfo(inViewController vc:UIViewController,result:@escaping((_ fullName:String?,_ phoneNumber:String?)->Void)){
        ContactHelper.shared.present(from: vc) { fullName, phoneNumber in
            result(fullName,phoneNumber)
        }
    }
    
    /// check Location authorizationStatus
    /// If you don't have permission, the pop-up window will jump to the settings page
    public static func checkLocation(alertTitle:String="",alertMessage:String="For a better experience, please turn on location permissions in settings.",alertButtonText:String="OK",didAuthorized:@escaping(()->Void)){
        PrivacyRouter.shared.checkLocation(title: alertTitle, message: alertMessage, buttonText: alertButtonText, authorizedBlock: didAuthorized)
    }

    /// check Camera authorizationStatus
    ///  If you don't have permission, the pop-up window will jump to the settings page
    public static func checkCamera(alertTitle:String="",alertMessage:String="No camera permission, please turn it on in settings",alertButtonText:String="OK",didAuthorized:@escaping(()->Void)){
        PrivacyRouter.shared.checkCamera(title: alertTitle, message: alertMessage, buttonText: alertButtonText, authorizedBlock: didAuthorized)
    }
    
    
}
