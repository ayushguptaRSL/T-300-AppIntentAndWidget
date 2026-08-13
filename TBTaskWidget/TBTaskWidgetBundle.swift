//
//  TBTaskWidgetBundle.swift
//  TBTaskWidget
//
//  Created by Raja Software Labs on 11/08/26.
//

import WidgetKit
import SwiftUI

@main
struct TBTaskWidgetBundle: WidgetBundle {
    var body: some Widget {
        TBTaskWidget()
        TBTaskWidgetLiveActivity()
    }
}
