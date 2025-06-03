#!/bin/sh
export XDG_RUNTIME_DIR=/run/user/0
sleep 1
/usr/bin/motor_control_simulator -platform linuxfb &
