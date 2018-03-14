[ "${TRACE}" = "YES" ] && set -x  && : "$0" "$@"

#
# If mulle-env is broken, sometimes its nice just to source this file.
# If you're sourcing this manually on a regular basis, you're doing it wrong.
#
# We need some minimal stuff to get things going though:
#     sed, cut, tr, hostname, pwd, uname
#
if [ -z "${MULLE_UNAME}" ]
then
   MULLE_UNAME="`PATH=/bin:/usr/bin uname | \
                  PATH=/bin:/usr/bin cut -d_ -f1 | \
                  PATH=/bin:/usr/bin sed 's/64$//' | \
                  PATH=/bin:/usr/bin tr 'A-Z' 'a-z'`"
   export MULLE_UNAME
fi
if [ -z "${MULLE_VIRTUAL_ROOT}" ]
then
   MULLE_VIRTUAL_ROOT="`PATH=/bin:/usr/bin pwd -P`"
   echo "Using ${MULLE_VIRTUAL_ROOT} as MULLE_VIRTUAL_ROOT for \
your convenience" >&2
fi


#
# Set PS1 so that we can see, that we are in a mulle-env
#
envname="`PATH=/bin:/usr/bin basename -- "${MULLE_VIRTUAL_ROOT}"`"

case "${PS1}" in
   *\\h\[*)
   ;;

   *\\h*)
      PS1="$(sed 's/\\h/\\h\['${envname}'\]/' <<< '${PS1}' )"
   ;;

   *)
      PS1='\u@\h['${envname}'] \W$ '
   ;;
esac
export PS1

unset envname

alias mulle-env-reload='. "${MULLE_VIRTUAL_ROOT}/.mulle-env/share/environment-include.sh"'

mulle-env-reload

# install cd catcher
. "`mulle-env libexec-dir`/mulle-env-cd.sh"


#
# Source in bash completion if available
# Assumed is, that they are not user modifiable
#
if [ "${MULLE_SHELL_MODE}" = "INTERACTIVE" ]
then
   DEFAULT_IFS="${IFS}"
   shopt -s nullglob; IFS="
"
   for FILENAME in "${MULLE_VIRTUAL_ROOT}/.mulle-env/share/libexec"/*-bash-completion.sh
   do
      . "${FILENAME}"
   done
   shopt -u nullglob; IFS="${DEFAULT_IFS}"

   unset FILENAME
   unset DEFAULT_IFS
fi

#
#
# show motd, if any
#
if [ -f "${MULLE_VIRTUAL_ROOT}/.mulle-env/etc/motd" ]
then
   cat "${MULLE_VIRTUAL_ROOT}/.mulle-env/etc/motd"
else
   if [ -f "${MULLE_VIRTUAL_ROOT}/.mulle-env/share/motd" ]
   then
      cat "${MULLE_VIRTUAL_ROOT}/.mulle-env/share/motd"
   fi
fi