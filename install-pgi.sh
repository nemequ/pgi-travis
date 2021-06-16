#!/bin/sh

# Install PGI Community Edition on Travis
# https://github.com/nemequ/pgi-travis
#
# Originally written for Squash <https://github.com/quixdb/squash> by
# Evan Nemerson.  For documentation, bug reports, support requests,
# etc. please use <https://github.com/nemequ/pgi-travis>.
#
# To the extent possible under law, the author(s) of this script have
# waived all copyright and related or neighboring rights to this work.
# See <https://creativecommons.org/publicdomain/zero/1.0/> for
# details.

TEMPORARY_FILES="/tmp/pgi"
INSTALL_BINDIR="${HOME}/bin"

export NVHPC_SILENT=true

if [ ! -e "/tmp/pgi" ]; then
	mkdir -p "${TEMPORARY_FILES}"
fi

case "$(uname -m)" in
	x86_64|ppc64le|aarch64)
		;;
	*)
		echo "Unknown architecture: $(uname -m)" >&2
		exit 1
		;;
esac

URL="$(curl -s 'https://developer.nvidia.com/nvidia-hpc-sdk-downloads' | grep -oP "http[^\"<>]+([0-9]{4})_([0-9]+)_Linux_$(uname -m)_cuda_([0-9\.]+).tar.gz")"

if [ -z "${URL}" ]; then
	echo "Unable to find download link." >&2
	exit 1
fi

if [ ! -z "${TRAVIS_REPO_SLUG}" ]; then
	curl --location \
    	--user-agent "pgi-travis (https://github.com/nemequ/pgi-travis; ${TRAVIS_REPO_SLUG})" \
    	--referer "http://www.pgroup.com/products/community.htm" \
    	--header "X-Travis-Build-Number: ${TRAVIS_BUILD_NUMBER}" \
    	--header "X-Travis-Event-Type: ${TRAVIS_EVENT_TYPE}" \
    	--header "X-Travis-Job-Number: ${TRAVIS_JOB_NUMBER}" \
    	"${URL}" | tar zx -C "${TEMPORARY_FILES}"
else
	curl --location \
		--user-agent "pgi-travis (https://github.com/nemequ/pgi-travis)" \
		"${URL}" | tar zx -C "${TEMPORARY_FILES}"
fi

FOLDER="$(basename "$(echo "${URL}" | grep -oP '[^/]+$')" .tar.gz)"

"${TEMPORARY_FILES}/${FOLDER}/install"
rm -rf "${TEMPORARY_FILES}/${FOLDER}"

if [ ! -e "${INSTALL_BINDIR}" ]; then
	mkdir "${INSTALL_BINDIR}"
fi

for executable in /opt/nvidia/hpc_sdk/Linux_x86_64/*.*/compilers/bin/*; do
	if [ -x "${executable}" ]; then
		ln -s "${executable}" "${INSTALL_BINDIR}/$(basename "${executable}")"
	fi
done
