
case "$(uname -s)" in
    Darwin)
        brew cask install gcc-arm-embedded
        brew tap discoteq/discoteq
        brew install flock
        ;;
    Linux)
        URL=https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2020q2/gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2
        # Download the ARM GCC Embedded Toolchain
        wget $URL -O /tmp/gcc-arm-none-eabi.tar.bz2
        # Unzip the ARM GCC Embedded Toolchain
        tar -xvjf /tmp/gcc-arm-none-eabi.tar.bz2
        # Export path to ARM GCC binaries
        export PATH=$PATH:$PWD/gcc-arm-none-eabi-8-2018-q4-major/bin/
        ;;
    CYGWIN*|MINGW32*|MSYS*|MINGW*)
        ;;
    *)
        exit 0
        ;;
esac
