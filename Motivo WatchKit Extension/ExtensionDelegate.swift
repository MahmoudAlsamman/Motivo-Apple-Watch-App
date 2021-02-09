//
//  ExtensionDelegate.swift
//  Quote of the day WatchKit Extension
//
//  Created by Mahmoud Alsamman on 21/07/2020.
//  Copyright © 2020 Mahmoud Alsamman. All rights reserved.
//

import ClockKit
import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    func applicationDidFinishLaunching() {
        // Perform any final initialization of your application.
        scheduleBackgroundRefreshTasks()
    }

    func reloadTimelineEntries() {
        let server = CLKComplicationServer.sharedInstance()
        server.activeComplications?.forEach { server.reloadTimeline(for: $0) }
    }

    func scheduleBackgroundRefreshTasks() {
        // Get the shared extension object.
        let watchExtension = WKExtension.shared()
        // updates after 8 hours.
        let targetUpdateTime = Date(timeIntervalSinceNow: 5 * 60 * 60)
        // Schedule the background refresh task.
        watchExtension.scheduleBackgroundRefresh(withPreferredDate: targetUpdateTime, userInfo: nil) { [weak self] _ in
            QuotesDataManager.shared.updateQuotes { _ in
                self?.reloadTimelineEntries()
            }
        }
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                scheduleBackgroundRefreshTasks()
                backgroundTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
}
