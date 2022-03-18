# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
end

workspace 'CloudJumpers'
  
target 'CloudJumpers' do
  platform :ios, '12.0'
  use_frameworks!
  shared_pods
end

target 'CloudJumpersTests' do
  platform :ios, '12.0'
  use_frameworks!
  shared_pods
end
