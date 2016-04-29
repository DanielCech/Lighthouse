//
//  Lighthouse.swift
//  Lighthouse
//
//  Created by Dan on 09.11.15.
//  Copyright © 2015 STRV. All rights reserved.
//

import UIKit
import Crashlytics


class Lighthouse: NSObject {


    class var sharedInstance: Lighthouse
    {
        struct Static {
            static var instance: Lighthouse?
            static var token: dispatch_once_t = 0
        }

        dispatch_once(&Static.token) {
            Static.instance = Lighthouse()
        }

        return Static.instance!
    }


//    //
//    var defaultReport: Report?
//
//
//
//    func defaultHandleNetworkError() {
////        defaultReport = Report()
//    }

    func defaultHandleLoginError() {

    }

    ////////////////////////////////////////////////////////////////
    // MARK: - Public API

    class func reportInfo(message: String, silentDismiss: Bool = false, breakpoint: Bool = false, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line)
    {
        Lighthouse.present(Report(
            type: .Info,
            title: "Info",
            message: message,
            silentDismiss: silentDismiss,
            functionName: functionName,
            fileName: fileName,
            lineNumber: lineNumber,
            breakpoint: breakpoint),

            functionName: functionName,
            fileName: fileName,
            lineNumber: lineNumber
        )
    }

    class func reportWarning(message: String, silentDismiss: Bool = false, breakpoint: Bool = false, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line)
    {
        Lighthouse.present(Report(
            type: .Warning,
            title: "Warning",
            message: message,
            silentDismiss: silentDismiss,
            functionName: functionName,
            fileName: fileName,
            lineNumber: lineNumber,
            breakpoint: breakpoint),

            functionName: functionName,
            fileName: fileName,
            lineNumber: lineNumber
        )
    }

    class func reportError(message: String, silentDismiss: Bool = false, breakpoint: Bool = false, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line)
    {

        // TODO: Check !!!
        let silentDismiss = kSilentDismissDebugErrors

        Lighthouse.present(Report(
            type: .Error,
            title: "Error",
            message: message,
            silentDismiss: silentDismiss,
            functionName: functionName,
            fileName: fileName,
            lineNumber: lineNumber,
            breakpoint: breakpoint),

            functionName: functionName,
            fileName: fileName,
            lineNumber: lineNumber
        )
    }



    class func present(report: Report, functionName: String = #function, fileName: String = #file, lineNumber: Int = #line)
    {

        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            let reportType = report.type ?? .Info

            var reportMessage: String = ""

            if report.attributedMessage != nil {
                reportMessage = report.attributedMessage!.string
            }
            else if report.message != nil {
                reportMessage = report.message!
            }

            // Log using XCGLogger

            switch reportType {

            case .Info:
                // TODO: Support also attributed message
                logger.info(reportMessage, functionName: functionName, fileName: fileName, lineNumber: lineNumber)

            case .Warning:
                logger.info(reportMessage, functionName: functionName, fileName: fileName, lineNumber: lineNumber)

            case .Error:
                logger.error(reportMessage, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
            }
            
            //Crashlytics log
            #if DEBUG
            CLSLogv("Log awesomeness %@", getVaList([reportMessage]))
            #endif

            if report.silentDismiss {
                return
            }

            if let attributedMessage = report.attributedMessage {

                let modifiedAttributedMessage: NSMutableAttributedString = attributedMessage.mutableCopy() as! NSMutableAttributedString

                #if DEBUG
                    modifiedAttributedMessage.appendAttributedString(NSAttributedString(string: "\n\n\(report.debugInfo())"))
                #endif

                CustomAlertView.createCustomAlertViewWithTitle(report.title!, attributedMessage: modifiedAttributedMessage, buttons: ["OK"], action: { (buttonIndex, alertView) -> () in

                })
            }
            else if let message = report.message {

                var modifiedMessage = message

                #if DEBUG
                    modifiedMessage = modifiedMessage.stringByAppendingString("\n\n\(report.debugInfo())")
                #endif


                CustomAlertView.createCustomAlertViewWithTitle(report.title!, message: modifiedMessage, buttons: ["OK"], action: { (buttonIndex, alertView) -> () in

                })
            }
            else {
                logger.error("Error: Invalid report context")
                return
            }
            
            if report.breakpoint {
                BreakpointHandler.createBreakpoint()
            }
        }
    }


    ////////////////////////////////////////////////////////////////
    // MARK: - Private API


}
