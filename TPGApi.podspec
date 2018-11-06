Pod::Spec.new do |s|

  s.name         = "TPGApi"
  s.version      = "0.0.3"
  s.summary      = "A wrapper to fetch Geneva's public transport (TPG) real time informations"
  s.description  = <<-DESC
			You can use this pod to get next departures for a bus stop in Geneva.
			You can also get the list of all the stops in Geneva with their location and connections.
                   DESC
  s.homepage     = "https://github.com/immortal79/TPGApi"
  s.license      = "GNU v3"
  s.author       = "Philippe"
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/immortal79/TPGApi.git", :tag => "#{s.version}" }
  s.source_files = "TPGApi", "TPGApi/**/*.{h,m,swift}"
  s.dependency 'Alamofire', '~> 4.5'
  s.dependency 'SwiftyJSON', '~> 4.0'
end
