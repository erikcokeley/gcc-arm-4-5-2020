#!/bin/bash -ex

if [ ${EUID} -ne 0 ]; then
	echo "ERROR: Must execute ${0} with root promissions!"
	exit 1
fi

#DOWNLOAD_DIR=$(mktemp)
DOWNLOAD_DIR=/vagrant
INSTALL_ROOT_DIR=/usr/local/bin
INSTALL_GCC_DIR=${INSTALL_ROOT_DIR}/gcc-arm-none-eabi-9-2019-q4-major

ARTIFACT_FILE_NAME="gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2?revision=108bd959-44bd-4619-9c19-26187abf5225&la=en&hash=E788CE92E5DFD64B2A8C246BBA91A249CB8E2D2D"
#ARTIFACT_FILE_NAME="gcc-arm-none-eabi-9-2019-q4-major-x86_64-linux.tar.bz2"
MD5_HASH="fe0029de4f4ec43cf7008944e34ff8cc"

DOWNLOAD_URL="https://developer.arm.com/-/media/Files/downloads/gnu-rm/9-2019q4/${ARTIFACT_FILE_NAME}"

ARTIFACT_PATH=${DOWNLOAD_DIR}/${ARTIFACT_FILE_NAME}

wget --tries=10 --directory-prefix=${DOWNLOAD_DIR} ${DOWNLOAD_URL}
ARTIFACT_HASH=$(md5sum ${ARTIFACT_PATH} | cut -d " " -f 1)

if [ "${ARTIFACT_HASH}" != "${MD5_HASH}" ]; then
	echo "WARNING: Artifact hash does not match source!"
else
	$(
		cd ${INSTALL_ROOT_DIR} &&
		tar xjf ${ARTIFACT_PATH}
	)
	
	PROFILE_SCRIPT=/etc/profile.d/gcc-arm-none-eabi.sh
	cat > ${PROFILE_SCRIPT} <<- EndOfString
	export PATH=${PATH}:${INSTALL_GCC_DIR}/bin
	export MANPATH=$(manpath):${INSTALL_GCC_DIR}/share/doc/gcc-arm-none-eabi/man
	EndOfString

	chmod +u ${PROFILE_SCRIPT}
fi

rm -rf ${DOWNLOAD_DIR}
