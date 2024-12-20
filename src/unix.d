/*
 * The include file for the UNIX version of CLISP
 * Bruno Haible 1990-2008, 2016-2024
 * Sam Steingold 1998-2009, 2011, 2017
 */

/* control character constants: */
#define BEL  7              /* ring the bell */
/* #define NL  10              new line, see <lispbibl.d> */
#define RUBOUT 127          /* Rubout = Delete */
#define CRLFstring  "\n"    /* C string containing Newline */

#define stdin_handle   0  /* the file handle for the standard input */
#define stdout_handle  1  /* the file handle for the standard output */
#define stderr_handle  2  /* the file handle for the standard error */

/* Declaration of types of I/O parameters of operating system functions */
#include <sys/time.h>
#include <time.h>
#if defined(HAVE_SYS_RESOURCE_H)
 #include <sys/resource.h>
#endif

/* NB: errno may be a macro which expands to a function call.
   Therefore access and assignment to errno must be wrapped in
   begin_system_call()/end_system_call() */
#define OS_errno errno
#define OS_set_errno(e) (errno=(e))
/* perror(3)
   On UnixWare 7.0.1 some errno value is defined to an invalid negative value,
   causing an out-of-bounds array access in errunix.d. */
#if (EDQUOT < 0)
  #undef EDQUOT
#endif
/* used by ERROR, SPVW, STREAM, PATHNAME */

#if defined(HAVE_MMAP) || defined(HAVE_MMAP_ANON)
  #include <sys/mman.h>
  #ifdef UNIX_SUNOS5
   /* NB: Under UNIX_SUNOS5, there is a limit of 25 MB mmap() memory.
      Since the shared memory facility of UNIX_SUNOS5 denies
      memory at addresses >= 0x06000000 or more than 6 times to attach,
      we must use SINGLEMAP_MEMORY */
  #endif
#endif
#ifdef HAVE_MMAP
  /* extern_C void* mmap (void* addr, size_t len, int prot, int flags, int fd, off_t off); */ /* MMAP(2) */
#endif
#ifdef HAVE_MUNMAP
  /* extern_C int munmap (void* addr, size_t len); */ /* MUNMAP(2) */
#endif
#ifdef HAVE_WORKING_MPROTECT
  /* extern_C int mprotect (void* addr, size_t len, int prot); */ /* MPROTECT(2) */
#endif
/* Possible values of prot: PROT_NONE, PROT_READ, PROT_READ_WRITE. */
#ifndef PROT_NONE
  #define PROT_NONE  0
#endif
#define PROT_READ_WRITE  (PROT_READ | PROT_WRITE)
/* used by SPVW, STREAM */

/* paging control */
#ifdef HAVE_VADVISE
  #include <sys/vadvise.h> /* control codes */
  /* {void|int} vadvise (int param); */ /* paging system control, see VADVISE(2) */
#endif
/* use madvise() ?? */
/* used by SPVW */

/* normal program end */
extern_C _Noreturn void _exit (int status); /* EXIT(2V) */
extern_C _Noreturn void exit (int status); /* EXIT(2V) */
/* used by SPVW, PATHNAME, STREAM */

/* Immediate abnormal termination, jump into the debugger */
/* #include <stdlib.h> - see above */
/* extern_C [volatile] void abort (void); */ /* ABORT(3) */
/* used by SPVW, DEBUG, EVAL, IO */

/* signal handling */
#include <signal.h>
/* a signal handler is a non-returning function. */
typedef void (*signal_handler_t) (int);
/* install a signal cleanly: */
extern_C signal_handler_t signal (int sig, signal_handler_t handler); /* SIGNAL(3V) */
#if defined(SIGNAL_NEED_UNBLOCK_OTHERS) && defined(HAVE_SIGACTION)
/* On some BSD systems, the call of a signal handler
   is different when the current signal is blocked.
   We therefore use sigaction() instead of signal(). */
  #define USE_SIGACTION
