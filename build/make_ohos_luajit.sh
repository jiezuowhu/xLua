if [ -z "$OHOS_SDK" ]; then
    export OHOS_SDK=/home/u3/ohos-sdk/linux
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

SRCDIR=$DIR/luajit-2.1.0b3
# Runtime code generation is restricted on OpenHarmony, not support JIT
sed -i '/#if LJ_TARGET_IOS || LJ_TARGET_CONSOLE/c\#if LJ_TARGET_IOS || LJ_TARGET_CONSOLE || defined(__OHOS__)' $SRCDIR/src/lj_arch.h

OS=`uname -s`
PREBUILT_PLATFORM=linux-x86_64
if [[ "$OS" == "Darwin" ]]; then
    PREBUILT_PLATFORM=darwin-x86_64
fi

echo "Building arm64-v8a lib"
cd "$SRCDIR"
export dynamic_cc="${OHOS_SDK}/native/llvm/bin/clang --target=aarch64-linux-ohos"
export target_ld="${OHOS_SDK}/native/llvm/bin/clang --target=aarch64-linux-ohos"
export static_cc=${dynamic_cc}
export target_ar="${OHOS_SDK}/native/llvm/bin/llvm-ar rcus 2>/dev/null"
target_strip=${OHOS_SDK}/native/llvm/bin/llvm-strip
make clean
make -j32 HOST_CC="gcc" CFLAGS="-fPIC -DLJ_ABI_SOFTFP=0 -DLJ_ARCH_HASFPU=1 -DLUAJIT_DISABLE_JIT" DYNAMIC_CC="${dynamic_cc}" TARGET_LD="${target_ld}" STATIC_CC="${static_cc}" TARGET_AR="${target_ar}" TARGET_STRIP=${target_strip}
unset dynamic_cc target_ld static_cc target_ar target_strip

cd "$DIR"
mkdir -p build_lj_v8a && cd build_lj_v8a
cmake -DUSING_LUAJIT=ON -DOHOS_ARCH=arm64-v8a -DCMAKE_TOOLCHAIN_FILE=$OHOS_SDK/native/build/cmake/ohos.toolchain.cmake ../
cd "$DIR"
cmake --build build_lj_v8a --config Release
mkdir -p plugin_luajit/Plugins/OpenHarmony/libs/arm64-v8a/
cp build_lj_v8a/libxlua.so plugin_luajit/Plugins/OpenHarmony/libs/arm64-v8a/libxlua.so
