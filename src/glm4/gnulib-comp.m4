# DO NOT EDIT! GENERATED AUTOMATICALLY!
# Copyright (C) 2002-2020 Free Software Foundation, Inc.
#
# This file is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This file is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this file.  If not, see <https://www.gnu.org/licenses/>.
#
# As a special exception to the GNU General Public License,
# this file may be distributed as part of a program that
# contains a configuration script generated by Autoconf, under
# the same distribution terms as the rest of that program.
#
# Generated by gnulib-tool.
#
# This file represents the compiled summary of the specification in
# gnulib-cache.m4. It lists the computed macro invocations that need
# to be invoked from configure.ac.
# In projects that use version control, this file can be treated like
# other built files.


# This macro should be invoked from ./configure.ac, in the section
# "Checks for programs", right after AC_PROG_CC, and certainly before
# any checks for libraries, header files, types and library functions.
AC_DEFUN([gl_EARLY],
[
  m4_pattern_forbid([^gl_[A-Z]])dnl the gnulib macro namespace
  m4_pattern_allow([^gl_ES$])dnl a valid locale name
  m4_pattern_allow([^gl_LIBOBJS$])dnl a variable
  m4_pattern_allow([^gl_LTLIBOBJS$])dnl a variable

  # Pre-early section.
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])
  AC_REQUIRE([gl_PROG_AR_RANLIB])

  AC_REQUIRE([AM_PROG_CC_C_O])
  # Code from module absolute-header:
  # Code from module accept:
  # Code from module alloca:
  # Code from module alloca-opt:
  # Code from module arpa_inet:
  # Code from module attribute:
  # Code from module basename-lgpl:
  # Code from module bind:
  # Code from module btowc:
  # Code from module builtin-expect:
  # Code from module byteswap:
  # Code from module c-ctype:
  # Code from module c-strtod:
  # Code from module c99:
  # Code from module clock-time:
  # Code from module cloexec:
  # Code from module close:
  # Code from module connect:
  # Code from module crypto/af_alg:
  # Code from module crypto/sha1:
  # Code from module crypto/sha1-buffer:
  # Code from module ctype:
  # Code from module dirname-lgpl:
  # Code from module double-slash-root:
  # Code from module dup2:
  # Code from module environ:
  # Code from module errno:
  # Code from module extensions:
  # Code from module extern-inline:
  # Code from module fcntl:
  # Code from module fcntl-h:
  # Code from module fd-hook:
  # Code from module fflush:
  AC_REQUIRE([gl_SET_LARGEFILE_SOURCE])
  # Code from module filename:
  # Code from module flexmember:
  # Code from module float:
  # Code from module fnmatch:
  # Code from module fnmatch-gnu:
  # Code from module fnmatch-h:
  # Code from module fpurge:
  # Code from module freading:
  # Code from module fseek:
  # Code from module fseeko:
  AC_REQUIRE([gl_SET_LARGEFILE_SOURCE])
  # Code from module fstat:
  # Code from module ftell:
  # Code from module ftello:
  AC_REQUIRE([gl_SET_LARGEFILE_SOURCE])
  # Code from module getdtablesize:
  # Code from module gethostname:
  # Code from module getloadavg:
  # Code from module getpagesize:
  # Code from module getpeername:
  # Code from module getrandom:
  # Code from module getsockname:
  # Code from module getsockopt:
  # Code from module gettext:
  # Code from module gettext-h:
  # Code from module gettimeofday:
  # Code from module gnu-make:
  # Code from module hard-locale:
  # Code from module havelib:
  # Code from module host-cpu-c-abi:
  # Code from module iconv:
  # Code from module include_next:
  # Code from module inet_ntop:
  # Code from module inet_pton:
  # Code from module intprops:
  # Code from module inttypes-incomplete:
  # Code from module ioctl:
  # Code from module isblank:
  # Code from module langinfo:
  # Code from module largefile:
  AC_REQUIRE([AC_SYS_LARGEFILE])
  # Code from module libc-config:
  # Code from module libsigsegv:
  # Code from module libunistring-optional:
  # Code from module limits-h:
  # Code from module link-follow:
  # Code from module listen:
  # Code from module localcharset:
  # Code from module locale:
  # Code from module localeconv:
  # Code from module lock:
  # Code from module lseek:
  # Code from module lstat:
  # Code from module malloc-posix:
  # Code from module malloca:
  # Code from module math:
  # Code from module mbrtowc:
  # Code from module mbsinit:
  # Code from module mbsrtowcs:
  # Code from module mbtowc:
  # Code from module memchr:
  # Code from module mempcpy:
  # Code from module minmax:
  # Code from module mkdir:
  # Code from module mkdtemp:
  # Code from module mkfifo:
  # Code from module mknod:
  # Code from module mkstemp:
  # Code from module mktime:
  # Code from module mktime-internal:
  # Code from module msvc-inval:
  # Code from module msvc-nothrow:
  # Code from module multiarch:
  # Code from module netinet_in:
  # Code from module nl_langinfo:
  # Code from module no-c++:
  # Code from module nocrash:
  # Code from module noreturn:
  # Code from module nstrftime:
  # Code from module open:
  # Code from module pathmax:
  # Code from module readlink:
  # Code from module recv:
  # Code from module recvfrom:
  # Code from module regex:
  # Code from module select:
  # Code from module send:
  # Code from module sendto:
  # Code from module setenv:
  # Code from module setlocale-null:
  # Code from module setsockopt:
  # Code from module shutdown:
  # Code from module signal-h:
  # Code from module snippet/_Noreturn:
  # Code from module snippet/arg-nonnull:
  # Code from module snippet/c++defs:
  # Code from module snippet/unused-parameter:
  # Code from module snippet/warn-on-use:
  # Code from module socket:
  # Code from module socketlib:
  # Code from module sockets:
  # Code from module socklen:
  # Code from module ssize_t:
  # Code from module stat:
  # Code from module stat-time:
  # Code from module std-gnu11:
  # Code from module stdalign:
  # Code from module stdbool:
  # Code from module stddef:
  # Code from module stdint:
  # Code from module stdio:
  # Code from module stdlib:
  # Code from module strcase:
  # Code from module strdup-posix:
  # Code from module streq:
  # Code from module strerror-override:
  # Code from module strerror_r-posix:
  # Code from module strftime:
  # Code from module string:
  # Code from module strings:
  # Code from module strnlen:
  # Code from module strnlen1:
  # Code from module strptime:
  # Code from module strtod:
  # Code from module strverscmp:
  # Code from module sys_ioctl:
  # Code from module sys_random:
  # Code from module sys_select:
  # Code from module sys_socket:
  # Code from module sys_stat:
  # Code from module sys_time:
  # Code from module sys_types:
  # Code from module sys_uio:
  # Code from module sys_utsname:
  # Code from module sys_wait:
  # Code from module tempname:
  # Code from module threadlib:
  gl_THREADLIB_EARLY
  # Code from module time:
  # Code from module time_r:
  # Code from module time_rz:
  # Code from module timegm:
  # Code from module tzset:
  # Code from module uname:
  # Code from module uniname/base:
  # Code from module uniname/uniname:
  # Code from module unistd:
  # Code from module unitypes:
  # Code from module uniwidth/base:
  # Code from module uniwidth/width:
  # Code from module unsetenv:
  # Code from module verify:
  # Code from module vma-iter:
  # Code from module wchar:
  # Code from module wcrtomb:
  # Code from module wctype-h:
  # Code from module windows-mutex:
  # Code from module windows-once:
  # Code from module windows-recmutex:
  # Code from module windows-rwlock:
  # Code from module wmemchr:
  # Code from module wmempcpy:
  # Code from module xalloc-oversized:
])

