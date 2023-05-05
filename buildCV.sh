#!/bin/bash
# License: MIT. See license file in root directory
# Copyright(c) Darkratio

######################################
# INSTALL OPENCV ON UBUNTU OR DEBIAN #
######################################

# -------------------------------------------------------------------- |
#                       SCRIPT OPTIONS                                 |
# ---------------------------------------------------------------------|
OPENCV_VERSION='4.7.0'       # Version to be installed
OPENCV_CONTRIB='YES'          # Install OpenCV's extra modules (YES/NO)
# -------------------------------------------------------------------- |

# |          THIS SCRIPT IS TESTED CORRECTLY ON          |
# |------------------------------------------------------|
# | OS               | OpenCV       | Test | Last test   |
# |------------------|--------------|------|-------------|
# | Ubuntu 22.04 LTS | OpenCV 4.7.0 | OK   | 06 Feb 2023 |
# |------------------|--------------|------|-------------|
# | Ubuntu 22.04 LTS | OpenCV 4.6.0 | OK   | 04 Oct 2022 |
# |------------------|--------------|------|-------------|
# | Ubuntu 20.04 LTS | OpenCV 4.7.0 | OK   | 11 Mar 2023 |
# |------------------|--------------|------|-------------|
# | Ubuntu 20.04 LTS | OpenCV 4.6.0 | OK   | 17 Dec 2022 |
# |------------------|--------------|------|-------------|
# | Ubuntu 20.04 LTS | OpenCV 4.5.4 | OK   | 10 Dec 2021 |
# |------------------|--------------|------|-------------|
# | Ubuntu 20.04 LTS | OpenCV 4.5.1 | OK   | 27 Mar 2021 |
# |----------------------------------------------------- |
# | Ubuntu 20.04 LTS | OpenCV 4.2.0 | OK   | 25 Apr 2020 |
# |----------------------------------------------------- |


# 1. KEEP UBUNTU OR DEBIAN UP TO DATE

sudo apt-get -y update
sudo apt-get -y upgrade       # Uncomment to install new versions of packages currently installed
sudo apt-get -y dist-upgrade  # Uncomment to handle changing dependencies with new vers. of pack.
sudo apt-get -y autoremove    # Uncomment to remove packages that are now no longer needed

# 2. INSTALL THE DEPENDENCIES

# Build tools:
sudo apt install -y build-essential cmake pkg-config unzip yasm git checkinstall

# GUI (if you want GTK, change 'qt5-default' to 'libgtkglext1-dev' and remove '-DWITH_QT=ON'):
sudo apt-get install libgtk-3-dev

# Image I/O libs
sudo apt install -y libjpeg-dev libpng-dev libtiff-dev

# Video/Audio Libs - FFMPEG, GSTREAMER, x264 etc:
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
sudo apt-get install -y libxvidcore-dev x264 libx264-dev libfaac-dev libmp3lame-dev libtheora-dev
sudo apt-get install -y libfaac-dev libvorbis-dev

# OpenCore - Adaptive Multi Rate Narrow Band (AMRNB) and Wide Band (AMRWB) speech codec:
sudo apt-get install -y libopencore-amrnb-dev libopencore-amrwb-dev

# Parallelism library C++ for CPU
sudo apt-get install -y libtbb-dev

# Python libraries for python3:
sudo apt-get install python3-dev python3-pip
sudo -H pip3 install -U pip numpy
sudo apt install -y python3-testresources

# Optimization libraries for OpenCV
sudo apt-get install -y libatlas-base-dev gfortran

# Optional libraries:
sudo apt-get install -y libprotobuf-dev protobuf-compiler
sudo apt-get install -y libgoogle-glog-dev libgflags-dev
sudo apt-get install -y libgphoto2-dev libeigen3-dev libhdf5-dev doxygen
sudo apt-get install -y libgtkglext1 libgtkglext1-dev
sudo apt-get install -y libopenblas-dev liblapacke-dev libva-dev libopenjp2-tools libopenjpip-dec-server libopenjpip-server libqt5opengl5-dev libtesseract-dev 

# Install Ceres Solver
sudo apt-get install -y cmake libeigen3-dev libgflags-dev libgoogle-glog-dev libsuitesparse-dev libatlas-base-dev libmetis-dev

 git clone https://github.com/darkratio/ceres-solver.git
 cd ceres-solver && mkdir build && cd build
 cmake ..
 make -j
 make test
 sudo make install


# Download OpenCV and OpenCV Contrib. In June 2022, the 4.6.0 release didn’t include the fix to compile properly with the latest Ceres release. Cloning and building 4.6.0-dev from the repos includes the fix. Future OpenCV releases shouldn’t have this issue.

cd ../../
wget https://github.com/Facadedevil/buildopencv/releases/download/opencv/opencv.zip
unzip opencv.zip && rm opencv.zip
#git clone https://github.com/opencv/opencv.git
#cd opencv
#git checkout -b v${OPENCV_VERSION} ${OPENCV_VERSION}

