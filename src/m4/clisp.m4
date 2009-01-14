dnl -*- Autoconf -*-
dnl Copyright (C) 2008-2009 Free Software Foundation, Inc.
dnl This file is free software, distributed under the terms of the GNU
dnl General Public License.  As a special exception to the GNU General
dnl Public License, this file may be distributed as part of a program
dnl that contains a configuration script generated by Autoconf, under
dnl the same distribution terms as the rest of that program.

dnl From Sam Steingold.

AC_PREREQ(2.13)

dnl set variable $1 to the result of evaluating in clisp of $2
AC_DEFUN(CLISP_SET,[$1=`$ac_cv_path_clisp -q -norc -x '$2' 2>/dev/null | sed -e 's/^"//' -e 's/"$//'`])

dnl check for a clisp of a correct version
dnl e.g.: AC_CLISP(2.47) is you want at least version 2.47
dnl use --with-clisp=path if your clisp is not in the PATH
dnl if you want to link with the full linking set,
dnl use --with-clisp='clisp -K full'
AC_DEFUN([AC_CLISP],[dnl
AC_ARG_WITH([clisp],
AC_HELP_STRING([--with-clisp],[use this CLISP installation]),
[ac_cv_use_clisp="$withval"], [ac_cv_use_clisp=default])
ac_cv_have_clisp=no
if test "$ac_cv_use_clisp" = "no";
then AC_MSG_NOTICE([not checking for clisp])
else
  AC_SUBST(ac_cv_path_clisp)
  if test "$ac_cv_use_clisp" = default -o "$ac_cv_use_clisp" = yes;
  then AC_PATH_PROG(ac_cv_path_clisp, clisp)
  else ac_cv_path_clisp="$ac_cv_use_clisp"
  fi
  if test "X$ac_cv_path_clisp" = "X"; then
    AC_MSG_RESULT([not found, disabling CLISP])
  else
    AC_MSG_CHECKING(CLISP version)
    if `$ac_cv_path_clisp --version | head -n 1 | grep "GNU CLISP" >/dev/null 2>&1`;
    then CLISP_SET(clisp_version,[(lisp-implementation-version)])
    else clisp_version='not a CLISP'
    fi
    if test "$clisp_version" = 'not a CLISP'; then
      AC_MSG_RESULT([$ac_cv_path_clisp is not a CLISP; disabling CLISP])
    elif test $1 \> "$clisp_version"; then
      AC_MSG_RESULT([found $clisp_version; need version >= $1; disabling CLISP])
    else
      AC_MSG_RESULT([ok: $clisp_version])
      AC_MSG_CHECKING(for CLISP header)
      CLISP_SET(clisp_libdir,[(namestring *lib-directory*)])
      if test ! -r "${clisp_libdir}linkkit/clisp.h"; then
        AC_MSG_RESULT([missing ${clisp_libdir}linkkit/clisp.h, disabling CLISP])
      else
        AC_MSG_RESULT([ok: ${clisp_libdir}linkkit/clisp.h])
        CLISP_INCLUDE="-I${clisp_libdir}linkkit"
        CLISP_SET(clisp_modset_dir,[(sys::program-name)])
        clisp_modset_dir=`dirname ${clisp_modset_dir}`
        AC_MSG_CHECKING(for CLISP module set in ${clisp_modset_dir})
        missing=''
        # cf. check_linkset in clisp-link
        for f in lisp.a lispinit.mem modules.h modules.o makevars; do
          test -r "${clisp_modset_dir}/$f" || missing=${missing}' '$f
        done
        if test -n "${missing}"; then
          AC_MSG_RESULT([missing${missing}, disabling CLISP])
        else
          AC_MSG_RESULT(yes)
          AC_SUBST(CLISP_INCLUDE)
          sed 's/^/CLISP_/' ${clisp_modset_dir}/makevars > conftestvars
          source conftestvars
          rm -f conftestvars
          AC_SUBST(CLISP_FILES)
          AC_SUBST(CLISP_LIBS)
          AC_SUBST(CLISP_CFLAGS)
          AC_SUBST(CLISP_CPPFLAGS)
          ac_cv_have_clisp=yes
        fi
      fi
    fi
  fi
fi
])
