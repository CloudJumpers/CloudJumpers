# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
end
  
target 'CloudJumpers' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  shared_pods
end

target 'CloudJumpersTests' do
  use_frameworks!
  shared_pods
end
