Pod::Spec.new do |s|
    s.name                  = 'GustyKit'
    s.version           = '1.0.2'
    s.summary           = 'A Cocoa Touch framework to help you develop high quality iOS apps and app extensions faster.'
    s.homepage          = 'https://github.com/marcelo-schroeder/GustyKit'
    s.license           = 'Apache-2.0'
    s.author            = { 'Marcelo Schroeder' => 'marcelo.schroeder@infoaccent.com' }
    s.platform          = :ios, '8.0'
    s.requires_arc      = true
    s.source            = { :git => 'https://github.com/marcelo-schroeder/GustyKit.git', :tag => 'v1.0.2' }
    s.default_subspec   = 'CoreUI'
    s.subspec 'Foundation' do |ss|
        ss.source_files  = 'GustyKit/GustyKit/Foundation/classes/**/*.{h,m}'
    end
    s.subspec 'CoreUI' do |ss|
        ss.source_files  = 'GustyKit/GustyKit/CoreUI/classes/**/*.{h,m}', 'GustyKit/GustyKit/Help/classes/**/*.{h,m}'
        ss.resource      = 'GustyKit/GustyKit/CoreUI/resources/**/*.*', 'GustyKit/GustyKit/Help/resources/**/*.*'
        ss.dependency 'GustyKit/Foundation'
    end
end
