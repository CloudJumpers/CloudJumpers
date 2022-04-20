
<p align="center"><img src="docs/images/banner.png" width="50%"/></p>

<h1 align="center">Cloud Jumpers</h1>

<div align="center">
<img src="https://github.com/CloudJumpers/CloudJumpers/actions/workflows/CI-Push.yml/badge.svg">
<img src="https://github.com/CloudJumpers/CloudJumpers/actions/workflows/CI-PR.yml/badge.svg">
</div>

## Overview

Cloud Jumpers is a competitive 1-4 player iOS platformer game. There are power-ups, different game modes, kill mechanics, and more!

Race against the clock in single-player mode, and compete against the rest of the world on the high scores. 
Alternatively, create a lobby with up to three others and compete for the top ranking in two unique multiplayer modes.

Every round you play is randomly generated and different from previous encounters. 
However, if you wish to relive a particular experience, you can always specify a level seed.

We can't wait to race against you on Cloud Jumpers!

## Details
You can view our final report [here](docs/Cloud%20Jumpers%20Final%20Report.pdf).

> Cloud Jumpers was awarded **Best Project Award** (First Winner) in The 20th NUS School of Computing Term Project Showcase (STePS) on 13 April 2022. You may view our project page at The 20th STePS [here](https://uvents.nus.edu.sg/event/20th-steps/module/CS3217/project/6).

## Preview

<p align="center"><img src="https://user-images.githubusercontent.com/67775223/163954646-8d64f85a-d38b-4f82-8ce3-69e16a0d4599.PNG" width="50%" /></p>

### Multiplayer: King of the Hill
Reach the top and be a Cloud God, giving you the power to scroll the entire world and get random power-ups for free to maintain your throne within two minutes!

https://user-images.githubusercontent.com/67775223/163954463-d78f4e6e-28ca-4656-a0b1-17bd1549bb5d.mp4

### Single Player: Time Trials
Practice your cloud jumping and beat your own best trial with a shadow player!

https://user-images.githubusercontent.com/40201586/163977561-236fdd14-5aa8-4c3f-af43-841d46194b1e.mp4

## Development
- Install CocoaPods (https://guides.cocoapods.org/using/getting-started.html)
- From repository root, run `pod install`
  - This is to be run everytime you switch branches
- Set up a Firebase project and replace the `GoogleService-Info.plist` in `CloudJumpers/` with yours
- Work on the project using `File > Open > CloudJumpers.xcworkspace`