#endif
extern signal_handler_t install_signal_handler (int sig, signal_handler_t handler);
#define SIGNAL(sig,handler)  install_signal_handler(sig,handler)
/* Block and unblock (= delay and reenable) a signal: */
#define SIGNALBLOCK_POSIX /* all Unix systems support the POSIX API for signal blocking */
/* extern_C int sigprocmask (int how, const sigset_t* set, sigset_t* oset); */ /* SIGPROCMASK(2V) */
/* extern_C int sigemptyset (sigset_t* set); */ /* SIGSETOPS(3V) */
/* extern_C int sigaddset (sigset_t* set, int signo); */ /* SIGSETOPS(3V) */
#define signalblock_on(sig)  \
  { var sigset_t sigblock_mask;                                 \
    sigemptyset(&sigblock_mask); sigaddset(&sigblock_mask,sig); \
    sigprocmask(SIG_BLOCK,&sigblock_mask,NULL);
#define signalblock_off(sig)  \
    sigprocmask(SIG_UNBLOCK,&sigblock_mask,NULL); \
  }
/* deliver a signal some time later: */
/* extern_C {unsigned|} int alarm ({unsigned|} int seconds); / * ALARM(3V) */
#if !defined(HAVE_UALARM) && defined(HAVE_SETITIMER)
  #define NEED_OWN_UALARM /* ualarm() can be implemented with setitimer() */
  /* declares setitimer() */
  #define HAVE_UALARM
#endif
#ifdef HAVE_UALARM
  #if defined(UNIX_CYGWIN) || defined(UNIX_HAIKU)
    /* <sys/types.h>: typedef long useconds_t; */
    extern_C useconds_t ualarm (useconds_t value, useconds_t interval);
  #else
    extern_C unsigned int ualarm (unsigned int value, unsigned int interval);
  #endif
#endif
/* acknowledge the arrival of a signal (from the signal handler): */
#ifdef USE_SIGACTION
  #ifdef SIGACTION_NEED_REINSTALL
    /* restore the handler */
    #define signal_acknowledge(sig,handler) install_signal_handler(sig,handler)
  #else /* BSD-stype signals do not need this */
    #define signal_acknowledge(sig,handler)
  #endif
#else
  #ifdef SIGNAL_NEED_REINSTALL /* UNIX_SYSV || UNIX_LINUX || ... */
    /* restore the handler */
    #define signal_acknowledge(sig,handler) install_signal_handler(sig,handler)
  #else  /* BSD-stype signals do not need this */
    #define signal_acknowledge(sig,handler)
  #endif
#endif
/* the signal one gets on termination of the child process: SIGCLD */
#if defined(SIGCHLD) && !defined(SIGCLD)
  #define SIGCLD  SIGCHLD
#endif
/* the behavior of the signals the affect system calls:
   flag=0: after the signal SIG the system call keep running.
   flag=1: after the signal SIG the system call is aborted, errno=EINTR. */
#ifdef EINTR
  extern_C int siginterrupt (int sig, int flag); /* SIGINTERRUPT(3V) */
  #ifndef HAVE_SIGINTERRUPT
    /* siginterrupt() can be implemented with sigaction() */
    #define NEED_OWN_SIGINTERRUPT
  #endif
#else
  #define siginterrupt(sig,flag)
#endif
/* For recovery from the SIGSEGV signal (write attempts to write
   protected ranges). See libsigsegv.
   Watch out: Hans-J. Boehm <boehm@parc.xerox.com> says that write accesses
   originating from OS calls (e.g. read()) do not trigger a signal on many
   systems, unexpectedly. (It works on Linux, though) */
#ifndef SPVW_MIXED_BLOCKS
/* We are lucky to write with read() only into the C-stack and into strings
   and not into possibly mprotect-protected ranges. */
#endif
/* raise a signal. */
extern_C int raise (int sig);
/* used by SPVW */

/* get user home directory: */
#include <pwd.h>
/* declares getpwnam(), getpwuid(), getuid(), getlogin() */
/* used by PATHNAME, SPVW */

/* set working directory: */
/* chdir() - declared in <unistd.h> */
/* used by PATHNAME */

/* get working directory: */
#include <sys/param.h>
/* maximum path length (incl. terminating NULL), returned by getwd(): */
#ifndef MAXPATHLEN
  #ifdef PATH_MAX
    #define MAXPATHLEN  PATH_MAX  /* <sys/param.h> */
  #else
    #define MAXPATHLEN  4096
  #endif
