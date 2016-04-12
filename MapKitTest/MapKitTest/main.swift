//
//  main.swift
//  MapKitTest
//
//  Created by snqu-ios on 16/4/12.
//  Copyright © 2016年 snqu-ios. All rights reserved.
//

import Foundation
import UIKit

class MyApplication: UIApplication {
    
    override func sendEvent(event: UIEvent) {
        super.sendEvent(event)
//        print("Event sent: \(event)")
    }
}



UIApplicationMain(Process.argc, Process.unsafeArgv, NSStringFromClass(MyApplication), NSStringFromClass(AppDelegate))
