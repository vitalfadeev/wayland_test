import core.sys.posix.stdc.time : tm;
import core.stdc.time           : time;

struct
Time {
    timespec _super;
    alias _super this;

    time_t  current_time ()              { return time (null); }
    time_t  current_time (time_t* _time) { return time (_time); }
    tm*     localtime    (time_t* _time) { return localtime (_time); }
}

// #include <time.h>
//import core.sys.posix.signal    : timespec;
//import core.sys.posix.sys.types : time_t;
//import core.sys.posix.stdc.time : tm;
//import core.stdc.time : time;

struct 
timespec {
    time_t tv_sec;    // секунды
    long   tv_nsec;   // наносекунды
}

alias time_t = long;

// struct 
// timespec {
//     time_t tv_sec;    // секунды  // D long
//     long   tv_nsec;   // наносекунды
// }
//
// timespec_get (&time, TIME_UTC);
// 1: time_t current_time = time (null);
// 2: time_t current_time; time (&current_time);
// tm* time_info = localtime (&current_time);
//
// start = time (null);
// ...
// end = time (null);
// double diff = difftime (end,start);
