#include "api_robot.h"
#include <stdio.h>
#include <stdlib.h>


int main() {
    char i;

    // Testanedo funções:
    // set_torque(30,30);
    // set_engine_torque(0, 30);
    // set_engine_torque(1, 30);
    // set_head_servo(0, 100);
    // set_head_servo(1, 70);

    // set_head_servo(2, 100);

    // set_head_servo(2, 14);

    Vector3 *v;
    v->x = 0; v->y = 1; v->z = 2;
    
    get_current_GPS_position(v);

    set_torque(30, 30);

    get_current_GPS_position(v);

    unsigned short s = get_us_distance();


    while(1){}
    return 0;
}