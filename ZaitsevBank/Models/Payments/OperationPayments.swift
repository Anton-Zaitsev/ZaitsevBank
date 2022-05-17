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
    
    case buyValute // Купить валюту
    case saleValute // Продать валюту
    case creditPayment // Оплатить кредит
    
    func OperationPerform(_ controller : PaymentsController) {
        switch self {
        case .toClientZaitsevBank:
            Permission.contacts.request {
                if (Permission.contacts.authorized){
                    controller.navigationController?.isNavigationBarHidden = false
                    let storyboard = UIStoryboard(name: "TransferMenu", bundle: nil)
                    let storyboardInstance = storyboard.instantiateViewController(withIdentifier: "TransferZaitsevClient") as! TransferZaitsevClientController
                    controller.navigationController?.pushViewController(storyboardInstance, animated: true)
                }
                else {
                    let controllerPermission = PermissionsKit.dialog([.contacts])
                    controllerPermission.dataSource = controller
                    controllerPermission.delegate = controller
                    controllerPermission.present(on: controller)
                }
            }
            break
        case .betweenYour:
            controller.navigationController?.isNavigationBarHidden = false
            let storyboard = UIStoryboard(name: "TransferMenu", bundle: nil)
            let storyboardInstance = storyboard.instantiateViewController(withIdentifier: "TransferBetween") as! TransferBetweenController
            controller.navigationController?.pushViewController(storyboardInstance, animated: true)
            break
        case .transferFromCamera:
            Permission.camera.request {
                
                if (Permission.camera.authorized){
                    controller.navigationController?.isNavigationBarHidden = false
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
        case .buyValute:
            controller.navigationController?.isNavigationBarHidden = false
            let storyboardValuteMenuMenu : UIStoryboard = UIStoryboard(name: "ValuteMenu", bundle: nil)
            let ExhangeRate = storyboardValuteMenuMenu.instantiateViewController(withIdentifier: "ExhangeAllValute") as! ExchangeRateController
            controller.navigationController?.pushViewController(ExhangeRate, animated: true)
            break
        case .saleValute:
            controller.navigationController?.isNavigationBarHidden = false
            let storyboardValuteMenuMenu : UIStoryboard = UIStoryboard(name: "ValuteMenu", bundle: nil)
            let ExhangeRate = storyboardValuteMenuMenu.instantiateViewController(withIdentifier: "ExhangeAllValute") as! ExchangeRateController
            controller.navigationController?.pushViewController(ExhangeRate, animated: true)
            break
        case .creditPayment:
            break
        }
    }

}
