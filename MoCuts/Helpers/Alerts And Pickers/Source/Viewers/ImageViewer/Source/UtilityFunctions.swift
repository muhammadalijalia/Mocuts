//
//  UtilityFunctions.swift
//  ImageViewer
//
//  Created by Kristian Angyal on 29/02/2016.
//  Copyright © 2016 MailOnline. All rights reserved.
//

import UIKit

func contentCenter(forBoundingSize boundingSize: CGSize, contentSize: CGSize) -> CGPoint {

    /// When the zoom scale changes i.e. the image is zoomed in or out, the hypothetical center
    /// of content view changes too. But the default Apple implementation is keeping the last center
    /// value which doesn't make much sense. If the image ratio is not matching the screen
    /// ratio, there will be some empty space horizontally or vertically. This needs to be calculated
    /// so that we can get the correct new center value. When these are added, edges of contentView
    /// are aligned in realtime and always aligned with corners of scrollView.

    let horizontalOffset = (boundingSize.width > contentSize.width) ? ((boundingSize.width - contentSize.width) * 0.5): 0.0
    let verticalOffset   = (boundingSize.height > contentSize.height) ? ((boundingSize.height - contentSize.height) * 0.5): 0.0

    return CGPoint(x: contentSize.width * 0.5 + horizontalOffset, y: contentSize.height * 0.5 + verticalOffset)
}

func zoomRect(ForScrollView scrollView: UIScrollView, scale: CGFloat, center: CGPoint) -> CGRect {

    let width = scrollView.frame.size.width  / scale
    let height = scrollView.frame.size.height / scale
    let originX = center.x - (width / 2.0)
    let originY = center.y - (height / 2.0)

    return CGRect(x: originX, y: originY, width: width, height: height)
}

func screenshotFromView(_ view: UIView) -> UIImage {

    let image: UIImage

    UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
    view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
    image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()

    return image
}

// the transform needed to rotate a view that matches device screen orientation to match window orientation.
func windowRotationTransform() -> CGAffineTransform {

    let angleInDegrees = rotationAngleToMatchDeviceOrientation(UIDevice.current.orientation)
    let angleInRadians = degreesToRadians(angleInDegrees)

    return CGAffineTransform(rotationAngle: angleInRadians)
}

// the transform needed to rotate a view that matches window orientation to match devices screen orientation.
func deviceRotationTransform() -> CGAffineTransform {

    let angleInDegrees = rotationAngleToMatchDeviceOrientation(UIDevice.current.orientation)
    let angleInRadians = degreesToRadians(angleInDegrees)

    return CGAffineTransform(rotationAngle: -angleInRadians)
}

func degreesToRadians(_ degree: CGFloat) -> CGFloat {
    return CGFloat(Double.pi) * degree / 180
}

private func rotationAngleToMatchDeviceOrientation(_ orientation: UIDeviceOrientation) -> CGFloat {

    var desiredRotationAngle: CGFloat = 0

    switch orientation {
    case .landscapeLeft:                    desiredRotationAngle = 90
    case .landscapeRight:                   desiredRotationAngle = -90
    case .portraitUpsideDown:               desiredRotationAngle = 180
    default:                                desiredRotationAngle = 0
    }

    return desiredRotationAngle
}

func rotationAdjustedBounds() -> CGRect {

    let applicationWindow = UIApplication.shared.delegate?.window?.flatMap { $0 }
    guard let window = applicationWindow else { return UIScreen.main.bounds }

    if UIApplication.isPortraitOnly {

        return (UIDevice.current.orientation.isLandscape) ? CGRect(origin: CGPoint.zero, size: window.bounds.size.inverted()): window.bounds
    }

    return window.bounds
}

func maximumZoomScale(forBoundingSize boundingSize: CGSize, contentSize: CGSize) -> CGFloat {

    /// we want to allow the image to always cover 4x the area of screen
    return min(boundingSize.width, boundingSize.height) / min(contentSize.width, contentSize.height) * 4
}

func rotationAdjustedCenter(_ view: UIView) -> CGPoint {

    guard UIApplication.isPortraitOnly else { return view.center }

    return (UIDevice.current.orientation.isLandscape) ? view.center.inverted() : view.center
}

func stringToDate(date : String, format : String) -> Date {
    let dateFormatter =  DateFormatter()
    dateFormatter.dateFormat = format
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    return dateFormatter.date(from: date)!
}

func getElapsedTime(date: Date) -> String {

    var interval = date.timeIntervalSince(Date())
    if interval < 0 {
        interval = interval * -1
    }
//    interval = floor(interval/Constants.MINUTE) * Constants.MINUTE
    
    var intervalInWords = ""
    if interval < Constants.MINUTE {
        intervalInWords = "\(Int(interval)) seconds ago"
    } else if interval < Constants.MINUTE * 2 {
        intervalInWords = "1 minute ago"
    } else if interval < Constants.HOUR {
        intervalInWords = "\(Int(floor(Float(interval/Constants.MINUTE)))) minutes ago"
    } else if interval < Constants.HOUR * 2 {
        intervalInWords = "1 hour ago"
    } else if interval < Constants.DAY {
        intervalInWords = "\(Int(floor(Float(interval/Constants.HOUR)))) hours ago"
    } else if interval < Constants.DAY * 2 {
        intervalInWords = "1 day ago"
    } else if interval < Constants.WEEK {
        intervalInWords = "\(Int(floor(Float(interval/Constants.DAY)))) days ago"
    } else if interval < Constants.WEEK * 2 {
        intervalInWords = "1 week ago"
    } else {
        intervalInWords = "\(Int(floor(Float(interval/Constants.WEEK)))) weeks ago"
    }
    return intervalInWords
}

func getSecondsInWords(seconds: Double, isMins: Bool = false) -> String {
    
    var secondsInWords = ""
    let doubleFormat = "%.1f"
    let min = isMins ? "min" : "minute"
    if seconds == Constants.MINUTE {
        secondsInWords = "1.0 \(min)"
    } else if seconds == Constants.HOUR {
        secondsInWords = "1.0 hour"
    } else if seconds == Constants.DAY {
        secondsInWords = "1.0 day"
    } else if seconds == Constants.WEEK {
        secondsInWords = "1.0 week"
    } else if seconds < Constants.MINUTE {
        secondsInWords = "\(String(format: doubleFormat, seconds)) seconds"
    } else if seconds < Constants.HOUR {
        secondsInWords = "\(String(format: doubleFormat, seconds/Constants.MINUTE)) \(min)s"
    } else if seconds < Constants.DAY {
        secondsInWords = "\(String(format: doubleFormat, seconds/Constants.HOUR)) hours"
    } else if seconds < Constants.WEEK {
        secondsInWords = "\(String(format: doubleFormat, seconds/Constants.DAY)) days"
    } else {
        secondsInWords = "\(String(format: doubleFormat, seconds/Constants.WEEK)) weeks"
    }
    return secondsInWords
}
