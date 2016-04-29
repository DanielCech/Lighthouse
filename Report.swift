//
//  Report.swift
//  Lighthouse
//
//  Created by Dan on 02.12.15.
//  Copyright © 2015 STRV. All rights reserved.
//

import UIKit

enum ReportType {
	case Info
	case Warning
	case Error
}


protocol HandlingBlock {
	func handle(context: Report) -> Report
}

struct Report {

	var type: ReportType?

	var title: String?
	var message: String?
	var attributedMessage: NSAttributedString?

	var error: NSError?
	var errorContext: Any?

	var silentDismiss: Bool = false
	var canBeSupressed: Bool = false

	var confirmHandler: (() -> Void)?
	var cancelHandler: (() -> Void)?
	var retryHandler: (() -> Void)?

    var breakpoint: Bool
    
	var fileName: String?
    var lineNumber: Int?
	var functionName: String?



	init(
		type: ReportType = .Info,
		title: String? = "",
		message: String? = "",
		attributedMessage: NSAttributedString? = nil,
		error: NSError? = nil,
		errorContext: Any? = nil,
		silentDismiss: Bool = false,
		canBeSupressed: Bool = false,
		confirmHandler: (() -> Void)? = nil,
		cancelHandler: (() -> Void)? = nil,
		retryHandler: (() -> Void)? = nil,
        fileName: String? = nil,
        lineNumber: Int? = nil,
        breakpoint: Bool = false,
        functionName: String? = nil
	) {

		self.type = type

		self.title = title
		self.message = message
		self.attributedMessage = attributedMessage

		self.error = error
		self.errorContext = errorContext

		self.silentDismiss = silentDismiss
		self.canBeSupressed = canBeSupressed

		self.confirmHandler = confirmHandler
		self.cancelHandler = cancelHandler
		self.retryHandler = retryHandler
        
        self.breakpoint = breakpoint

        self.fileName = fileName
        self.lineNumber = lineNumber
        self.functionName = functionName

	}

    func debugInfo() -> String
    {
        if (fileName == nil) || (lineNumber == nil) || (functionName == nil) {
            return ""
        }

        return "[\(NSString(string: fileName!).lastPathComponent):\(lineNumber!)] \(functionName!)"
    }

}
