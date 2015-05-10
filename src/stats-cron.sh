#!/bin/bash

TIMESTAMP=`/bin/date +%s`;

TOP_RESULT=`/usr/bin/top -l 1`;

TOP_CPU_USAGE=`/bin/echo "$TOP_RESULT" | /usr/bin/grep "CPU usage"`;
CPU_USAGE_USER=`/bin/echo $TOP_CPU_USAGE | /usr/bin/perl -WnE'say /CPU usage: (\d*\.\d*)% user, \d*\.\d*% sys, \d*\.\d*% idle/g'`;
CPU_USAGE_SYS=`/bin/echo $TOP_CPU_USAGE | /usr/bin/perl -WnE'say /CPU usage: \d*\.\d*% user, (\d*\.\d*)% sys, \d*\.\d*% idle/g'`;
CPU_USAGE_IDLE=`/bin/echo $TOP_CPU_USAGE | /usr/bin/perl -WnE'say /CPU usage: \d*\.\d*% user, \d*\.\d*% sys, (\d*\.\d*)% idle/g'`;

TOP_MEM_USAGE=`/usr/bin/top -l 1 | /usr/bin/grep "PhysMem"`
MEM_USAGE_WIRED=`/bin/echo $TOP_MEM_USAGE | /usr/bin/perl -WnE'say /PhysMem: (\d*)M wired, \d*M active, \d*M inactive, \d*M used, \d*M free./g'`;
MEM_USAGE_ACTIVE=`/bin/echo $TOP_MEM_USAGE | /usr/bin/perl -WnE'say /PhysMem: \d*M wired, (\d*)M active, \d*M inactive, \d*M used, \d*M free./g'`;
MEM_USAGE_INACTIVE=`/bin/echo $TOP_MEM_USAGE | /usr/bin/perl -WnE'say /PhysMem: \d*M wired, \d*M active, (\d*)M inactive, \d*M used, \d*M free./g'`;
MEM_USAGE_USED=`/bin/echo $TOP_MEM_USAGE | /usr/bin/perl -WnE'say /PhysMem: \d*M wired, \d*M active, \d*M inactive, (\d*)M used, \d*M free./g'`;
MEM_USAGE_FREE=`/bin/echo $TOP_MEM_USAGE | /usr/bin/perl -WnE'say /PhysMem: \d*M wired, \d*M active, \d*M inactive, \d*M used, (\d*)M free./g'`;

CPU_TEMP=`~/.rvm/wrappers/my_app/ruby ~/.rvm/gems/ruby-2.1.3/bin/istats cpu temp | /usr/bin/perl -WnE'say /\d*\.\d*/g'`;
CPU_FAN_SPEED=`~/.rvm/wrappers/my_app/ruby ~/.rvm/gems/ruby-2.1.3/bin/istats fan speed | /usr/bin/perl -WnE'say /\d*\.\d*/g'`;

/usr/bin/sqlite3 stats.sqlite "insert into stats (cpu_temp, cpu_fan_speed, cpu_usage_user, cpu_usage_sys, cpu_usage_idle, mem_usage_wired, mem_usage_active, mem_usage_inactive, mem_usage_used, mem_usage_free, timestamp) values ($CPU_TEMP, $CPU_FAN_SPEED, $CPU_USAGE_USER, $CPU_USAGE_SYS, $CPU_USAGE_IDLE, $MEM_USAGE_WIRED, $MEM_USAGE_ACTIVE, $MEM_USAGE_INACTIVE, $MEM_USAGE_USED, $MEM_USAGE_FREE, $TIMESTAMP)"
