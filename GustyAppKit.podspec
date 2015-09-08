Pod::Spec.new do |s|
    s.name                  = 'GustyAppKit'
    s.version           = '1.0.2'
    s.summary           = 'A Cocoa Touch framework to help you develop high quality iOS apps faster.'
    s.homepage          = 'https://github.com/marcelo-schroeder/GustyAppKit'
    s.license           = 'Apache-2.0'
    s.author            = { 'Marcelo Schroeder' => 'marcelo.schroeder@infoaccent.com' }
    s.platform          = :ios, '8.0'
    s.requires_arc      = true
    s.source            = { :git => 'https://github.com/marcelo-schroeder/GustyAppKit.git', :tag => 'v1.0.2' }
    s.default_subspec   = 'CoreApp'
    s.subspec 'CoreApp' do |ss|
        ss.source_files  = 'GustyAppKit/GustyAppKit/CoreApp/classes/**/*.{h,m}'
        ss.resource      = 'GustyAppKit/GustyAppKit/CoreApp/resources/**/*.*'
        ss.dependency 'GustyKit'
    end
    s.subspec 'Html' do |ss|
        ss.source_files  = 'GustyAppKit/GustyAppKit/Html/classes/**/*.{h,m}'
        ss.dependency 'GustyAppKit/CoreApp'
        ss.dependency 'DTFoundation', '1.7.2'
        ss.dependency 'MWFeedParser', '1.0.2'
    end
end