# This macro should be invoked from ./configure.ac, in the section
# "Check for header files, types and library functions".
AC_DEFUN([gl_INIT],
[
  AM_CONDITIONAL([GL_COND_LIBTOOL], [false])
  gl_cond_libtool=false
  gl_libdeps=
  gl_ltlibdeps=
  gl_m4_base='src/glm4'
  m4_pushdef([AC_LIBOBJ], m4_defn([gl_LIBOBJ]))
  m4_pushdef([AC_REPLACE_FUNCS], m4_defn([gl_REPLACE_FUNCS]))
  m4_pushdef([AC_LIBSOURCES], m4_defn([gl_LIBSOURCES]))
  m4_pushdef([gl_LIBSOURCES_LIST], [])
  m4_pushdef([gl_LIBSOURCES_DIR], [])
  gl_COMMON
  gl_source_base='src/gllib'
  AC_REQUIRE([gl_HEADER_SYS_SOCKET])
  if test "$ac_cv_header_winsock2_h" = yes; then
    AC_LIBOBJ([accept])
  fi
  gl_SYS_SOCKET_MODULE_INDICATOR([accept])
  gl_FUNC_ALLOCA
  gl_HEADER_ARPA_INET
  AC_PROG_MKDIR_P
  AC_REQUIRE([gl_HEADER_SYS_SOCKET])
  if test "$ac_cv_header_winsock2_h" = yes; then
    AC_LIBOBJ([bind])
  fi
  gl_SYS_SOCKET_MODULE_INDICATOR([bind])
  gl_FUNC_BTOWC
  if test $HAVE_BTOWC = 0 || test $REPLACE_BTOWC = 1; then
    AC_LIBOBJ([btowc])
    gl_PREREQ_BTOWC
  fi
  gl_WCHAR_MODULE_INDICATOR([btowc])
  gl___BUILTIN_EXPECT
  gl_BYTESWAP
  gl_C_STRTOD
  gl_CLOCK_TIME
  gl_MODULE_INDICATOR_FOR_TESTS([cloexec])
  gl_FUNC_CLOSE
  if test $REPLACE_CLOSE = 1; then
    AC_LIBOBJ([close])
  fi
  gl_UNISTD_MODULE_INDICATOR([close])
  AC_REQUIRE([gl_HEADER_SYS_SOCKET])
  if test "$ac_cv_header_winsock2_h" = yes; then
    AC_LIBOBJ([connect])
  fi
  gl_SYS_SOCKET_MODULE_INDICATOR([connect])
  gl_AF_ALG
  AC_DEFINE([GL_COMPILE_CRYPTO_STREAM], 1, [Compile Gnulib crypto stream ops.])
  AC_REQUIRE([AC_C_RESTRICT])
  gl_SHA1
  gl_CTYPE_H
  gl_DOUBLE_SLASH_ROOT
  gl_FUNC_DUP2
  if test $REPLACE_DUP2 = 1; then
    AC_LIBOBJ([dup2])
    gl_PREREQ_DUP2
  fi
  gl_UNISTD_MODULE_INDICATOR([dup2])
  gl_ENVIRON
  gl_UNISTD_MODULE_INDICATOR([environ])
  gl_HEADER_ERRNO_H
  AC_REQUIRE([gl_EXTERN_INLINE])
  gl_FUNC_FCNTL
  if test $HAVE_FCNTL = 0 || test $REPLACE_FCNTL = 1; then
    AC_LIBOBJ([fcntl])
  fi
  gl_FCNTL_MODULE_INDICATOR([fcntl])
  gl_FCNTL_H
  gl_FUNC_FFLUSH
  if test $REPLACE_FFLUSH = 1; then
    AC_LIBOBJ([fflush])
    gl_PREREQ_FFLUSH
  fi
  gl_MODULE_INDICATOR([fflush])
  gl_STDIO_MODULE_INDICATOR([fflush])
  AC_C_FLEXIBLE_ARRAY_MEMBER
  gl_FLOAT_H
  if test $REPLACE_FLOAT_LDBL = 1; then
    AC_LIBOBJ([float])
  fi
  if test $REPLACE_ITOLD = 1; then
    AC_LIBOBJ([itold])
  fi
  gl_FUNC_FNMATCH_POSIX
  if test $HAVE_FNMATCH = 0 || test $REPLACE_FNMATCH = 1; then
    AC_LIBOBJ([fnmatch])
    gl_PREREQ_FNMATCH
  fi
  gl_FNMATCH_MODULE_INDICATOR([fnmatch])
  gl_FUNC_FNMATCH_GNU
  if test $HAVE_FNMATCH = 0 || test $REPLACE_FNMATCH = 1; then
    AC_LIBOBJ([fnmatch])
    gl_PREREQ_FNMATCH
  fi
  gl_MODULE_INDICATOR([fnmatch-gnu])
  gl_FNMATCH_H
  gl_FUNC_FPURGE
  if test $HAVE_FPURGE = 0 || test $REPLACE_FPURGE = 1; then
    AC_LIBOBJ([fpurge])
  fi
  gl_STDIO_MODULE_INDICATOR([fpurge])
  gl_FUNC_FREADING
  gl_FUNC_FSEEK
  if test $REPLACE_FSEEK = 1; then
    AC_LIBOBJ([fseek])
  fi
  gl_STDIO_MODULE_INDICATOR([fseek])
  gl_FUNC_FSEEKO
  if test $HAVE_FSEEKO = 0 || test $REPLACE_FSEEKO = 1; then
    AC_LIBOBJ([fseeko])
    gl_PREREQ_FSEEKO
  fi
  gl_STDIO_MODULE_INDICATOR([fseeko])
  gl_FUNC_FSTAT
  if test $REPLACE_FSTAT = 1; then
    AC_LIBOBJ([fstat])
    case "$host_os" in
      mingw*)
        AC_LIBOBJ([stat-w32])
        ;;
    esac
    gl_PREREQ_FSTAT
  fi
  gl_SYS_STAT_MODULE_INDICATOR([fstat])
  gl_FUNC_FTELL
  if test $REPLACE_FTELL = 1; then
    AC_LIBOBJ([ftell])
  fi
  gl_STDIO_MODULE_INDICATOR([ftell])
  gl_FUNC_FTELLO
  if test $HAVE_FTELLO = 0 || test $REPLACE_FTELLO = 1; then
    AC_LIBOBJ([ftello])
    gl_PREREQ_FTELLO
  fi
  gl_STDIO_MODULE_INDICATOR([ftello])
  gl_FUNC_GETDTABLESIZE
  if test $HAVE_GETDTABLESIZE = 0 || test $REPLACE_GETDTABLESIZE = 1; then
    AC_LIBOBJ([getdtablesize])
    gl_PREREQ_GETDTABLESIZE
  fi
  gl_UNISTD_MODULE_INDICATOR([getdtablesize])
  gl_FUNC_GETHOSTNAME
  if test $HAVE_GETHOSTNAME = 0; then
    AC_LIBOBJ([gethostname])
    gl_PREREQ_GETHOSTNAME
  fi
  gl_UNISTD_MODULE_INDICATOR([gethostname])
  AC_REQUIRE([AC_CANONICAL_HOST])
  gl_GETLOADAVG
  if test $HAVE_GETLOADAVG = 0; then
    AC_LIBOBJ([getloadavg])
    gl_PREREQ_GETLOADAVG
  fi
  gl_STDLIB_MODULE_INDICATOR([getloadavg])
  gl_FUNC_GETPAGESIZE
  if test $REPLACE_GETPAGESIZE = 1; then
    AC_LIBOBJ([getpagesize])
  fi
  gl_UNISTD_MODULE_INDICATOR([getpagesize])
  AC_REQUIRE([gl_HEADER_SYS_SOCKET])
  if test "$ac_cv_header_winsock2_h" = yes; then
    AC_LIBOBJ([getpeername])
  fi
  gl_SYS_SOCKET_MODULE_INDICATOR([getpeername])
  AC_REQUIRE([AC_CANONICAL_HOST])
  gl_FUNC_GETRANDOM
  if test $HAVE_GETRANDOM = 0 || test $REPLACE_GETRANDOM = 1; then
    AC_LIBOBJ([getrandom])
  fi
  gl_SYS_RANDOM_MODULE_INDICATOR([getrandom])
  AC_REQUIRE([gl_HEADER_SYS_SOCKET])
  if test "$ac_cv_header_winsock2_h" = yes; then
    AC_LIBOBJ([getsockname])
  fi
  gl_SYS_SOCKET_MODULE_INDICATOR([getsockname])
  AC_REQUIRE([gl_HEADER_SYS_SOCKET])
  if test "$ac_cv_header_winsock2_h" = yes; then
    AC_LIBOBJ([getsockopt])
  fi
  gl_SYS_SOCKET_MODULE_INDICATOR([getsockopt])
  dnl you must add AM_GNU_GETTEXT([external]) or similar to configure.ac.
  AM_GNU_GETTEXT_VERSION([0.20])
  AC_SUBST([LIBINTL])
  AC_SUBST([LTLIBINTL])
  gl_FUNC_GETTIMEOFDAY
  if test $HAVE_GETTIMEOFDAY = 0 || test $REPLACE_GETTIMEOFDAY = 1; then
    AC_LIBOBJ([gettimeofday])
    gl_PREREQ_GETTIMEOFDAY
  fi
  gl_SYS_TIME_MODULE_INDICATOR([gettimeofday])
  gl_GNU_MAKE
  AC_REQUIRE([gl_FUNC_SETLOCALE_NULL])
  LIB_HARD_LOCALE="$LIB_SETLOCALE_NULL"
  AC_SUBST([LIB_HARD_LOCALE])
  AC_DEFUN([gl_HAVE_MODULE_HAVELIB])
  AC_REQUIRE([gl_HOST_CPU_C_ABI])
  AM_ICONV
  m4_ifdef([gl_ICONV_MODULE_INDICATOR],
    [gl_ICONV_MODULE_INDICATOR([iconv])])
  gl_FUNC_INET_NTOP
  if test $HAVE_INET_NTOP = 0 || test $REPLACE_INET_NTOP = 1; then
    AC_LIBOBJ([inet_ntop])
    gl_PREREQ_INET_NTOP
  fi
  gl_ARPA_INET_MODULE_INDICATOR([inet_ntop])
  gl_FUNC_INET_PTON
  if test $HAVE_INET_PTON = 0 || test $REPLACE_INET_PTON = 1; then
    AC_LIBOBJ([inet_pton])
    gl_PREREQ_INET_PTON
  fi
  gl_ARPA_INET_MODULE_INDICATOR([inet_pton])
  gl_INTTYPES_INCOMPLETE
  gl_FUNC_IOCTL
  if test $HAVE_IOCTL = 0 || test $REPLACE_IOCTL = 1; then
    AC_LIBOBJ([ioctl])
  fi
  gl_SYS_IOCTL_MODULE_INDICATOR([ioctl])
  gl_FUNC_ISBLANK
  if test $HAVE_ISBLANK = 0; then
    AC_LIBOBJ([isblank])
  fi
  gl_MODULE_INDICATOR([isblank])
  gl_CTYPE_MODULE_INDICATOR([isblank])
  gl_LANGINFO_H
  AC_REQUIRE([gl_LARGEFILE])
  gl___INLINE
  gl_LIBSIGSEGV
  gl_LIBUNISTRING_OPTIONAL
  gl_LIMITS_H
  gl_FUNC_LINK_FOLLOWS_SYMLINK
  AC_REQUIRE([gl_HEADER_SYS_SOCKET])
  if test "$ac_cv_header_winsock2_h" = yes; then
    AC_LIBOBJ([listen])
  fi
  gl_SYS_SOCKET_MODULE_INDICATOR([listen])
  gl_LOCALCHARSET
  dnl For backward compatibility. Some packages still use this.
  LOCALCHARSET_TESTS_ENVIRONMENT=
  AC_SUBST([LOCALCHARSET_TESTS_ENVIRONMENT])
  gl_LOCALE_H
  gl_FUNC_LOCALECONV
  if test $REPLACE_LOCALECONV = 1; then
    AC_LIBOBJ([localeconv])
    gl_PREREQ_LOCALECONV
  fi
  gl_LOCALE_MODULE_INDICATOR([localeconv])
  gl_LOCK
  gl_MODULE_INDICATOR([lock])
  gl_FUNC_LSEEK
  if test $REPLACE_LSEEK = 1; then
    AC_LIBOBJ([lseek])
  fi
  gl_UNISTD_MODULE_INDICATOR([lseek])
  gl_FUNC_LSTAT
  if test $REPLACE_LSTAT = 1; then
    AC_LIBOBJ([lstat])
    gl_PREREQ_LSTAT
  fi
  gl_SYS_STAT_MODULE_INDICATOR([lstat])
  gl_FUNC_MALLOC_POSIX
  if test $REPLACE_MALLOC = 1; then
    AC_LIBOBJ([malloc])
  fi
  gl_STDLIB_MODULE_INDICATOR([malloc-posix])
  gl_MALLOCA
  gl_MATH_H
  gl_FUNC_MBRTOWC
  if test $HAVE_MBRTOWC = 0 || test $REPLACE_MBRTOWC = 1; then
    AC_LIBOBJ([mbrtowc])
    if test $REPLACE_MBSTATE_T = 1; then
      AC_LIBOBJ([lc-charset-dispatch])
      AC_LIBOBJ([mbtowc-lock])
      gl_PREREQ_MBTOWC_LOCK
    fi
    gl_PREREQ_MBRTOWC
  fi
  gl_WCHAR_MODULE_INDICATOR([mbrtowc])
  gl_FUNC_MBSINIT
  if test $HAVE_MBSINIT = 0 || test $REPLACE_MBSINIT = 1; then
    AC_LIBOBJ([mbsinit])
    gl_PREREQ_MBSINIT
  fi
  gl_WCHAR_MODULE_INDICATOR([mbsinit])
  gl_FUNC_MBSRTOWCS
  if test $HAVE_MBSRTOWCS = 0 || test $REPLACE_MBSRTOWCS = 1; then
    AC_LIBOBJ([mbsrtowcs])
    AC_LIBOBJ([mbsrtowcs-state])
    gl_PREREQ_MBSRTOWCS
  fi
  gl_WCHAR_MODULE_INDICATOR([mbsrtowcs])
  gl_FUNC_MBTOWC
  if test $HAVE_MBTOWC = 0 || test $REPLACE_MBTOWC = 1; then
    AC_LIBOBJ([mbtowc])
    gl_PREREQ_MBTOWC
  fi
  gl_STDLIB_MODULE_INDICATOR([mbtowc])
  gl_FUNC_MEMCHR
  if test $REPLACE_MEMCHR = 1; then
    AC_LIBOBJ([memchr])
    gl_PREREQ_MEMCHR
  fi
  gl_STRING_MODULE_INDICATOR([memchr])
  gl_FUNC_MEMPCPY
  if test $HAVE_MEMPCPY = 0; then
    AC_LIBOBJ([mempcpy])
    gl_PREREQ_MEMPCPY
  fi
  gl_STRING_MODULE_INDICATOR([mempcpy])
  gl_MINMAX
  gl_FUNC_MKDIR
  if test $REPLACE_MKDIR = 1; then
    AC_LIBOBJ([mkdir])
  fi
  gl_FUNC_MKDTEMP
  if test $HAVE_MKDTEMP = 0; then
    AC_LIBOBJ([mkdtemp])
    gl_PREREQ_MKDTEMP
  fi
  gl_STDLIB_MODULE_INDICATOR([mkdtemp])
  gl_FUNC_MKFIFO
  if test $HAVE_MKFIFO = 0 || test $REPLACE_MKFIFO = 1; then
    AC_LIBOBJ([mkfifo])
  fi
  gl_UNISTD_MODULE_INDICATOR([mkfifo])
  gl_FUNC_MKNOD
  if test $HAVE_MKNOD = 0 || test $REPLACE_MKNOD = 1; then
    AC_LIBOBJ([mknod])
  fi
  gl_UNISTD_MODULE_INDICATOR([mknod])
  gl_FUNC_MKSTEMP
  if test $HAVE_MKSTEMP = 0 || test $REPLACE_MKSTEMP = 1; then
    AC_LIBOBJ([mkstemp])
    gl_PREREQ_MKSTEMP
  fi
  gl_STDLIB_MODULE_INDICATOR([mkstemp])
  gl_FUNC_MKTIME
  if test $REPLACE_MKTIME = 1; then
    AC_LIBOBJ([mktime])
    gl_PREREQ_MKTIME
  fi
  gl_TIME_MODULE_INDICATOR([mktime])
  gl_FUNC_MKTIME_INTERNAL
  if test $WANT_MKTIME_INTERNAL = 1; then
    AC_LIBOBJ([mktime])
    gl_PREREQ_MKTIME
  fi
  AC_REQUIRE([gl_MSVC_INVAL])
  if test $HAVE_MSVC_INVALID_PARAMETER_HANDLER = 1; then
    AC_LIBOBJ([msvc-inval])
  fi
  AC_REQUIRE([gl_MSVC_NOTHROW])
  if test $HAVE_MSVC_INVALID_PARAMETER_HANDLER = 1; then
    AC_LIBOBJ([msvc-nothrow])
  fi
  gl_MODULE_INDICATOR([msvc-nothrow])
  gl_MULTIARCH
  gl_HEADER_NETINET_IN
  AC_PROG_MKDIR_P
  gl_FUNC_NL_LANGINFO
  if test $HAVE_NL_LANGINFO = 0 || test $REPLACE_NL_LANGINFO = 1; then
    AC_LIBOBJ([nl_langinfo])
  fi
  if test $REPLACE_NL_LANGINFO = 1 && test $NL_LANGINFO_MTSAFE = 0; then
    AC_LIBOBJ([nl_langinfo-lock])
    gl_PREREQ_NL_LANGINFO_LOCK
  fi
  gl_LANGINFO_MODULE_INDICATOR([nl_langinfo])
  gt_NO_CXX
  gl_FUNC_GNU_STRFTIME
  gl_FUNC_OPEN
  if test $REPLACE_OPEN = 1; then
    AC_LIBOBJ([open])
    gl_PREREQ_OPEN
  fi
  gl_FCNTL_MODULE_INDICATOR([open])
  gl_PATHMAX
  gl_FUNC_READLINK
  if test $HAVE_READLINK = 0 || test $REPLACE_READLINK = 1; then
    AC_LIBOBJ([readlink])
    gl_PREREQ_READLINK
  fi
  gl_UNISTD_MODULE_INDICATOR([readlink])
  AC_REQUIRE([gl_HEADER_SYS_SOCKET])
  if test "$ac_cv_header_winsock2_h" = yes; then
    AC_LIBOBJ([recv])
  fi
  gl_SYS_SOCKET_MODULE_INDICATOR([recv])
  AC_REQUIRE([gl_HEADER_SYS_SOCKET])
  if test "$ac_cv_header_winsock2_h" = yes; then
    AC_LIBOBJ([recvfrom])
  fi
  gl_SYS_SOCKET_MODULE_INDICATOR([recvfrom])
  gl_REGEX
  if test $ac_use_included_regex = yes; then
    AC_LIBOBJ([regex])
    gl_PREREQ_REGEX
  fi
  gl_FUNC_SELECT
  if test $REPLACE_SELECT = 1; then
    AC_LIBOBJ([select])
  fi
  gl_SYS_SELECT_MODULE_INDICATOR([select])
  AC_REQUIRE([gl_HEADER_SYS_SOCKET])
  if test "$ac_cv_header_winsock2_h" = yes; then
    AC_LIBOBJ([send])
  fi
  gl_SYS_SOCKET_MODULE_INDICATOR([send])
  AC_REQUIRE([gl_HEADER_SYS_SOCKET])
  if test "$ac_cv_header_winsock2_h" = yes; then
    AC_LIBOBJ([sendto])
  fi
  gl_SYS_SOCKET_MODULE_INDICATOR([sendto])
  gl_FUNC_SETENV
  if test $HAVE_SETENV = 0 || test $REPLACE_SETENV = 1; then
    AC_LIBOBJ([setenv])
  fi
  gl_STDLIB_MODULE_INDICATOR([setenv])
  gl_FUNC_SETLOCALE_NULL
  if test $SETLOCALE_NULL_ALL_MTSAFE = 0 || test $SETLOCALE_NULL_ONE_MTSAFE = 0; then
    AC_LIBOBJ([setlocale-lock])
    gl_PREREQ_SETLOCALE_LOCK
  fi
  gl_LOCALE_MODULE_INDICATOR([setlocale_null])
  AC_REQUIRE([gl_HEADER_SYS_SOCKET])
  if test "$ac_cv_header_winsock2_h" = yes; then
    AC_LIBOBJ([setsockopt])
  fi
  gl_SYS_SOCKET_MODULE_INDICATOR([setsockopt])
  AC_REQUIRE([gl_HEADER_SYS_SOCKET])
  if test "$ac_cv_header_winsock2_h" = yes; then
    AC_LIBOBJ([shutdown])
  fi
  gl_SYS_SOCKET_MODULE_INDICATOR([shutdown])
  gl_SIGNAL_H
  AC_REQUIRE([gl_HEADER_SYS_SOCKET])
  if test "$ac_cv_header_winsock2_h" = yes; then
    AC_LIBOBJ([socket])
  fi
  # When this module is used, sockets may actually occur as file descriptors,
  # hence it is worth warning if the modules 'close' and 'ioctl' are not used.
  m4_ifdef([gl_UNISTD_H_DEFAULTS], [AC_REQUIRE([gl_UNISTD_H_DEFAULTS])])
  m4_ifdef([gl_SYS_IOCTL_H_DEFAULTS], [AC_REQUIRE([gl_SYS_IOCTL_H_DEFAULTS])])
  AC_REQUIRE([gl_PREREQ_SYS_H_WINSOCK2])
  if test "$ac_cv_header_winsock2_h" = yes; then
    UNISTD_H_HAVE_WINSOCK2_H_AND_USE_SOCKETS=1
    SYS_IOCTL_H_HAVE_WINSOCK2_H_AND_USE_SOCKETS=1
  fi
  gl_SYS_SOCKET_MODULE_INDICATOR([socket])
  AC_REQUIRE([gl_SOCKETLIB])
  AC_REQUIRE([gl_SOCKETS])
  gl_TYPE_SOCKLEN_T
  gt_TYPE_SSIZE_T
  gl_FUNC_STAT
  if test $REPLACE_STAT = 1; then
    AC_LIBOBJ([stat])
    case "$host_os" in
      mingw*)
        AC_LIBOBJ([stat-w32])
        ;;
    esac
    gl_PREREQ_STAT
  fi
  gl_SYS_STAT_MODULE_INDICATOR([stat])
  gl_STAT_TIME
  gl_STAT_BIRTHTIME
  gl_STDALIGN_H
  AM_STDBOOL_H
  gl_STDDEF_H
  gl_STDINT_H
  gl_STDIO_H
  gl_STDLIB_H
  gl_STRCASE
  if test $HAVE_STRCASECMP = 0; then
    AC_LIBOBJ([strcasecmp])
    gl_PREREQ_STRCASECMP
  fi
  if test $HAVE_STRNCASECMP = 0; then
    AC_LIBOBJ([strncasecmp])
    gl_PREREQ_STRNCASECMP
  fi
  gl_FUNC_STRDUP_POSIX
  if test $REPLACE_STRDUP = 1; then
    AC_LIBOBJ([strdup])
    gl_PREREQ_STRDUP
  fi
  gl_STRING_MODULE_INDICATOR([strdup])
  AC_REQUIRE([gl_HEADER_ERRNO_H])
  AC_REQUIRE([gl_FUNC_STRERROR_0])
  if test -n "$ERRNO_H" || test $REPLACE_STRERROR_0 = 1; then
    AC_LIBOBJ([strerror-override])
    gl_PREREQ_SYS_H_WINSOCK2
  fi
  gl_FUNC_STRERROR_R
  if test $HAVE_DECL_STRERROR_R = 0 || test $REPLACE_STRERROR_R = 1; then
    AC_LIBOBJ([strerror_r])
    gl_PREREQ_STRERROR_R
  fi
  gl_STRING_MODULE_INDICATOR([strerror_r])
  dnl For the modules argp, error.
  gl_MODULE_INDICATOR([strerror_r-posix])
  gl_HEADER_STRING_H
  gl_HEADER_STRINGS_H
  gl_FUNC_STRNLEN
  if test $HAVE_DECL_STRNLEN = 0 || test $REPLACE_STRNLEN = 1; then
    AC_LIBOBJ([strnlen])
    gl_PREREQ_STRNLEN
  fi
  gl_STRING_MODULE_INDICATOR([strnlen])
  gl_FUNC_STRPTIME
  if test $HAVE_STRPTIME = 0; then
    AC_LIBOBJ([strptime])
    gl_PREREQ_STRPTIME
  fi
  gl_TIME_MODULE_INDICATOR([strptime])
  gl_FUNC_STRTOD
  if test $HAVE_STRTOD = 0 || test $REPLACE_STRTOD = 1; then
    AC_LIBOBJ([strtod])
    gl_PREREQ_STRTOD
  fi
  gl_STDLIB_MODULE_INDICATOR([strtod])
  gl_FUNC_STRVERSCMP
  if test $HAVE_STRVERSCMP = 0; then
    AC_LIBOBJ([strverscmp])
    gl_PREREQ_STRVERSCMP
  fi
  gl_STRING_MODULE_INDICATOR([strverscmp])
  gl_SYS_IOCTL_H
  AC_PROG_MKDIR_P
  gl_HEADER_SYS_RANDOM
  AC_PROG_MKDIR_P
  AC_REQUIRE([gl_HEADER_SYS_SELECT])
  AC_PROG_MKDIR_P
  AC_REQUIRE([gl_HEADER_SYS_SOCKET])
  AC_PROG_MKDIR_P
  gl_HEADER_SYS_STAT_H
  AC_PROG_MKDIR_P
  gl_HEADER_SYS_TIME_H
  AC_PROG_MKDIR_P
  gl_SYS_TYPES_H
  AC_PROG_MKDIR_P
  gl_HEADER_SYS_UIO
  AC_PROG_MKDIR_P
  gl_SYS_UTSNAME_H
  AC_PROG_MKDIR_P
  gl_SYS_WAIT_H
  AC_PROG_MKDIR_P
  gl_FUNC_GEN_TEMPNAME
  gl_MODULE_INDICATOR([tempname])
  AC_REQUIRE([gl_THREADLIB])
  gl_HEADER_TIME_H
  gl_TIME_R
  if test $HAVE_LOCALTIME_R = 0 || test $REPLACE_LOCALTIME_R = 1; then
    AC_LIBOBJ([time_r])
    gl_PREREQ_TIME_R
  fi
  gl_TIME_MODULE_INDICATOR([time_r])
  gl_TIME_RZ
  if test $HAVE_TIMEZONE_T = 0; then
    AC_LIBOBJ([time_rz])
  fi
  gl_TIME_MODULE_INDICATOR([time_rz])
  gl_FUNC_TIMEGM
  if test $HAVE_TIMEGM = 0 || test $REPLACE_TIMEGM = 1; then
    AC_LIBOBJ([timegm])
    gl_PREREQ_TIMEGM
  fi
  gl_TIME_MODULE_INDICATOR([timegm])
  gl_FUNC_TZSET
  if test $REPLACE_TZSET = 1; then
    AC_LIBOBJ([tzset])
  fi
  gl_TIME_MODULE_INDICATOR([tzset])
  gl_FUNC_UNAME
  if test $HAVE_UNAME = 0; then
    AC_LIBOBJ([uname])
    gl_PREREQ_UNAME
  fi
  gl_SYS_UTSNAME_MODULE_INDICATOR([uname])
  gl_LIBUNISTRING_LIBHEADER([0.9.5], [uniname.h])
  gl_LIBUNISTRING_MODULE([0.9.8], [uniname/uniname])
  gl_UNISTD_H
  gl_LIBUNISTRING_LIBHEADER([0.9.4], [unitypes.h])
  gl_LIBUNISTRING_LIBHEADER([0.9.4], [uniwidth.h])
  gl_LIBUNISTRING_MODULE([0.9.8], [uniwidth/width])
  gl_FUNC_UNSETENV
  if test $HAVE_UNSETENV = 0 || test $REPLACE_UNSETENV = 1; then
    AC_LIBOBJ([unsetenv])
    gl_PREREQ_UNSETENV
  fi
  gl_STDLIB_MODULE_INDICATOR([unsetenv])
  gl_FUNC_MMAP_ANON
  AC_REQUIRE([AC_C_INLINE])
  AC_CHECK_FUNCS_ONCE([mquery pstat_getprocvm])
  gl_WCHAR_H
  gl_FUNC_WCRTOMB
  if test $HAVE_WCRTOMB = 0 || test $REPLACE_WCRTOMB = 1; then
    AC_LIBOBJ([wcrtomb])
    gl_PREREQ_WCRTOMB
  fi
  gl_WCHAR_MODULE_INDICATOR([wcrtomb])
  gl_WCTYPE_H
  AC_REQUIRE([AC_CANONICAL_HOST])
  case "$host_os" in
    mingw*)
      AC_LIBOBJ([windows-mutex])
      ;;
  esac
  AC_REQUIRE([AC_CANONICAL_HOST])
  case "$host_os" in
    mingw*)
      AC_LIBOBJ([windows-once])
      ;;
  esac
  AC_REQUIRE([AC_CANONICAL_HOST])
  case "$host_os" in
    mingw*)
      AC_LIBOBJ([windows-recmutex])
      ;;
  esac
  AC_REQUIRE([AC_CANONICAL_HOST])
  case "$host_os" in
    mingw*)
      AC_LIBOBJ([windows-rwlock])
      ;;
  esac
  gl_FUNC_WMEMCHR
  if test $HAVE_WMEMCHR = 0; then
    AC_LIBOBJ([wmemchr])
  fi
  gl_WCHAR_MODULE_INDICATOR([wmemchr])
  gl_FUNC_WMEMPCPY
  if test $HAVE_WMEMPCPY = 0; then
    AC_LIBOBJ([wmempcpy])
  fi
  gl_WCHAR_MODULE_INDICATOR([wmempcpy])
  # End of code from modules
  m4_ifval(gl_LIBSOURCES_LIST, [
    m4_syscmd([test ! -d ]m4_defn([gl_LIBSOURCES_DIR])[ ||
      for gl_file in ]gl_LIBSOURCES_LIST[ ; do
        if test ! -r ]m4_defn([gl_LIBSOURCES_DIR])[/$gl_file ; then
          echo "missing file ]m4_defn([gl_LIBSOURCES_DIR])[/$gl_file" >&2
          exit 1
        fi
      done])dnl
      m4_if(m4_sysval, [0], [],
        [AC_FATAL([expected source file, required through AC_LIBSOURCES, not found])])
  ])
  m4_popdef([gl_LIBSOURCES_DIR])
  m4_popdef([gl_LIBSOURCES_LIST])
  m4_popdef([AC_LIBSOURCES])
  m4_popdef([AC_REPLACE_FUNCS])
  m4_popdef([AC_LIBOBJ])
  AC_CONFIG_COMMANDS_PRE([
    gl_libobjs=
    gl_ltlibobjs=
    if test -n "$gl_LIBOBJS"; then
      # Remove the extension.
      sed_drop_objext='s/\.o$//;s/\.obj$//'
      for i in `for i in $gl_LIBOBJS; do echo "$i"; done | sed -e "$sed_drop_objext" | sort | uniq`; do
        gl_libobjs="$gl_libobjs $i.$ac_objext"
        gl_ltlibobjs="$gl_ltlibobjs $i.lo"
      done
    fi
    AC_SUBST([gl_LIBOBJS], [$gl_libobjs])
    AC_SUBST([gl_LTLIBOBJS], [$gl_ltlibobjs])
  ])
  gltests_libdeps=
  gltests_ltlibdeps=
  m4_pushdef([AC_LIBOBJ], m4_defn([gltests_LIBOBJ]))
  m4_pushdef([AC_REPLACE_FUNCS], m4_defn([gltests_REPLACE_FUNCS]))
  m4_pushdef([AC_LIBSOURCES], m4_defn([gltests_LIBSOURCES]))
  m4_pushdef([gltests_LIBSOURCES_LIST], [])
  m4_pushdef([gltests_LIBSOURCES_DIR], [])
  gl_COMMON
  gl_source_base='tests'
