# Uncomment the next line to define a global platform for your project
 workspace 'MaterialUI.xcworkspace'
 platform :ios, '11.0'
 inhibit_all_warnings!
 use_frameworks!


target 'MaterialUI' do
  # Comment the next line if you don't want to use dynamic frameworks
  project 'MaterialUI'

  # Pods for MaterialUI
  pod 'MaterialComponents/Snackbar'
  pod 'MaterialComponents/Tabs'
  pod 'MaterialComponents/TextFields'

  target 'MaterialUITests' do
    # Pods for testing
  end

end


target 'MaterialUIDemo' do
  project 'Demo/MaterialUIDemo/MaterialUIDemo'
  
#  pod 'MaterialUI', :git => "https://github.com/prashantLalShrestha/MaterialUI.git"
  pod 'SnapKit'
  
  
  pod 'MaterialComponents/Snackbar'
  pod 'MaterialComponents/Tabs'
  pod 'MaterialComponents/TextFields'
  
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if config.name == 'Debug'
        config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
        config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
      end
    end
  end
end
