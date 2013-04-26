DEV=`xcode-select --print-path`
VER=`xcodebuild -showsdks | grep "iphoneos" | awk '{print $2}'`
export IPHONEOS_DEPLOYMENT_TARGET="5.0"
PP=`pwd`
DD="iPhoneOS"
BIN="$DEV/Platforms/$DD.platform/Developer/usr/bin"

export CC="$IBIN/llvm-gcc-4.2"
export CFLAGS="-arch armv7 -arch armv7s -pipe -Os -gdwarf-2 -isysroot $DEV/Platforms/$DD.platform/Developer/SDKs/$DD$VER.sdk"
export LDFLAGS="-arch armv7 -arch armv7s -isysroot $DEV/Platforms/$DD.platform/Developer/SDKs/$DD$VER.sdk"
./configure --disable-shared --enable-static --disable-dependency-tracking --host="armv7-apple-darwin"

make clean
make -j `sysctl -n hw.logicalcpu_max` 

if [ ! -d "$PP/libs" ]; then
mkdir $PP/libs
fi 

mv $PP/lib/.libs/libcurl.a $PP/libs/ios.a

DD="iPhoneSimulator"
BIN="$DEV/Platforms/$DD.platform/Developer/usr/bin"

export CC="$IBIN/llvm-gcc-4.2"
export CFLAGS="-arch i386 -pipe -Os -gdwarf-2 -isysroot $DEV/Platforms/$DD.platform/Developer/SDKs/$DD$VER.sdk"
export CPPFLAGS="-D__IPHONE_OS_VERSION_MIN_REQUIRED=${IPHONEOS_DEPLOYMENT_TARGET%%.*}0000"
export LDFLAGS="-arch i386 -isysroot $DEV/Platforms/$DD.platform/Developer/SDKs/$DD$VER.sdk"
./configure --disable-shared --enable-static --disable-dependency-tracking --host="i386-apple-darwin"

make clean
make -j `sysctl -n hw.logicalcpu_max`

mv $PP/lib/.libs/libcurl.a $PP/libs/sim.a

lipo -create $PP/libs/sim.a $PP/libs/ios.a -output $PP/libs/libcurl.a
rm $PP/lib/sim.a
rm $PP/lib/ios.a

echo "$PP/libs/libcurl.a"