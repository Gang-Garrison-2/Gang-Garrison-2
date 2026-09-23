// Minimal libprocps 3 <proc/readproc.h> for ENIGMA's xlib widget dialogs, which
// use it to list child processes. Arch ships libproc2, which dropped this API.
// Implements only what Widget_Systems/xlib/dialogs.cpp calls, on top of /proc.
#pragma once

#include <dirent.h>

#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#define PROC_FILLSTAT 0x0040

struct PROCTAB {
  DIR* dir;
};

struct proc_t {
  int tgid;
  int ppid;
};

inline PROCTAB* openproc(int, ...) { return new PROCTAB{opendir("/proc")}; }

inline proc_t* readproc(PROCTAB* table, proc_t*) {
  if (!table->dir) return nullptr;
  while (dirent* entry = readdir(table->dir)) {
    if (!isdigit(static_cast<unsigned char>(entry->d_name[0]))) continue;
    char path[64];
    snprintf(path, sizeof path, "/proc/%s/stat", entry->d_name);
    FILE* f = fopen(path, "r");
    if (!f) continue;  // process exited
    char buf[512];
    size_t n = fread(buf, 1, sizeof buf - 1, f);
    fclose(f);
    buf[n] = '\0';
    // "pid (comm) state ppid ...": comm may contain spaces and parens.
    const char* close = strrchr(buf, ')');
    char state;
    int ppid;
    if (!close || sscanf(close + 1, " %c %d", &state, &ppid) != 2) continue;
    return new proc_t{atoi(entry->d_name), ppid};
  }
  return nullptr;
}

inline void freeproc(proc_t* p) { delete p; }

inline void closeproc(PROCTAB* table) {
  if (table->dir) closedir(table->dir);
  delete table;
}
