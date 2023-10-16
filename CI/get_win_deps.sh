set -e

CMAKE_OPTS=""
add_cmake_opts() {
    CMAKE_OPTS="$CMAKE_OPTS $@"
}

download() {
    if [ $# -lt 3 ]; then
	echo "Invalid parameters to download."
	return 1
    fi

    NAME=$1
    shift

    echo "$NAME..."

    while [ $# -gt 1 ]; do
	URL=$1
	FILE=$2
	shift
	shift

	if ! [ -f $FILE ]; then
	    printf "  Downloading $FILE... "

	    if [ -z $VERBOSE ]; then
		RET=0
		curl --silent --fail --retry 10 -Ly 5 -o $FILE $URL || RET=$?
	    else
		RET=0
		curl --fail --retry 10 -Ly 5 -o $FILE $URL || RET=$?
	    fi

	    if [ $RET -ne 0 ]; then
		echo "Failed!"
		wrappedExit $RET
	    else
		echo "Done."
	    fi
	else
	    echo "  $FILE exists, skipping."
	fi
    done

    if [ $# -ne 0 ]; then
	echo "Missing parameter."
    fi
}



download "LuaJIT v2.1.0-beta3-452-g7a0cf5fd" \
	 "https://gitlab.com/OpenMW/openmw-deps/-/raw/main/windows/LuaJIT-v2.1.0-beta3-452-g7a0cf5fd-msvc2019-win64.7z" \
	 "LuaJIT-v2.1.0-beta3-452-g7a0cf5fd-msvc2019-win64.7z"



download "Boost 1.80.0" \
	 "https://gitlab.com/OpenMW/openmw-deps/-/raw/main/windows/boost_1_80_0-msvc-14.3-64.exe" \
	 "boost-1.80.0-msvc14.3-win64.exe"

.\boost-1.80.0-msvc14.3-win64.exe //DIR="${CWD_DRIVE_ROOT}" //VERYSILENT //NORESTART //SUPPRESSMSGBOXES //LOG='boost_install.log'

ls -laR
