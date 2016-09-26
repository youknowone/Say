Pod::Spec.new do |s|
  s.name         = "SayKit"
  s.version      = "0.3"
  s.summary      = "Easy-to-use interface for `say` command in OS X."
  s.homepage     = "https://github.com/youknowone/SayKit"
  s.license      = "2-clause BSD"
  s.author             = { "Jeong YunWon" => "jeong@youknowone.org" }
  s.social_media_url   = "http://twitter.com/youknowone_"
  s.platform     = :osx, "10.9"
  s.source       = { :git => "https://github.com/youknowone/SayKit.git", :tag => "0.3" }
  s.source_files  = "SayKit"
end