changequote(,)dnl
  gltests_WITNESS=IN_`echo "${PACKAGE-$PACKAGE_TARNAME}" | LC_ALL=C tr abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ | LC_ALL=C sed -e 's/[^A-Z0-9_]/_/g'`_GNULIB_TESTS
changequote([, ])dnl
  AC_SUBST([gltests_WITNESS])
  gl_module_indicator_condition=$gltests_WITNESS
  m4_pushdef([gl_MODULE_INDICATOR_CONDITION], [$gl_module_indicator_condition])
  m4_popdef([gl_MODULE_INDICATOR_CONDITION])
  m4_ifval(gltests_LIBSOURCES_LIST, [
    m4_syscmd([test ! -d ]m4_defn([gltests_LIBSOURCES_DIR])[ ||
      for gl_file in ]gltests_LIBSOURCES_LIST[ ; do
        if test ! -r ]m4_defn([gltests_LIBSOURCES_DIR])[/$gl_file ; then
          echo "missing file ]m4_defn([gltests_LIBSOURCES_DIR])[/$gl_file" >&2
          exit 1
        fi
      done])dnl
      m4_if(m4_sysval, [0], [],
        [AC_FATAL([expected source file, required through AC_LIBSOURCES, not found])])
  ])
  m4_popdef([gltests_LIBSOURCES_DIR])
  m4_popdef([gltests_LIBSOURCES_LIST])
  m4_popdef([AC_LIBSOURCES])
  m4_popdef([AC_REPLACE_FUNCS])
  m4_popdef([AC_LIBOBJ])
  AC_CONFIG_COMMANDS_PRE([
    gltests_libobjs=
    gltests_ltlibobjs=
    if test -n "$gltests_LIBOBJS"; then
      # Remove the extension.
      sed_drop_objext='s/\.o$//;s/\.obj$//'
      for i in `for i in $gltests_LIBOBJS; do echo "$i"; done | sed -e "$sed_drop_objext" | sort | uniq`; do
        gltests_libobjs="$gltests_libobjs $i.$ac_objext"
        gltests_ltlibobjs="$gltests_ltlibobjs $i.lo"
      done
    fi
    AC_SUBST([gltests_LIBOBJS], [$gltests_libobjs])
    AC_SUBST([gltests_LTLIBOBJS], [$gltests_ltlibobjs])
  ])
  LIBGNU_LIBDEPS="$gl_libdeps"
  AC_SUBST([LIBGNU_LIBDEPS])
  LIBGNU_LTLIBDEPS="$gl_ltlibdeps"
  AC_SUBST([LIBGNU_LTLIBDEPS])
])

