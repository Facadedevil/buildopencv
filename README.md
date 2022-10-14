﻿## buildOpenCV

* Script for building OpenCV 4.6-dev

# Building for:

* Ubuntu-20.04, 22.04
* OpenCV 4.6.0

## Packaging Option ( Builds package by default; --no\_package does not build package)

# Building
$ ./buildOpenCV.sh

$ make -j$nproc

* ensure atleast 16gb of ram and 8gb of swap memory before installing
* edit opencv_contrib file
* go to cd path to opencv_contrib/module/sfm/src/libmv_light/libmv/simple_pipeline
* use your favourite editior and edit **bundle.cc** line no. 552
* change **SetParameterization** to **SetManifold** save and continue with installation.

# Build Parameters

OpenCV is a very rich environment, with many different options available. Check the script to make sure that the options you need are included/excluded. By default, the buildOpenCV.sh script selects these major options:

* CUDA on
* GStreamer
* V4L - (Video for Linux)
* QT - (No gtk support built in)
* Python 3 bindings

## Notes

feel free to give your feedback!!

## Licence

MIT License

Copyright (c) 2017-2018 Jetsonhacks

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