if [ $OPENCV_CONTRIB = 'YES' ]; then
  #wget https://github.com/opencv/opencv_contrib/archive/refs/heads/4.x.zip
  #unzip 4.x.zip && rm 4.x.zip
  #mv opencv_contrib-4.x opencv_contrib
  echo "Installing opencv_contrib"
  cd ../
  wget https://github.com/Facadedevil/buildopencv/releases/download/opencv_contrib/opencv_contrib.zip
  unzip opencv_contrib.zip && rm opencv_contrib.zip
  #git clone https://github.com/opencv/opencv_contrib.git
  #cd opencv_contrib
  #git checkout -b v${OPENCV_VERSION} ${OPENCV_VERSION}
  
  # sed -i -e "552s/SetParameterization/SetManifold/" modules/sfm/src/libmv_light/libmv/simple_pipeline/bundle.cc
  
  
  # If the issue show up and then uncomment the below line.
  # ISSUE: "DIFFERENT_SIZES_EXTRA" was not declared in this scope; did you mean "DIFFERENT_SIZES"? 
  
  # sed -i -e "s/DIFFERENT_SIZES_EXTRA/DIFFERENT_SIZES/" modules/cudawarping/test/test_remap.cpp
fi

cd ../opencv
rm -r build
mkdir build && cd build

# Build and Install OpenCV

#CMake config options description
#CUDA_ARCH_BIN corresponds to the compute capability for the graphics card listed on NVIDIA’s site.
#QT has more features than GTK. When OPENGL is used, RGBD failed to compile with OpenGL_GL_PREFERENCE=GLVND, so OpenGL_GL_PREFERENCE=LEGACY is needed.

if [ $OPENCV_CONTRIB = 'NO' ]; then
cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D INSTALL_PYTHON_EXAMPLES=ON \
	-D OPENCV_GENERATE_PKGCONFIG=ON \
	-D OPENCV_PC_FILE_NAME=opencv.pc \
	-D WITH_TBB=ON \
	-D OPENCV_ENABLE_NONFREE=ON \
	-D WITH_CUDA=ON \
	-D WITH_CUDNN=ON \
	-D OPENCV_DNN_CUDA=ON \
	-D ENABLE_FAST_MATH=1 \
	-D CUDA_FAST_MATH=1 \
	-D CUDA_ARCH_BIN=7.5 \
	-D WITH_CUBLAS=1 \
	-D WITH_OPENGL=ON \
	-D WITH_QT=ON \
	-D OpenGL_GL_PREFERENCE=LEGACY \
	-D OPENCV_PYTHON3_INSTALL_PATH=/usr/local/lib/python3.10/dist-packages \
	-D PYTHON_EXECUTABLE=/usr/bin/python3.10 \
	-D BUILD_EXAMPLES=ON ..
fi

if [ $OPENCV_CONTRIB = 'YES' ]; then
time cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D INSTALL_PYTHON_EXAMPLES=ON \
	-D OPENCV_GENERATE_PKGCONFIG=ON \
	-D OPENCV_PC_FILE_NAME=opencv.pc \
	-D WITH_TBB=ON \
	-D OPENCV_ENABLE_NONFREE=ON \
	-D WITH_CUDA=ON \
	-D WITH_FFMPEFG=ON \
	-D WITH_CUDNN=ON \
	-D OPENCV_DNN_CUDA=ON \
	-D ENABLE_FAST_MATH=1 \
	-D CUDA_FAST_MATH=1 \
	-D CUDA_ARCH_BIN=8.6 \
	-D WITH_CUBLAS=1 \
	-D WITH_OPENGL=ON \
	-D WITH_QT=ON \
	-D WITH_LIBV4L=ON \
	-D WITH_V4L=ON \
    	-D WITH_GSTREAMER=ON \
    	-D WITH_GSTREAMER_0_10=OFF \
	-D OpenGL_GL_PREFERENCE=LEGACY \
	-D BUILD_opencv_python3=ON \
	-D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
	-D BUILD_EXAMPLES=ON \
	 ../
fi

if [ $? -eq 0 ] ; then
  echo "CMake configuration make successful"
else
  # Try to make again
  echo "CMake issues " >&2
  echo "Please check the configuration being used"
  exit 1
fi

# use max no. of cpus
# always ensure enough ram and swap memory before installing
NUM_CPU=$(nproc)
time make -j$(($NUM_CPU - 1))
if [ $? -eq 0 ] ; then
  echo "OpenCV make successful"
else
  # Try to make again; Sometimes there are issues with the build
  # because of lack of resources or concurrency issues
  echo "Make did not build " >&2
  echo "Retrying ... "
  # Single thread this time
  make
  if [ $? -eq 0 ] ; then
    echo "OpenCV make successful"
  else
    # Try to make again
    echo "Make did not successfully build" >&2
    echo "Please fix issues and retry build"
    exit 1
  fi
fi

echo "Installing ... "
sudo make install
if [ $? -eq 0 ] ; then
   echo "OpenCV installed in: $CMAKE_INSTALL_PREFIX"
   sudo ldconfig
else
   echo "There was an issue with the final installation"
   exit 1
fi

# Add PYTHON ENVIRONMENT PATH
PYTHON_VERSION=`ls /usr/local/lib | grep python3`
echo "# SETTING PYTHON Site-packages path to ENVIRONMENT" >> ~/.bashrc
echo "export PYTHONPATH=/usr/local/lib/$PYTHON_VERSION/site-packages:\$PYTHONPATH" >> ~/.bashrc
source ~/.bashrc

# check installation
IMPORT_CHECK="$(python3 -c "import cv2 ; print(cv2.__version__)")"
if [[ $IMPORT_CHECK != *$OPENCV_VERSION* ]]; then
  echo "There was an error loading OpenCV in the Python sanity test."
  echo "The loaded version does not match the version built here."
  echo "Please check the installation."
  echo "The first check should be the PYTHONPATH environment variable."
fi