# Like AC_LIBOBJ, except that the module name goes
# into gl_LIBOBJS instead of into LIBOBJS.
AC_DEFUN([gl_LIBOBJ], [
  AS_LITERAL_IF([$1], [gl_LIBSOURCES([$1.c])])dnl
  gl_LIBOBJS="$gl_LIBOBJS $1.$ac_objext"
])

# Like AC_REPLACE_FUNCS, except that the module name goes
# into gl_LIBOBJS instead of into LIBOBJS.
AC_DEFUN([gl_REPLACE_FUNCS], [
  m4_foreach_w([gl_NAME], [$1], [AC_LIBSOURCES(gl_NAME[.c])])dnl
  AC_CHECK_FUNCS([$1], , [gl_LIBOBJ($ac_func)])
])

# Like AC_LIBSOURCES, except the directory where the source file is
# expected is derived from the gnulib-tool parameterization,
# and alloca is special cased (for the alloca-opt module).
# We could also entirely rely on EXTRA_lib..._SOURCES.
AC_DEFUN([gl_LIBSOURCES], [
  m4_foreach([_gl_NAME], [$1], [
    m4_if(_gl_NAME, [alloca.c], [], [
      m4_define([gl_LIBSOURCES_DIR], [src/gllib])
      m4_append([gl_LIBSOURCES_LIST], _gl_NAME, [ ])
    ])
  ])
])

