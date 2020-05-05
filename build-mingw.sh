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

function pull_deps()
{
    echo "Getting dependencies for $1"
    ldd $1 | grep "=> /mingw" | awk '{print $3}' | xargs -I '{}' cp -v '{}' ./    
}

mkdir -p ${dir}/tesoro/build
cd ${dir}/tesoro/build

cmake -G "MSYS Makefiles" -D STATIC=ON -D ARCH="x86-64" -D BUILD_64=ON -D CMAKE_BUILD_TYPE=Release -D BUILD_TAG="win-x64" -D BUILD_GUI_DEPS=ON -D MINGW=ON ..
make -j${THREAD_COUNT}

cd ${dir}
${dir}/build.sh release

cd ${dir}/build/release/bin

windeployqt ./tesoro-wallet-gui.exe --release --no-translations --qmldir .

cp -r /mingw64/share/qt5/qml/Qt ./
cp -r /mingw64/share/qt5/qml/QtQuick ./
cp -r /mingw64/share/qt5/qml/QtQuick.2 ./
cp -r /mingw64/share/qt5/qml/QtGraphicalEffects ./

pull_deps ./tesoro-wallet-gui.exe

for f in $(find . -name "*.dll"); do
    pull_deps $f
done
