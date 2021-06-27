dnl -*- Autoconf -*-
dnl Copyright (C) 2008-2011, 2017, 2021 Free Software Foundation, Inc.
dnl This file is free software, distributed under the terms of the GNU
dnl General Public License.  As a special exception to the GNU General
dnl Public License, this file may be distributed as part of a program
dnl that contains a configuration script generated by Autoconf, under
dnl the same distribution terms as the rest of that program.

dnl From Sam Steingold.

AC_PREREQ([2.59])

dnl set variable $1 to the result of evaluating in clisp of $2
AC_DEFUN([CLISP_SET],
  [$1=`$cl_cv_clisp -q -norc -x '$2' 2>/dev/null | sed -e 's/^"//' -e 's/"$//'`])

dnl for use with autoconf 2.64 which supports m4_map_args_w
dnl <http://article.gmane.org/gmane.comp.sysutils.autoconf.general/12077>
dnl <https://lists.gnu.org/archive/html/autoconf/2009-09/msg00082.html>
m4_define([_CL_CLISP_REQUIRE_FEATURE_1],
[_CL_CLISP_REQUIRE_FEATURE_2([$1], m4_toupper([$1]))])
m4_define([_CL_CLISP_REQUIRE_FEATURE_2],
[
  AC_CACHE_CHECK([for $2 in CLISP], [cl_cv_clisp_$1],
    [CLISP_SET([cl_cv_clisp_$1], [[#+$1 "yes" #-$1 "no"]])])
  test $cl_cv_clisp_$1 = no && AC_MSG_ERROR([no $2 in CLISP])
])
dnl replace m4_foreach_w below with this:
dnl m4_map_args_w([$1], [_CL_CLISP_REQUIRE_FEATURE_1(], [)], [
dnl ])

dnl When running on woe32, we must ensure that cl_cv_clisp_libdir contains
dnl no colons because this will confuse make ("multiple target patterns")
dnl when $(CLISP_LIBDIR) appears in the list of dependencies.
dnl Moreover, if a colon appears in CPPFLAGS (as -Ic:/foo/bar),
dnl then it will creep into the <module>/gllib/.deps/* files.
AC_DEFUN([CL_DECOLONIZE],
[
  dnl This code must go into the initialization portion of the 'configure'
  dnl script, because it is needed for determining cl_cv_clisp_libdir and
  dnl this variable must be set before the expansion of _AC_INIT_AUX_DIR.
  m4_divert_text([INIT_PREPARE], [
    AC_CACHE_CHECK([how to remove colons from paths], [cl_cv_decolonize],
      [dnl Here we cannot use $build or $build_os, because these variables
       dnl require access to the config.guess file, which is only possible
       dnl after _AC_INIT_AUX_DIR.
       case `uname -s` in
         CYGWIN*)
           cl_cv_decolonize='cygpath --unix $x'
           ;;
         Windows* | MINGW* | MSYS*)
           if (type cygpath) > /dev/null 2>&1; then
             cl_cv_decolonize='cygpath --unix $x'
           else
             cl_cv_decolonize="echo \$x | sed -e 's,\\\\,/,g' -e 's,^\\(.\\):,/\1,'"
           fi
           ;;
         *)
           cl_cv_decolonize='echo $x'
           ;;
       esac
      ])
    CLISP_DECOLONIZE=$cl_cv_decolonize
    AC_SUBST([CLISP_DECOLONIZE])
  ])
])

dnl check for a clisp installation
dnl use --with-clisp=path if your clisp is not in the PATH
dnl if you want to link with the full linking set,
dnl use --with-clisp='clisp -K full'
AC_DEFUN([CL_CLISP],[
  AC_REQUIRE([CL_DECOLONIZE])
  dnl This code must go into the initialization portion of the 'configure'
  dnl script, because it is determines cl_cv_clisp_libdir and this variable
  dnl must be set before the expansion of _AC_INIT_AUX_DIR.
  m4_divert_text([INIT_PREPARE], [
    AC_ARG_WITH([clisp],
      [AS_HELP_STRING([[--with-clisp]], [use a specific CLISP installation])],
      [cl_use_clisp="$withval"],
      [cl_use_clisp=default])
    cl_have_clisp=no
    if test "$cl_use_clisp" != "no"; then
      if test "$cl_use_clisp" = default -o "$cl_use_clisp" = yes; then
        AC_PATH_PROG([cl_cv_clisp], [clisp])
      else
        cl_cv_clisp="$cl_use_clisp"
      fi
      if test -n "$cl_cv_clisp"; then
        AC_CACHE_CHECK([for CLISP version], [cl_cv_clisp_version],
          [dnl head closes its input after the 1st line and clisp (at least on woe32)
           dnl prints [stream.d:5473] *** - Win32 error 232 (ERROR_NO_DATA): The pipe is being closed.
           dnl we avoid this message by redirecting clisp stderr to /dev/null
           if $cl_cv_clisp --version 2>/dev/null | head -n 1 | grep "GNU CLISP" >/dev/null 2>&1; then
             CLISP_SET([cl_cv_clisp_version], [(lisp-implementation-version)])
           else
             AC_MSG_ERROR(['$cl_cv_clisp' is not a CLISP])
           fi
          ])
        AC_CACHE_CHECK([for CLISP libdir], [cl_cv_clisp_libdir],
          [CLISP_SET([cl_cv_clisp_libdir], [(namestring *lib-directory*)])
           x=$cl_cv_clisp_libdir
           cl_cv_clisp_libdir=`eval $cl_cv_decolonize`
           # cf src/clisp-link.in:linkkitdir
           missing=''
           for f in modules.c clisp.h; do
             test -r "${cl_cv_clisp_libdir}linkkit/$f" || missing=${missing}' '$f
           done
           test -n "${missing}" \
             && AC_MSG_ERROR([missing ${missing} in '${cl_cv_clisp_libdir}linkkit'])
          ])
        AC_CACHE_CHECK([for CLISP linking set], [cl_cv_clisp_linkset],
          [CLISP_SET([cl_cv_clisp_linkset], [(sys::program-name)])
           cl_cv_clisp_linkset=`dirname ${cl_cv_clisp_linkset}`
           missing=''
           # cf. src/clisp-link.in:check_linkset (we do not need to check for
           # lisp.run because cl_cv_clisp_linkset comes from SYS::PROGRAM-NAME)
           for f in lisp.a lispinit.mem modules.h modules.o makevars; do
             test -r "${cl_cv_clisp_linkset}/$f" || missing=${missing}' '$f
           done
           test -n "${missing}" \
             && AC_MSG_ERROR([missing ${missing} in '${cl_cv_clisp_linkset}'])
          ])
        CLISP=$cl_cv_clisp
        AC_SUBST([CLISP])
        CLISP_LIBDIR="${cl_cv_clisp_libdir}"
        AC_SUBST([CLISP_LIBDIR])
        CLISP_LINKKIT="${cl_cv_clisp_libdir}linkkit"
        AC_SUBST([CLISP_LINKKIT])
        sed 's/^/CLISP_/' ${cl_cv_clisp_linkset}/makevars > conftestvars
        . ./conftestvars
        rm -f conftestvars
        AC_SUBST([CLISP_FILES])
        AC_SUBST([CLISP_LIBS])
        AC_SUBST([CLISP_CFLAGS])
        AC_SUBST([CLISP_CPPFLAGS])
        test -d "$cl_cv_clisp_libdir" -a -d "$cl_cv_clisp_linkset" && cl_have_clisp=yes
      fi
    fi
  ])
  AC_CACHE_CHECK([for CLISP], [cl_cv_have_clisp],
    [cl_cv_have_clisp=$cl_have_clisp])
  required=m4_default([$2], [true])
  ${required} && test $cl_cv_have_clisp = no && AC_MSG_ERROR([CLISP not found])
  m4_foreach_w([cl_feat], m4_toupper([$1]),
    [AC_CACHE_CHECK([for cl_feat in CLISP], [cl_cv_clisp_]cl_feat,
       [CLISP_SET([cl_cv_clisp_]cl_feat,[[#+]]cl_feat[[ "yes" #-]]cl_feat[[ "no"]])])
     ${required} && test $cl_cv_clisp_[]cl_feat = no \
       && AC_MSG_ERROR([no ]cl_feat[ in CLISP])
    ])
])