#endif
#ifdef HAVE_GETCWD
/* getcwd(3) - declared in <unistd.h> */
#define getwd(buf)  getcwd(buf,MAXPATHLEN)
#else
/* getwd(3) - declared in <unistd.h> */
#endif
/* used by PATHNAME */

/* maximum number of symbolic links which are successively resolved: */
#ifndef MAXSYMLINKS
  #define MAXSYMLINKS  8  /* <sys/param.h> */
#endif
/* used by PATHNAME */

/* get information about a file: */
#include <sys/stat.h>
/* used by PATHNAME, STREAM, SPVW */
struct file_id {              /* Unique ID for a file on this machine */
#if defined(SIZEOF_DEV_T)
  dev_t device;
#else
  uintL device;
#endif
#if defined(SIZEOF_INO_T)
  ino_t inode;
#else
  uintL inode;
#endif
};
typedef int os_error_code_t;
/* fill FI for an exiting namestring */
extern os_error_code_t namestring_file_id(char *namestring,struct file_id *fi);
/* fill FI for an existing file handle */
extern os_error_code_t handle_file_id (int fd, struct file_id *fi);
/* if the file IDs are identical, return 1, otherwise return 0 */
extern int file_id_eq (struct file_id *fi1, struct file_id *fi2);

/* unlink() - declared in <unistd.h>; used by PATHNAME, UNIXAUX */
/* rename() - declared in <stdio.h>; used by PATHNAME, UNIXAUX */

/* directory search: */
#include <dirent.h>
/* declared in <dirent.h>: opendir(), readdir(), closedir() */
/* used by PATHNAME */

/* create directory: */
/* mkdir() - declared in <sys/stat.h> or <unistd.h> */
/* used by PATHNAME */

/* remove directory: */
/* rmdir() - declared in <unistd.h> */
/* used by PATHNAME */

/* work with open files: */
#include <fcntl.h> /* declares open(), O_RDWR etc. */
/* Only a few Unices (like UNIX_CYGWIN) have O_TEXT and O_BINARY.
   BeOS 5 has them, but they have no effect. */
#ifdef UNIX_BEOS
  #undef O_BINARY
#endif
#ifndef O_BINARY
  #define O_BINARY  0
#endif
#define my_open_mask  0644
#define Handle  int  /* the type of a file descriptor */
#define INVALID_HANDLE  -1
extern_C off_t lseek (int fd, off_t offset, int whence); /* LSEEK(2V) */
#ifndef SEEK_SET /* old platforms */
  /* position modes, see <unistd.h> : */
  #define SEEK_SET  0
  #define SEEK_CUR  1
  #define SEEK_END  2
#endif
/* extern_C ssize_t read (int fd, void* buf, size_t nbyte); */ /* READ(2V) */
/* extern_C ssize_t write (int fd, const void* buf, size_t nbyte); */ /* WRITE(2V) */
extern_C int close (int fd); /* CLOSE(2V) */
#ifdef HAVE_FSYNC
extern_C int fsync (int fd); /* FSYNC(2) */
#endif
#if defined(HAVE_POLL)
  #include <poll.h>
  /* extern_C int poll (struct pollfd * fds, unsigned {int|long} nfds, int timeout); */
#endif
#if !defined(HAVE_SELECT) && defined(HAVE_POLL)
  #define NEED_OWN_SELECT /* select() can be implemented with poll()  */
  #ifndef _EMUL_SYS_TIME_H
    #define _EMUL_SYS_TIME_H
    struct timeval { long tv_sec; long tv_usec; };
    struct timezone { int tz_minuteswest; int tz_dsttime; };
  #endif
  #define SELECT_WIDTH_T int
  #define SELECT_SET_T fd_set
  #define SELECT_CONST
  #define HAVE_SELECT /* see unixaux.d */
