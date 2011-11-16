#-
# Copyright (c) 2011 Juan Romero Pardines.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#-

_show_hard_pkg_deps()
{
	local f tmplf revdepname

	for f in $(find ${XBPS_SRCPKGDIR} -type f -name \*template); do
		if ! egrep -q "^Add_dependency[[:blank:]]+(run|full|build)[[:blank:]]+${1}([[:space:]]+\".*\")*$" $f; then
			continue
		fi
		tmplf=$(basename $f)
		if [ "$tmplf" != template ]; then
			revdepname=${tmplf%.template}
		else
			revdepname=$(basename $(dirname $f))
		fi
		echo $revdepname
	done
}

_show_shlib_pkg_deps()
{
	local f j

	revshlibs=$(egrep "^${1}$" ${XBPS_SRCPKGDIR}/*/*.rshlibs)
	for f in ${revshlibs}; do
		unset pkg revdepname tmprev
		revdepname=$(basename "$f")
		revdepname=${revdepname%.rshlibs*}
		tmprev=$(echo "$revdepname"|sed 's/-//g')
		eval pkg=\$pkg_"${tmprev}"
		if [ -z "${pkg}" ]; then
			eval local pkg_${tmprev}=1
			echo "$revdepname"
		fi
	done
}

show_pkg_revdeps()
{
	local SHLIBS_MAP="$XBPS_COMMONVARSDIR/mapping_shlib_binpkg.txt"

	[ -z "$1" ] && return 1

	shlibs=$(egrep "${1}[[:blank:]]+.*$" $SHLIBS_MAP|awk '{print $1}')
	if [ -n "$shlibs" ]; then
		# pkg provides shlibs
		_show_shlib_pkg_deps "$shlibs"
	else
		# pkg does not provide shlibs
		_show_hard_pkg_deps "$1"
	fi
}
