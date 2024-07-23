if [ ! -d "$OHOS_SDK" ]; then
    export OHOS_SDK=/home/u3/ohos-sdk/linux
fi

function build() {
    BUILD_PATH=build.OpenHarmony.arm64-v8a
    cmake -H. -B${BUILD_PATH} -DOHOS_ARCH=arm64-v8a -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=$OHOS_SDK/native/build/cmake/ohos.toolchain.cmake -DPBC=ON -DXLUA_UNITY_UPDATE=ON
    cmake --build ${BUILD_PATH} --config Release
    mkdir -p plugin_lua53/Plugins/OpenHarmony/libs/arm64-v8a/
    cp ${BUILD_PATH}/libxlua.so plugin_lua53/Plugins/OpenHarmony/libs/arm64-v8a/libxlua.so
}

build
