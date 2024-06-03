# URT Autonomous Docker Setup
Docker setup for URT Autonomous

Note: still missing orbslam

## Installation
- Start docker engine
- Clone this repo
- cd into repo
- execute: docker build -t urt_auto --network host .
    - this will build the image in the current directory under the name urt_auto using the host network
- Wait for build to finish
- execute: docker run -it urt_auto