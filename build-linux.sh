#!/bin/bash
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -z ${THREAD_COUNT} ]; then
	export THREAD_COUNT=4
fi

if [ ! -d "${dir}/tesoro" ]; then
	#todo: clone repo
	echo "todo: need cli repo placed here to clone"
	exit 1
fi

mkdir -p ${dir}/tesoro/build
cd ${dir}/tesoro/build

cmake -D STATIC=ON -D ARCH="x86-64" -D BUILD_64=ON -D CMAKE_BUILD_TYPE=Release -D BUILD_TAG="linux-x64" -D BUILD_GUI_DEPS=ON ..
make -j${THREAD_COUNT}

cd ${dir}
${dir}/build.sh
