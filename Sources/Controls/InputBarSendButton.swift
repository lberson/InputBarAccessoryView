//
//  InputBarSendButton.swift
//  InputBarAccessoryView
//
//  Copyright © 2017-2020 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 8/18/17.
//

import UIKit

open class InputBarSendButton: InputBarButtonItem {

    /// A flag indicating the animation state of the `InputBarSendButton`
    open private(set) var isAnimating: Bool = false

    /// Accessor to modify the color of the activity view
    open var activityViewColor: UIColor! {
        get {
            return activityView.color
        }
        set {
            activityView.color = newValue
        }
    }

    private let activityView: UIActivityIndicatorView = {
        let view: UIActivityIndicatorView
        
        if #available(iOS 13.0, *) {
            view = UIActivityIndicatorView(style: .medium)
        } else {
            view = UIActivityIndicatorView(style: .gray)
        }
        
        view.isUserInteractionEnabled = false
        view.isHidden = true
        return view
    }()

    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSendButton()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSendButton()
    }

    private func setupSendButton() {
        addSubview(activityView)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        activityView.frame = bounds
    }

    /// Starts the animation of the activity view, hiding other elements
    open func startAnimating() {
        guard !isAnimating else { return }
        defer { isAnimating = true }
        activityView.startAnimating()
        activityView.isHidden = false
        // Setting isHidden doesn't hide the elements
        titleLabel?.alpha = 0
        imageView?.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
    }

    /// Stops the animation of the activity view, shows other elements
    open func stopAnimating() {
        guard isAnimating else { return }
        defer { isAnimating = false }
        activityView.stopAnimating()
        activityView.isHidden = true
        titleLabel?.alpha = 1
        imageView?.layer.transform = CATransform3DIdentity
    }

}
//
//  InputBarSendButton.swift
//  InputBarAccessoryView
//
//  Copyright © 2017-2020 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 8/18/17.
//

import UIKit

open class InputBarRecordButton: InputBarButtonItem {
    var onPressBegan: (() -> Void)?
       var onPressEnded: (() -> Void)?

    /// The round mic button, WhatsApp style. The circle is drawn into the image rather than set as
    /// a button background so it stays perfectly round however the stack view sizes the button.
    open var fillColor: UIColor = .systemGreen {
        didSet { applyIdleAppearance() }
    }

    open var glyphColor: UIColor = .white {
        didSet { applyIdleAppearance() }
    }

    open var recordingFillColor: UIColor = .systemRed

    open var circleDiameter: CGFloat = 38 {
        didSet { applyIdleAppearance() }
    }

    open func applyIdleAppearance() {
        image = roundMicImage(fill: fillColor, glyph: glyphColor)
    }

    open func applyRecordingAppearance() {
        image = roundMicImage(fill: recordingFillColor, glyph: .white)
    }

    private func roundMicImage(fill: UIColor, glyph: UIColor) -> UIImage {
        let size = CGSize(width: circleDiameter, height: circleDiameter)
        let glyphConfig = UIImage.SymbolConfiguration(pointSize: circleDiameter / 2, weight: .medium)
        let mic = UIImage(systemName: "mic.fill", withConfiguration: glyphConfig)?
            .withTintColor(glyph, renderingMode: .alwaysOriginal)

        return UIGraphicsImageRenderer(size: size).image { context in
            fill.setFill()
            context.cgContext.fillEllipse(in: CGRect(origin: .zero, size: size))
            guard let mic else { return }
            mic.draw(at: CGPoint(
                x: (size.width - mic.size.width) / 2,
                y: (size.height - mic.size.height) / 2
            ))
        }.withRenderingMode(.alwaysOriginal)
    }
   
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           super.touchesBegan(touches, with: event)
           onPressBegan?()
       }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
           super.touchesEnded(touches, with: event)
           onPressEnded?()
       }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
           super.touchesCancelled(touches, with: event)
           onPressEnded?()
       }
    /// A flag indicating the animation state of the `InputBarSendButton`
    open private(set) var isAnimating: Bool = false

    /// Accessor to modify the color of the activity view
    open var activityViewColor: UIColor! {
        get {
            return activityView.color
        }
        set {
            activityView.color = newValue
        }
    }

    private let activityView: UIActivityIndicatorView = {
        let view: UIActivityIndicatorView
        
        if #available(iOS 13.0, *) {
            view = UIActivityIndicatorView(style: .medium)
        } else {
            view = UIActivityIndicatorView(style: .gray)
        }
        
        view.isUserInteractionEnabled = false
        view.isHidden = true
        return view
    }()

    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        //setupSendButton()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       // setupSendButton()
    }

    private func setupSendButton() {
        addSubview(activityView)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
    //    activityView.frame = bounds
    }

    /// Starts the animation of the activity view, hiding other elements
    open func startAnimating() {
        guard !isAnimating else { return }
        defer { isAnimating = true }
        activityView.startAnimating()
        activityView.isHidden = false
        // Setting isHidden doesn't hide the elements
        titleLabel?.alpha = 0
        imageView?.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
    }

    /// Stops the animation of the activity view, shows other elements
    open func stopAnimating() {
        guard isAnimating else { return }
        defer { isAnimating = false }
        activityView.stopAnimating()
        activityView.isHidden = true
        titleLabel?.alpha = 1
        imageView?.layer.transform = CATransform3DIdentity
    }

}
