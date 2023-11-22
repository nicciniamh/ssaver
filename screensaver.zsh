(return 0 2>/dev/null) || { echo "This script should not be run directly, use source instead" >&2 ; exit 1; }
#
# This is a script that traps the alarm signal and sets a timeout to 900 (can be changed later)
#
# if the timeout is reached _screensave_lock is checked, if set to "on" the screenlock program
# will be called normally, otherwise it will be called with -n to prevent password prompting
# Usage: source screensaver.sh
# 
# Once loaded there will be a shell command, screensaver: 
__saverhelp=$(cat << EOF
Usage: screensaver off|on|activate|save|set
     on enable the screensaver
     off disable the screensaver
     activate turn on the screensaver with current options
     save save screensaver settings to ~/.ssaver.rc
     set lock|random|time
     	  colors off|on
          lock off|on
	  long off|on
          random off|on
          time <seconds>

EOF
)
function TRAPALRM() { __doScreenSaver }
TMOUT=900
readonly USER
export _screensave_lock="on"
export _saver_random=""
export _saver_colors=""
export _saver_fullhost=""

if [[ -f ~/.ssaver.rc ]] ; then
	source ~/.ssaver.rc
	export __deftimeout=$TMOUT
fi

function _saver_save() {
	:>~/.ssaver.rc
	for v in TMOUT _screensave_lock _saver_colors _saver_random _saver_fullhost; do
		if [[ ${(P)v} = <-> ]] ; then
			echo "export ${v}=${(P)v}" >>~/.ssaver.rc
		else
			echo "export ${v}=\"${(P)v}\"" >>~/.ssaver.rc
		fi
	done
}
function __doScreenSaver() {
	if [[ ${_screensave_lock} == "on" ]] ; then
		~/bin/screenlock ${_saver_random} ${_saver_colors}
	else
		~/bin/screenlock --nolock ${_saver_random} ${_saver_colors}
	fi
}
function __state() {
	local longopt="using full hostname"
	if [[ -z ${_saver_fullhost} ]] ; then
		longopt="using shot hostname"
	fi
	if [[ $TMOUT == 0 ]] ; then
		echo "Screensaver is not active. Use screensave on to activate "
		return 0;
	fi
	echo "screensaver activates after being idle for ${TMOUT} seconds."
	if [[ ${_screensave_lock} == "on" ]] ; then
		echo "Screen will be locked."
	else
		echo "Screen will not be locked."
	fi
	if [[ -z ${_saver_random} ]] ; then 
		echo "Logo will be centered on screen."
	else
		echo "Logo will be placed randomly on screen."
	fi
	if [[  -z ${_saver_colors} ]] ; then
		echo "Logo will be in white, ${longopt}."
	else
		echo "Logo will be in random colors, ${longopt}."
	fi
	return 0

}
function __sset() {
	local what=${1}
	local how=${2}
	local rc=0
	if [[ -z ${what} ]] ; then
		echo "Usage: screensaver set colors|long|lock|time|random"
		rc=0
	elif [[ ${what} == "lock" ]] ; then
		if [[ -z ${how} ]] ; then
			rc=0
		elif [[ ${how} == "on" ]] || [[ ${how} == "off" ]]; then
			unset _screensave_lock
			export _screensave_lock=${how}
		else
			echo "must be on or off"
			rc=1
		fi
	elif [[ ${what} == "fullhost" ]] ; then
		if [[ -z ${how} ]] ; then
			rc=0
		elif [[ ${how} == "on" ]] || [[ ${how} == "off" ]]; then
			unset _saver_fullhost
			if [[ ${how} == "on" ]] ; then
				export _saver_fullhost="--long"
			else
				export _saver_fullhost=""
			fi
		else
			echo "must be on or off"
			rc=1
		fi
	elif [[ ${what} == "random" ]] ; then
		local rc=0
		if [[ ${how} == "on" ]] ; then
			unset _saver_random
			export _saver_random="--random"
		elif  [[ ${how} == "off" ]]; then
			unset _saver_random
			export saver_random=""
		else
			echo "must be on or off"
			rc=1
		fi
	elif [[ ${what} == "colors" ]] ; then
		if [[ -z ${how} ]] ; then
			rc = 0
		elif [[ ${how} == "on" ]] ; then
			unset _saver_colors
			export _saver_colors="--colors"
		elif  [[ ${how} == "off" ]]; then
			unset _saver_colors
			export saver_colors=""
		else
			echo "must be on or off"
			rc=1
		fi
	elif [[ ${what} == "time" ]] ; then
		if [[ -z ${how} ]] ; then
			echo "need seconds"
			rc=1
		else
			TMOUT=${how}
		fi
	else 
		echo "Usage: screensaver set lock|time|colors|random"
		rc=1
	fi
	_saver_save
	__state
	return rc
}
function screensaver() {
	if [[ -z ${1} ]] ; then
		__state
		return 0
	fi
	case ${1} in
		"help"|"--help"|"-h") echo $__saverhelp; return 0;;
		"activate") __doScreenSaver ;;
		"off" ) TMOUT=0 ;;
		"on" ) TMOUT=__deftimeout ;;
		"save") _saver_save ;; 
		"set") __sset ${2} ${3};;
		* ) echo "Usage: screensaver off|on|set">&2 ; return -1 ;;
	esac
	return 0
}
