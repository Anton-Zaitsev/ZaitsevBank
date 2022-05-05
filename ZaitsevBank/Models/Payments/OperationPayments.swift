//
//  OperationPayments.swift
//  ZaitsevBank
//
//  Created by Антон Зайцев on 24.04.2022.
//

import Foundation
import UIKit
import PermissionsKit
import CameraPermission
import ContactsPermission
import NotificationPermission

public enum OperationPayments {
    case toClientZaitsevBank // Клиенту ZaitsevBank
    case betweenYour // Между своими
    case transferFromCamera // Перевод по сканеру карты
    case makeCredit // Оформить кредит
    
    case paymentQR // Оплата по QR или штрихкоду
    case education // Образование
    case creditPayment // Оплатить кредит
    
    func OperationPerform(_ controller : PaymentsController) {
        switch self {
        case .toClientZaitsevBank:
            break
        case .betweenYour:
            break
        case .transferFromCamera:
            
            Permission.camera.request {
                
                if (Permission.camera.authorized){
                    controller.navigationController?.isNavigationBarHidden = false;
                    let storyboard = UIStoryboard(name: "TransferMenu", bundle: nil)
                    let storyboardInstance = storyboard.instantiateViewController(withIdentifier: "TransferCamera") as! TransferCameraController
                    controller.navigationController?.pushViewController(storyboardInstance, animated: true)
                }
                else {
                    let controllerPermission = PermissionsKit.dialog([.camera])
                    controllerPermission.dataSource = controller
                    controllerPermission.delegate = controller
                    controllerPermission.present(on: controller)
                }
            }
   
        case .makeCredit:
            break
        case .paymentQR:
            break
        case .education:
            break
        case .creditPayment:
            break
        }
    }

}
