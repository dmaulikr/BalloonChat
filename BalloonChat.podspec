Pod::Spec.new do |s|
  s.name         = "BalloonChat"
  s.version      = "0.0.1"
  s.summary      = "Balloon chat view for OS X."
  s.description  = <<-DESC
                    Balloon chat view for OS X.
                   DESC
  s.homepage     = "https://github.com/youknowone/BalloonChat"
  s.license      = "2-clause BSD"
  s.author       = { "Jeong YunWon" => "jeong@youknowone.org" }
  s.source       = { :git => "https://github.com/youknowone/BalloonChat.git", :branch => "pod" }
  s.requires_arc = true
  s.platform     = :osx, '10.9'

  s.source_files = "BalloonChat/*.{h,m}"
  s.public_header_files = "BalloonChat/*.h"

  s.dependency 'FoundationExtension', '~> 1.2.2'
end
