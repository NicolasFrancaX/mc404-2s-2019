#include "api_robot.h"
#include <stdio.h>
#include <stdlib.h>
int abs(int x){
    if(x<0)
        return -x;
    return x;
}
int encontrar_amigo(Vector3 amigo){
    Vector3 uoli;
    get_current_GPS_position(&uoli);
    if(abs(uoli.x-amigo.x)<=5 && abs(uoli.z-amigo.z)<=5)
        return 1;
    return 0;
}
int quadrante(Vector3 amigo){
    Vector3 pos_uoli;
    int dif_x;
    int dif_z;
    get_current_GPS_position(&pos_uoli);
    dif_x = pos_uoli.x - amigo.x;
    dif_z = pos_uoli.z - amigo.z;
    if(dif_x >=0 && dif_z >=0)
        return 4;
    if (dif_x <0 && dif_z < 0)
        return 2;
    if(dif_x >=0 && dif_z < 0)
        return 1;
    if(dif_x < 0 && dif_z >=0)
        return 3;
    return 0;
}
void girar_direita(int valor){
    Vector3 angulo_uoli;
    int atual,final;
    get_gyro_angles(&angulo_uoli);
    atual = angulo_uoli.y;
    final = atual + valor;
    if(final>360)
        final -=360;
    while(atual<final-20 || atual> final+20){
        set_torque(10,-10);
        get_gyro_angles(&angulo_uoli);
        atual = angulo_uoli.y;
    }
    set_torque(0,0);
}
void girar_esquerda(int valor){
    Vector3 angulo_uoli;
    int atual,final;
    get_gyro_angles(&angulo_uoli);
    atual = angulo_uoli.y;
    final = atual - valor;
    if(final>360)
        final -=360;
    while(atual<final-20 || atual> final+20){
        set_torque(-10,10);
        get_gyro_angles(&angulo_uoli);
        atual = angulo_uoli.y;
    }
    set_torque(0,0);
}
void espera(int valor){
    int time,final;
    time = get_time();
    final = time + valor;
    while(time<final){
        time = get_time();
    }
}
int main() {
    int i;
    Vector3 amigo_i;
    
    espera(3000);
    for(i=0;i<5;i++){
        amigo_i = friends_locations[i];
        while(!encontrar_amigo(amigo_i)){
            if(quadrante(amigo_i)==4) girar_esquerda(45);
            else if(quadrante(amigo_i)==3) girar_direita(45);
            else if(quadrante(amigo_i)==2) girar_direita(135);
            else girar_esquerda(135);
            espera(2000);
            set_torque(10,10);
            espera(2000);
        }
    }
    while(1){}
    return 0;
}