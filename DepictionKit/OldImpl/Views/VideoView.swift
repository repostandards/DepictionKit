//
//  VideoPlayer.swift
//  ExampleApp
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit
import WebKit
import AVKit

/**
 Embed a video in a view
 - Author: Amy

 - Version: 1.0
 
 - Important: When using `web` player `show_controls` and `autoplay` will have no effect.
 
 - Parameters:
    - url: `String`; URL to the video content.
    - alt_text: `String`; Accessibility Text to improve the reliability of Screen readers.
    - player_size: `[String: Int]`; Size of the video player in pts. Requires the keys `width` and `height`
    - player: `String? = "native"`;  Video player type (Embedded player or Web View).
                                    For sites like YouTube or Vimeo which don't give native video, using the web player is the only option.
                                    Supports `native` and `web`
    - autoplay: `String? = "disabled"`; Automatically play video content (audio disabled if set to 'once' or 'loop'). 'loop' will restart the video after it ends forever. Supports                                                                             `disabled`, `once` and `loop`
    - corner_radius: `Int? = 4`; Video player corner radius.
    - show_controls: `Bool? = false`; Show the video player controls.
    - alignment: `Alignment? = "left"`; Set the alignment of the player.
 */
final public class VideoView: UIView, DepictionViewDelegate {
    
    // These references need to be held so the view isn't deallocated
    private var playerLooper: AVPlayerLooper?
    private var player: AVQueuePlayer?
    private var playerViewController: AVPlayerViewController?
    
    private var playerView: UIView
    private var height: CGFloat
    private var width: CGFloat
    private var alignment: NSTextAlignment
    
    private enum Player {
        case web
        case native
    }
    
    private enum AutoPlay {
        case disabled
        case once
        case loop
    }

    private enum Error: LocalizedError {
        case invalid_url(string: String?)
        case invalid_alt_text
        case invalid_player_size
        case invalid_player
        case invalid_autoplay
        case unknown_alignment_error
        
        public var errorDescription: String? {
            switch self {
            case let .invalid_url(string): return "\(string ?? "Nil") is an invalid URL"
            case .invalid_alt_text: return "VideoPlayer is missing required argument: alt_text"
            case .invalid_player_size: return "VideoPlayer has invalid argument: player_size"
            case .invalid_player: return "VideoPlayer has invalid arugment: player"
            case .invalid_autoplay: return "VideoPlayer has invalid arugment: autoplay"
            case .unknown_alignment_error: return "VideoPlayer had unknown alignment error"
            }
        }
    }
    
    init(for input: [String: Any]) throws {
        playerView = UIView()
        
        guard let _url = input["url"] as? String,
              let url = URL(string: _url) else { throw Error.invalid_url(string: input["url"] as? String) }
        guard let alt_text = input["alt_text"] as? String else { throw Error.invalid_alt_text }
        guard let player_size = input["player_size"] as? [String: Int],
              let height = player_size["height"],
              let width = player_size["width"] else { throw Error.invalid_player_size }
        self.height = CGFloat(height)
        self.width = CGFloat(width)
        var alignment: NSTextAlignment = .left
        if let _alignment = input["alignment"] as? String {
            do {
                alignment = try Alignment.alignment(for: _alignment)
            } catch {
                throw error
            }
        }
        self.alignment = alignment
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        let cornerRadius = input["corner_radius"] as? Int ?? 4
        let show_controls = input["show_controls"] as? Bool ?? false
        
        var player: Player = .native
        if let _player = input["player"] as? String {
            switch _player {
            case "web": player = .web
            case "native": player = .native
            default: throw Error.invalid_player
            }
        }
        
        var autoplay: AutoPlay = .disabled
        if player == .native {
            if let _autoplay = input["autoplay"] as? String {
                switch _autoplay {
                case "disabled": autoplay = .disabled
                case "once": autoplay = .once
                case "loop": autoplay = .loop
                default: throw Error.invalid_autoplay
                }
            }
        }

        if player == .native {
            let playerItem = AVPlayerItem(url: url)
            let player = AVQueuePlayer(playerItem: playerItem)
            self.player = player
            player.isMuted = true
            
            if autoplay == .loop {
                playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
            }

            let playerViewController = AVPlayerViewController()
            self.playerViewController = playerViewController
            playerViewController.player = player
            playerViewController.showsPlaybackControls = show_controls
            playerView = playerViewController.view
            if autoplay == .loop || autoplay == .once {
                player.play()
            }
        } else {
            let configuration = WKWebViewConfiguration()
            configuration.allowsInlineMediaPlayback = true
            let webView = WKWebView(frame: .zero, configuration: configuration)
            webView.load(URLRequest(url: url))
            webView.scrollView.isScrollEnabled = false
            playerView = webView
        }
        
        playerView.clipsToBounds = true
        playerView.layer.masksToBounds = true
        playerView.layer.cornerRadius = CGFloat(cornerRadius)
        if #available(iOS 13, *) {
            playerView.layer.cornerCurve = .continuous
        }
        playerView.accessibilityLabel = alt_text
        playerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playerView)
        
        var constraints: [NSLayoutConstraint] = [
            playerView.aspectRatioConstraint(CGFloat(height) / CGFloat(width)),
            playerView.topAnchor.constraint(equalTo: topAnchor),
            playerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            playerView.widthAnchor.constraint(equalToConstant: CGFloat(width))
        ]
        
        switch alignment {
        case .left:
            constraints.append(playerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15))
            constraints.append(playerView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -15))
            let lesserTrailing = playerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
            lesserTrailing.priority = UILayoutPriority(750)
            constraints.append(lesserTrailing)
        case .right:
            constraints.append(playerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15))
            constraints.append(playerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 15))
            let lesserLeading = playerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
            lesserLeading.priority = UILayoutPriority(750)
            constraints.append(lesserLeading)
        case .center:
            constraints.append(playerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 15))
            constraints.append(playerView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -15))
            constraints.append(playerView.centerXAnchor.constraint(equalTo: centerXAnchor))
            let lesserLeading = playerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
            lesserLeading.priority = UILayoutPriority(750)
            constraints.append(lesserLeading)
            let lesserTrailing = playerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
            lesserTrailing.priority = UILayoutPriority(750)
            constraints.append(lesserTrailing)
        default: throw VideoView.Error.unknown_alignment_error
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