#endif
#ifdef HAVE_SELECT
  #ifdef HAVE_SYS_SELECT_H
    #include <sys/select.h>
  #endif
  #ifndef FD_SETSIZE
    /* definition of types fd_set, err <sys/types.h> : */
    #define FD_SETSIZE 256 /* maximum number of file descriptors */
    typedef int fd_mask; /* a bit group */
    #define NFDBITS (sizeof(fd_mask) * 8) /* number of bits in a bit group */
    typedef struct fd_set { fd_mask fds_bits[ceiling(FD_SETSIZE,NFDBITS)]; }
            fd_set;
    #define FD_SET(n,p)  ((p)->fds_bits[(n)/NFDBITS] |= bit((n)%NFDBITS))
    #define FD_CLR(n,p)  ((p)->fds_bits[(n)/NFDBITS] &= ~bit((n)%NFDBITS))
    #define FD_ISSET(n,p)  ((p)->fds_bits[(n)/NFDBITS] & bit((n)%NFDBITS))
    #define FD_ZERO(p)  bzero((char*)(p),sizeof(*(p)))
    #define bzero(ptr,len)  memset(ptr,0,len)
  #endif
  extern_C int select (SELECT_WIDTH_T width, SELECT_SET_T* readfds,
                       SELECT_SET_T* writefds, SELECT_SET_T* exceptfds,
                       SELECT_CONST struct timeval * timeout); /* SELECT(2) */
#endif
#ifdef EINTR
/* wrapper around the system call, which intercepts and handles EINTR: */
extern int nonintr_open (const char* path, int flags, mode_t mode);
extern int nonintr_close (int fd);
#define OPEN nonintr_open
#define CLOSE nonintr_close
#else
#define OPEN open
#define CLOSE close
#endif
/* wrapper around the system call, get partial results and handle EINTR: */
extern ssize_t fd_read (int fd, void* buf, size_t nbyte, perseverance_t persev);
extern ssize_t fd_write (int fd, const void* buf, size_t nbyte, perseverance_t persev);
#define safe_read(fd,buf,nbyte)  fd_read(fd,buf,nbyte,persev_partial)
#define full_read(fd,buf,nbyte)  fd_read(fd,buf,nbyte,persev_full)
#define safe_write(fd,buf,nbyte)  fd_write(fd,buf,nbyte,persev_partial)
#define full_write(fd,buf,nbyte)  fd_write(fd,buf,nbyte,persev_full)
/* used by STREAM, PATHNAME, SPVW, MISC, UNIXAUX */

/* inquire the terminal, window size: */
#include <sys/ioctl.h> /* declares ioctl() */
extern_C int isatty (int fd); /* TTYNAME(3V) */
#if defined(HAVE_TERMIOS_H)
  #define UNIX_TERM_TERMIOS
  #include <termios.h> /* TERMIOS(3V) */
  /* extern_C int tcgetattr (int fd, struct termios * tp); */
  /* extern_C int tcsetattr (int fd, int optional_actions, const struct termios * tp); */
  /* extern_C int tcdrain (int fd); */ /* TERMIOS(3V) */
  /* extern_C int tcflush (int fd, int flag); */ /* TERMIOS(3V) */
  #define TCSETATTR tcsetattr
  #define TCDRAIN tcdrain
  #define TCFLUSH tcflush
  #ifndef NCCS
    #define NCCS  sizeof(((struct termios *)0)->c_cc)
  #endif
  #if defined(WINSIZE_NEED_SYS_IOCTL_H) /* glibc2 needs this for "struct winsize" */
    /* #include <sys/ioctl.h> - already included above */
  #endif
#endif
#if defined(NEED_SYS_FILIO_H)
  #include <sys/filio.h>
#elif defined(NEED_SYS_IOCTL_H)
  /* #include <sys/ioctl.h> - already included above */
#endif
/* START_NO_BLOCK() & END_NO_BLOCK() should appear in pairs
   inside { NO_BLOCK_DECL(); ... };
 NO_BLOCK_DECL() should be before the first statement. */
#if defined(F_GETFL) && defined(O_NONBLOCK)
  /* non-blocking I/O a la SYSV */
  #define NO_BLOCK_DECL()                                         \
    int fcntl_flags
  #define START_NO_BLOCK(handle, on_fail)               do {            \
      if ((fcntl_flags = fcntl(handle,F_GETFL,0))<0) { on_fail; }       \
      if (fcntl(handle,F_SETFL,fcntl_flags|O_NONBLOCK)<0) { on_fail; }  \
    } while (0)
  #define END_NO_BLOCK(handle, on_fail)                 do {     \
      if (fcntl(handle,F_SETFL,fcntl_flags)<0) { on_fail; }      \
    } while(0)