# Like AC_LIBOBJ, except that the module name goes
# into gltests_LIBOBJS instead of into LIBOBJS.
AC_DEFUN([gltests_LIBOBJ], [
  AS_LITERAL_IF([$1], [gltests_LIBSOURCES([$1.c])])dnl
  gltests_LIBOBJS="$gltests_LIBOBJS $1.$ac_objext"
])

# Like AC_REPLACE_FUNCS, except that the module name goes
# into gltests_LIBOBJS instead of into LIBOBJS.
AC_DEFUN([gltests_REPLACE_FUNCS], [
  m4_foreach_w([gl_NAME], [$1], [AC_LIBSOURCES(gl_NAME[.c])])dnl
  AC_CHECK_FUNCS([$1], , [gltests_LIBOBJ($ac_func)])
])

# Like AC_LIBSOURCES, except the directory where the source file is
# expected is derived from the gnulib-tool parameterization,
# and alloca is special cased (for the alloca-opt module).
# We could also entirely rely on EXTRA_lib..._SOURCES.
AC_DEFUN([gltests_LIBSOURCES], [
  m4_foreach([_gl_NAME], [$1], [
    m4_if(_gl_NAME, [alloca.c], [], [
      m4_define([gltests_LIBSOURCES_DIR], [tests])
      m4_append([gltests_LIBSOURCES_LIST], _gl_NAME, [ ])
    ])
  ])
])

