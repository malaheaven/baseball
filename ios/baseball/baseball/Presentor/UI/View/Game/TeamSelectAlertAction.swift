//
//  TeamSelectAlertAction.swift
//  baseball
//
//  Created by zombietux on 2021/05/12.
//

import UIKit

struct TeamSelectAlertAction {
    var title: String
    var style: UIAlertAction.Style
    
    static func action(title: String, style: UIAlertAction.Style = .default) -> TeamSelectAlertAction {
        return TeamSelectAlertAction(title: title, style: style)
    }
}