#elif defined(F_GETFL) && defined(O_NDELAY)
  /* non-blocking I/O a la SYSV, older Unices called it O_NDELAY */
  #define NO_BLOCK_DECL()                                         \
    int fcntl_flags
  #define START_NO_BLOCK(handle, on_fail)              do {          \
      if ((fcntl_flags = fcntl(handle,F_GETFL,0))<0) { on_fail; }    \
      if (fcntl(handle,F_SETFL,fcntl_flags|O_NDELAY)<0) { on_fail; } \
    } while (0)
  #define END_NO_BLOCK(handle, on_fail)                do { \
      if (fcntl(handle,F_SETFL,fcntl_flags)<0) { on_fail; } \
    } while(0)
#elif defined(FIONBIO)
  /* non-blocking I/O a la BSD 4.2 */
  #define NO_BLOCK_DECL()  \
    int non_blocking_io = 1
  #define START_NO_BLOCK(handle, on_fail)                  \
    if (ioctl(handle,FIONBIO,&non_blocking_io)) { on_fail; }
  #define END_NO_BLOCK(handle, on_fail)             do {          \
      non_blocking_io = 0;                                        \
      if (ioctl(handle,FIONBIO,&non_blocking_io)) { on_fail; }    \
    } while (0)
#endif

#if defined(UNIX_TERM_TERMIOS) && !(defined(TCIFLUSH) && defined(TCOFLUSH))
  #define TCIFLUSH 0
  #define TCOFLUSH 1
#endif
extern_C int tgetent (const char* bp, const char* name); /* TERMCAP(3X) */
extern_C int tgetnum (const char* id); /* TERMCAP(3X) */
extern_C int tgetflag (const char* id); /* TERMCAP(3X) */
extern_C const char* tgetstr (const char* id, char** area); /* TERMCAP(3X) */
#ifdef EINTR
  /* wrapper around the system call, which intercepts and handles EINTR: */
  extern int nonintr_ioctl (int fd, int request, void *arg);
  #undef ioctl
  #define ioctl  nonintr_ioctl
  #ifdef UNIX_TERM_TERMIOS
    extern int nonintr_tcsetattr (int fd, int optional_actions, struct termios * tp);
    extern int nonintr_tcdrain (int fd); /* TERMIOS(3V) */
    extern int nonintr_tcflush (int fd, int flag); /* TERMIOS(3V) */
    #undef TCSETATTR
    #define TCSETATTR nonintr_tcsetattr
    #undef TCDRAIN
    #define TCDRAIN nonintr_tcdrain
    #undef TCFLUSH
    #define TCFLUSH nonintr_tcflush
  #endif
#endif
/* used by SPVW, STREAM */

/* process date/time of day:
 get gettimeofday() from gnulib */

/* inquire used time of the process: */
#if defined(HAVE_GETRUSAGE)
  /* <sys/resource.h> declares: int getrusage (int who, struct rusage * rusage); */ /* GETRUSAGE(2) */
#elif defined(HAVE_SYS_TIMES_H)
  #include <sys/times.h>
  extern_C clock_t times (struct tms * buffer); /* TIMES(3V) */
#endif
/* used by SPVW */

/* take a break for some time: */
extern_C unsigned int sleep (unsigned int seconds); /* SLEEP(3V) */
/* used by MISC */

/* program call: */
#define SHELL "/bin/sh"  /* the name of the shell command interpreter */
extern_C int pipe (int fd[2]); /* PIPE(2V) */
#ifdef HAVE_VFORK_H
  #include <vfork.h>
#endif
/* vfork() declared in <vfork.h> or <unistd.h> */
extern_C int dup2 (int oldfd, int newfd); /* DUP(2V) */
#if defined(HAVE_SETSID)
  extern_C pid_t setsid (void); /* SETSID(2V), TERMIO(4) */
  #define SETSID()  setsid()
#elif defined(HAVE_SETPGID)
  extern_C pid_t getpid (void); /* GETPID(2V) */
  extern_C int setpgid (pid_t pid, pid_t pgid); /* SETPGID(2V), SETSID(2V), TERMIO(4) */
  #define SETSID()  { register pid_t pid = getpid(); setpgid(pid,pid); }
