//
//  VideoPlayer.swift
//  ExampleApp
//
//  Created by Andromeda on 01/08/2021.
//

import UIKit
import WebKit
import AVKit

#warning("Constraints need to be finished for this, I can't figure it out")
final public class VideoView: UIView, DepictionViewDelegate {
    
    private var playerLooper: AVPlayerLooper?
    private var playerView: UIView
    private var height: CGFloat
    private var width: CGFloat
    private var alignment: NSTextAlignment
    
    enum Player {
        case web
        case native
    }
    
    enum AutoPlay {
        case disabled
        case once
        case loop
    }

    enum Error: LocalizedError {
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
    
    init(input: [String: Any]) throws {
        playerView = UIView()
        
        guard let _url = input["url"] as? String,
              let url = URL(string: _url) else { throw VideoView.Error.invalid_url(string: input["url"] as? String) }
        guard let alt_text = input["alt_text"] as? String else { throw VideoView.Error.invalid_alt_text }
        guard let player_size = input["player_size"] as? [String: Int],
              let height = player_size["height"],
              let width = player_size["width"] else { throw VideoView.Error.invalid_player_size }
        self.height = CGFloat(height)
        self.width = CGFloat(width)
        var alignment: NSTextAlignment = .left
        if let text_color = input["alignment"] as? String {
            do {
                alignment = try FontAlignment.alignment(for: text_color)
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
            default: throw VideoView.Error.invalid_player
            }
        }
        
        var autoplay: AutoPlay = .disabled
        if player == .native {
            if let _autoplay = input["autoplay"] as? String {
                switch _autoplay {
                case "disabled": autoplay = .disabled
                case "once": autoplay = .once
                case "loop": autoplay = .loop
                default: throw VideoView.Error.invalid_autoplay
                }
            }
        }

        if player == .native {
            let playerItem = AVPlayerItem(url: url)
            let player = AVQueuePlayer(playerItem: playerItem)
            player.isMuted = true
            
            if autoplay == .loop {
                playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
            }
            
            let playerViewController = AVPlayerViewController()
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
        playerView.layer.cornerRadius = CGFloat(cornerRadius)
        playerView.layer.cornerCurve = .continuous
        playerView.accessibilityLabel = alt_text
        playerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playerView)
        
        var constraints: [NSLayoutConstraint] = [
            playerView.aspectRatioConstraint(CGFloat(width) / CGFloat(height)),
            playerView.topAnchor.constraint(equalTo: topAnchor),
            playerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            playerView.widthAnchor.constraint(equalToConstant: CGFloat(width))
        ]
        
        switch alignment {
        case .left:
            constraints.append(playerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5))
            constraints.append(playerView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -5))
            let lesserTrailing = playerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
            lesserTrailing.priority = UILayoutPriority(750)
            constraints.append(lesserTrailing)
        case .right:
            constraints.append(playerView.leadingAnchor.constraint(lessThanOrEqualTo: leadingAnchor, constant: 5))
            constraints.append(playerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5))
            let lesserLeading = playerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -5)
            lesserLeading.priority = UILayoutPriority(750)
            constraints.append(lesserLeading)
        case .center:
            constraints.append(playerView.leadingAnchor.constraint(lessThanOrEqualTo: leadingAnchor, constant: 5))
            constraints.append(playerView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: 5))
            constraints.append(playerView.centerXAnchor.constraint(equalTo: centerXAnchor))
            let lesserLeading = playerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -5)
            lesserLeading.priority = UILayoutPriority(750)
            constraints.append(lesserLeading)
            let lesserTrailing = playerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
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

/*
    VideoView: {
        /**
         * URL to the video content.
         * Required
         */
        url: string

        /**
         * Accessbility Text to improve the reliability of Screen readers.
         * Required
         */
        alt_text: string

        /**
         * Video player type (Embedded player or Web View).
         * For sites like YouTube or Vimeo which don't give native video, using the web player is the only option.
         * Default: web
         */
        player: 'web' | 'native'

        /**
         * Size of the video player in pts
         * Required
         */
        player_size: {
            /**
             * Player size width
             * Required
             */
            width: number

            /**
             * Player size height
             * Required
             */
            height: number
        }

        /**
         * Automatically play video content (audio disabled if set to 'once' or 'loop').
         * 'loop' will restart the video after it ends forever.
         * Default: disabled
         */
        autoplay?: 'disabled' | 'once' | 'loop'

        /**
         * Video player corner radius.
         * Default: 4
         */
        corner_radius?: number

        /**
         * Show the video player controls.
         * Default: false
         */
        show_controls?: boolean

        /**
         * Set the alignment of the player.
         * Default: start
         */
        alignment?: Alignment
    }
*/

/*
 let cornerRadius = (dictionary["cornerRadius"] as? CGFloat) ?? 0

         let playerItem = AVPlayerItem(url: videoURL)
         let player = AVQueuePlayer(playerItem: playerItem)
         player.isMuted = true
         self.player = player

         if loopEnabled {
             playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
         }

         playerViewController = AVPlayerViewController()
         playerViewController?.player = player
         playerViewController?.showsPlaybackControls = showPlaybackControls

         videoView = playerViewController?.view
         if cornerRadius > 0 {
             videoView?.layer.cornerRadius = cornerRadius
             videoView?.clipsToBounds = true
         }
         self.addSubview(videoView!)

         if autoPlayEnabled {
             player.play()
         }
 
 webView = WKWebView(frame: .zero)

         super.init(dictionary: dictionary, viewController: viewController, tintColor: tintColor, isActionable: isActionable)

         webView?.load(URLRequest(url: url))
         webView?.scrollView.isScrollEnabled = false
         webView?.navigationDelegate = self
         webView?.uiDelegate = self
 */
