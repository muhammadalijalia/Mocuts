//
//  AnimatedLaunchScreenVC.swift
//  MoCuts
//
//  Created by Ahmed Khan on 07/12/2021.
//

import Foundation
import Lottie
import CoreFoundation

class AnimatedLaunchScreenVC : BaseView, Routeable {
    
    @IBOutlet var mocuts: LottieAnimationView!
    var didPlayOnce = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mocuts!.contentMode = .scaleAspectFit
        mocuts!.loopMode = .playOnce
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setAnimationView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .darkContent
        }
    }
    
    private func setAnimationView() {
        if !didPlayOnce {
            didPlayOnce = true
            mocuts!.play(completion: { complete in
                if complete {
                    AppRouter.decideAndMakeRoot()
                }
            })
        }
    }
}


class ParkBenchTimer {

    let startTime:CFAbsoluteTime
    var endTime:CFAbsoluteTime?

    init() {
        startTime = CFAbsoluteTimeGetCurrent()
    }

    func stop() -> CFAbsoluteTime {
        endTime = CFAbsoluteTimeGetCurrent()

        return duration!
    }

    var duration:CFAbsoluteTime? {
        if let endTime = endTime {
            return endTime - startTime
        } else {
            return nil
        }
    }
}