#else
  #define SETSID()
#endif

/* exec*() functions are declared in <unistd.h> */

/* NB: In the period between vfork() and execv()/execl()/execlp() the child
   process may access only the data in the stack and constant data,
   because the parent process keeps running in this time already
   and can modify data in STACK, malloc() range, Lisp data range etc. */
#include <sys/wait.h>
#if !defined(UNIX_CYGWIN) /* Cygwin has a particular declaration of waitpid(). */
extern_C pid_t waitpid (pid_t pid, int* statusp, int options); /* WAIT(2V) */
#endif
extern int wait2 (pid_t pid); /* see unixaux.d */
/* used by STREAM, PATHNAME, SPVW, UNIXAUX */

/* get random numbers: */
#ifndef rand /* some define rand() as macro... */
  extern_C int rand (void); /* RAND(3V) */
#endif
#if !defined(HAVE_SETPGID) /* in this case, already declared above */
  extern_C pid_t getpid (void); /* GETPID(2V) */
#endif
/* used by LISPARIT */

/* determine MACHINE-TYPE and MACHINE-VERSION and MACHINE-INSTANCE: */
  #include <sys/utsname.h>
/* used by MISC */

/* determine MACHINE-INSTANCE: */
#ifdef HAVE_GETHOSTBYNAME
  #include <netdb.h>
/* gethostbyname() is declared in the above files */
#endif
#ifndef MAXHOSTNAMELEN
  #define MAXHOSTNAMELEN 256    /* see <sys/param.h> */
#endif
/* used by MISC */

/* work with sockets: */
#ifdef HAVE_GETHOSTBYNAME
  /* Type of a socket */
  #define SOCKET  int
  /* Error value for functions returning a socket */
  #define INVALID_SOCKET  (SOCKET)(-1)
  /* Error value for functions returning an `int' status */
  #define SOCKET_ERROR  (-1)
  /* Signalling a socket-related error */
  #ifdef UNIX_BEOS
    /* BeOS 5 sockets cannot be used like file descriptors.
       Reading and writing from a socket */
    extern ssize_t sock_read (int socket, void* buf, size_t size, perseverance_t persev);
    extern ssize_t sock_write (int socket, const void* buf, size_t size, perseverance_t persev);
  #else
    /* Reading and writing from a socket */
    #define sock_read(socket,buf,nbyte,persev)   fd_read(socket,buf,nbyte,persev)
    #define sock_write(socket,buf,nbyte,persev)  fd_write(socket,buf,nbyte,persev)
  #endif
  /* Wrapping and unwrapping of a socket in a Lisp object */
  #define allocate_socket(fd)  allocate_handle(fd)
  #define TheSocket(obj)  TheHandle(obj)
#endif
/* used by SOCKET, STREAM */

/* Dynamic module loading: */
#ifdef HAVE_DLOPEN
  #include <dlfcn.h>            /* declares dlopen,dlsym,dlclose,dlerror */
  #define HAVE_DYNLOAD
#endif

/* Character set conversion: */
#ifdef HAVE_ICONV
  #include <iconv.h>
  extern_C iconv_t iconv_open (const char * to_code, const char * from_code);
  extern_C size_t iconv (iconv_t cd, ICONV_CONST char * *inbuf, size_t *inbytesleft, char * *outbuf, size_t* outbytesleft);
  extern_C int iconv_close (iconv_t cd);
#endif

/* Interpretation of FILETIME structure: */
#ifdef UNIX_CYGWIN
  #define WIN32_LEAN_AND_MEAN
  #pragma push_macro ("Handle")
  #undef Handle
  #pragma push_macro ("CR")
  #undef CR
  #include <windows.h>
  #pragma pop_macro ("CR")
  #pragma pop_macro ("Handle")
  #undef WIN32
  extern long time_t_from_filetime (const FILETIME * ptr);
  extern void time_t_to_filetime (time_t time_in, FILETIME * out);
#endif

/* close all file descriptors before exec() */
global void close_all_fd (void);

/* remove the effects of the setuid bit on the executable */
global void drop_privileges (void);