# This macro records the list of files which have been installed by
# gnulib-tool and may be removed by future gnulib-tool invocations.
AC_DEFUN([gl_FILE_LIST], [
  build-aux/config.rpath
  lib/_Noreturn.h
  lib/accept.c
  lib/af_alg.c
  lib/af_alg.h
  lib/alloca.c
  lib/alloca.in.h
  lib/arg-nonnull.h
  lib/arpa_inet.in.h
  lib/attribute.h
  lib/basename-lgpl.c
  lib/basename-lgpl.h
  lib/bind.c
  lib/btowc.c
  lib/byteswap.in.h
  lib/c++defs.h
  lib/c-ctype.c
  lib/c-ctype.h
  lib/c-strtod.c
  lib/c-strtod.h
  lib/cdefs.h
  lib/cloexec.c
  lib/cloexec.h
  lib/close.c
  lib/connect.c
  lib/ctype.in.h
  lib/dirname-lgpl.c
  lib/dirname.h
  lib/dup2.c
  lib/errno.in.h
  lib/fcntl.c
  lib/fcntl.in.h
  lib/fd-hook.c
  lib/fd-hook.h
  lib/fflush.c
  lib/filename.h
  lib/flexmember.h
  lib/float.c
  lib/float.in.h
  lib/fnmatch.c
  lib/fnmatch.in.h
  lib/fnmatch_loop.c
  lib/fpurge.c
  lib/freading.c
  lib/freading.h
  lib/fseek.c
  lib/fseeko.c
  lib/fstat.c
  lib/ftell.c
  lib/ftello.c
  lib/getdtablesize.c
  lib/gethostname.c
  lib/getloadavg.c
  lib/getpagesize.c
  lib/getpeername.c
  lib/getrandom.c
  lib/getsockname.c
  lib/getsockopt.c
  lib/gettext.h
  lib/gettimeofday.c
  lib/gl_openssl.h
  lib/glthread/lock.c
  lib/glthread/lock.h
  lib/glthread/threadlib.c
  lib/hard-locale.c
  lib/hard-locale.h
  lib/inet_ntop.c
  lib/inet_pton.c
  lib/intprops.h
  lib/inttypes.in.h
  lib/ioctl.c
  lib/isblank.c
  lib/itold.c
  lib/langinfo.in.h
  lib/lc-charset-dispatch.c
  lib/lc-charset-dispatch.h
  lib/libc-config.h
  lib/libunistring.valgrind
  lib/limits.in.h
  lib/listen.c
  lib/localcharset.c
  lib/localcharset.h
  lib/locale.in.h
  lib/localeconv.c
  lib/lseek.c
  lib/lstat.c
  lib/malloc.c
  lib/malloca.c
  lib/malloca.h
  lib/math.c
  lib/math.in.h
  lib/mbrtowc-impl-utf8.h
  lib/mbrtowc-impl.h
  lib/mbrtowc.c
  lib/mbsinit.c
  lib/mbsrtowcs-impl.h
  lib/mbsrtowcs-state.c
  lib/mbsrtowcs.c
  lib/mbtowc-impl.h
  lib/mbtowc-lock.c
  lib/mbtowc-lock.h
  lib/mbtowc.c
  lib/memchr.c
  lib/memchr.valgrind
  lib/mempcpy.c
  lib/minmax.h
  lib/mkdir.c
  lib/mkdtemp.c
  lib/mkfifo.c
  lib/mknod.c
  lib/mkstemp.c
  lib/mktime-internal.h
  lib/mktime.c
  lib/msvc-inval.c
  lib/msvc-inval.h
  lib/msvc-nothrow.c
  lib/msvc-nothrow.h
  lib/netinet_in.in.h
  lib/nl_langinfo-lock.c
  lib/nl_langinfo.c
  lib/noreturn.h
  lib/nstrftime.c
  lib/open.c
  lib/pathmax.h
  lib/readlink.c
  lib/recv.c
  lib/recvfrom.c
  lib/regcomp.c
  lib/regex.c
  lib/regex.h
  lib/regex_internal.c
  lib/regex_internal.h
  lib/regexec.c
  lib/select.c
  lib/send.c
  lib/sendto.c
  lib/setenv.c
  lib/setlocale-lock.c
  lib/setlocale_null.c
  lib/setlocale_null.h
  lib/setsockopt.c
  lib/sha1.c
  lib/sha1.h
  lib/shutdown.c
  lib/signal.in.h
  lib/socket.c
  lib/sockets.c
  lib/sockets.h
  lib/stat-time.c
  lib/stat-time.h
  lib/stat-w32.c
  lib/stat-w32.h
  lib/stat.c
  lib/stdalign.in.h
  lib/stdbool.in.h
  lib/stddef.in.h
  lib/stdint.in.h
  lib/stdio-impl.h
  lib/stdio.in.h
  lib/stdlib.in.h
  lib/strcasecmp.c
  lib/strdup.c
  lib/streq.h
  lib/strerror-override.c
  lib/strerror-override.h
  lib/strerror_r.c
  lib/strftime.h
  lib/string.in.h
  lib/strings.in.h
  lib/stripslash.c
  lib/strncasecmp.c
  lib/strnlen.c
  lib/strnlen1.c
  lib/strnlen1.h
  lib/strptime.c
  lib/strtod.c
  lib/strverscmp.c
  lib/sys-limits.h
  lib/sys_ioctl.in.h
  lib/sys_random.in.h
  lib/sys_select.in.h
  lib/sys_socket.c
  lib/sys_socket.in.h
  lib/sys_stat.in.h
  lib/sys_time.in.h
  lib/sys_types.in.h
  lib/sys_uio.in.h
  lib/sys_utsname.in.h
  lib/sys_wait.in.h
  lib/tempname.c
  lib/tempname.h
  lib/time-internal.h
  lib/time.in.h
  lib/time_r.c
  lib/time_rz.c
  lib/timegm.c
  lib/tzset.c
  lib/uname.c
  lib/uniname.in.h
  lib/uniname/gen-uninames.lisp
  lib/uniname/uniname.c
  lib/uniname/uninames.h
  lib/unistd.c
  lib/unistd.in.h
  lib/unitypes.in.h
  lib/uniwidth.in.h
  lib/uniwidth/cjk.h
  lib/uniwidth/width.c
  lib/unsetenv.c
  lib/unused-parameter.h
  lib/verify.h
  lib/vma-iter.c
  lib/vma-iter.h
  lib/w32sock.h
  lib/warn-on-use.h
  lib/wchar.in.h
  lib/wcrtomb.c
  lib/wctype-h.c
  lib/wctype.in.h
  lib/windows-initguard.h
  lib/windows-mutex.c
  lib/windows-mutex.h
  lib/windows-once.c
  lib/windows-once.h
  lib/windows-recmutex.c
  lib/windows-recmutex.h
  lib/windows-rwlock.c
  lib/windows-rwlock.h
  lib/wmemchr-impl.h
  lib/wmemchr.c
  lib/wmempcpy.c
  lib/xalloc-oversized.h
  m4/00gnulib.m4
  m4/__inline.m4
  m4/absolute-header.m4
  m4/af_alg.m4
  m4/alloca.m4
  m4/arpa_inet_h.m4
  m4/asm-underscore.m4
  m4/btowc.m4
  m4/builtin-expect.m4
  m4/byteswap.m4
  m4/c-strtod.m4
  m4/clock_time.m4
  m4/close.m4
  m4/codeset.m4
  m4/ctype.m4
  m4/double-slash-root.m4
  m4/dup2.m4
  m4/eealloc.m4
  m4/environ.m4
  m4/errno_h.m4
  m4/extensions.m4
  m4/extern-inline.m4
  m4/fcntl-o.m4
  m4/fcntl.m4
  m4/fcntl_h.m4
  m4/fflush.m4
  m4/flexmember.m4
  m4/float_h.m4
  m4/fnmatch.m4
  m4/fnmatch_h.m4
  m4/fpurge.m4
  m4/freading.m4
  m4/fseek.m4
  m4/fseeko.m4
  m4/fstat.m4
  m4/ftell.m4
  m4/ftello.m4
  m4/getdtablesize.m4
  m4/gethostname.m4
  m4/getloadavg.m4
  m4/getpagesize.m4
  m4/getrandom.m4
  m4/gettext.m4
  m4/gettimeofday.m4
  m4/gl-openssl.m4
  m4/glibc21.m4
  m4/gnu-make.m4
  m4/gnulib-common.m4
  m4/host-cpu-c-abi.m4
  m4/iconv.m4
  m4/include_next.m4
  m4/inet_ntop.m4
  m4/inet_pton.m4
  m4/intl-thread-locale.m4
  m4/intlmacosx.m4
  m4/inttypes.m4
  m4/ioctl.m4
  m4/isblank.m4
  m4/langinfo_h.m4
  m4/largefile.m4
  m4/ldexp.m4
  m4/lib-ld.m4
  m4/lib-link.m4
  m4/lib-prefix.m4
  m4/libsigsegv.m4
  m4/libunistring-base.m4
  m4/libunistring-optional.m4
  m4/libunistring.m4
  m4/limits-h.m4
  m4/link-follow.m4
  m4/localcharset.m4
  m4/locale-fr.m4
  m4/locale-ja.m4
  m4/locale-zh.m4
  m4/locale_h.m4
  m4/localeconv.m4
  m4/lock.m4
  m4/lseek.m4
  m4/lstat.m4
  m4/malloc.m4
  m4/malloca.m4
  m4/math_h.m4
  m4/mbrtowc.m4
  m4/mbsinit.m4
  m4/mbsrtowcs.m4
  m4/mbstate_t.m4
  m4/mbtowc.m4
  m4/memchr.m4
  m4/mempcpy.m4
  m4/minmax.m4
  m4/mkdir.m4
  m4/mkdtemp.m4
  m4/mkfifo.m4
  m4/mknod.m4
  m4/mkstemp.m4
  m4/mktime.m4
  m4/mmap-anon.m4
  m4/mode_t.m4
  m4/msvc-inval.m4
  m4/msvc-nothrow.m4
  m4/multiarch.m4
  m4/netinet_in_h.m4
  m4/nl_langinfo.m4
  m4/nls.m4
  m4/no-c++.m4
  m4/nocrash.m4
  m4/nstrftime.m4
  m4/off_t.m4
  m4/open-cloexec.m4
  m4/open-slash.m4
  m4/open.m4
  m4/pathmax.m4
  m4/pid_t.m4
  m4/po.m4
  m4/progtest.m4
  m4/pthread_rwlock_rdlock.m4
  m4/readlink.m4
  m4/regex.m4
  m4/select.m4
  m4/setenv.m4
  m4/setlocale_null.m4
  m4/sha1.m4
  m4/signal_h.m4
  m4/socketlib.m4
  m4/sockets.m4
  m4/socklen.m4
  m4/sockpfaf.m4
  m4/ssize_t.m4
  m4/stat-time.m4
  m4/stat.m4
  m4/std-gnu11.m4
  m4/stdalign.m4
  m4/stdbool.m4
  m4/stddef_h.m4
  m4/stdint.m4
  m4/stdio_h.m4
  m4/stdlib_h.m4
  m4/strcase.m4
  m4/strdup.m4
  m4/strerror.m4
  m4/strerror_r.m4
  m4/string_h.m4
  m4/strings_h.m4
  m4/strnlen.m4
  m4/strptime.m4
  m4/strtod.m4
  m4/strverscmp.m4
  m4/sys_ioctl_h.m4
  m4/sys_random_h.m4
  m4/sys_select_h.m4
  m4/sys_socket_h.m4
  m4/sys_stat_h.m4
  m4/sys_time_h.m4
  m4/sys_types_h.m4
  m4/sys_uio_h.m4
  m4/sys_utsname_h.m4
  m4/sys_wait_h.m4
  m4/tempname.m4
  m4/threadlib.m4
  m4/time_h.m4
  m4/time_r.m4
  m4/time_rz.m4
  m4/timegm.m4
  m4/tm_gmtoff.m4
  m4/tzset.m4
  m4/uname.m4
  m4/unistd_h.m4
  m4/visibility.m4
  m4/warn-on-use.m4
  m4/wchar_h.m4
  m4/wchar_t.m4
  m4/wcrtomb.m4
  m4/wctype_h.m4
  m4/wint_t.m4
  m4/wmemchr.m4
  m4/wmempcpy.m4
  m4/zzgnulib.m4
])
