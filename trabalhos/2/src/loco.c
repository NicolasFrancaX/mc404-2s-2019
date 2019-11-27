#include "api_robot.h"
#include <stdlib.h>

int abs(int x) {
    if (x < 0) return -x;
    return x;
}

double sqrt(int x) {
    double temp, saida;

    saida = x/2;
    temp = 0;

    while (saida != temp) {
        temp = saida;
        saida = (x/temp + temp)/2;
    }

    return saida;
}

int pow(int num, int p) {
    int i;
    int saida = 1;

    for (i = 0; i < p; i++) {
        saida = saida * num;
    }

    return saida;
}

double cos(int x1, int y1, int x2, int y2) {
    double saida;
    saida = ((x1*x2)+(y1*y2))/(sqrt(pow(x1,2)+pow(y1,2))*sqrt(pow(x2,2)+pow(y2,2)));
    return saida;
}

int encontrar_amigo(Vector3 amigo) {
    Vector3 uoli;
    get_current_GPS_position(&uoli);

    if (abs(uoli.x-amigo.x) <= 5 && abs(uoli.z-amigo.z) <= 5) return 1;
    return 0;
}

int quadrante(Vector3 amigo) {
    Vector3 pos_uoli;
    int dif_x;
    int dif_z;

    get_current_GPS_position(&pos_uoli);

    dif_x = pos_uoli.x - amigo.x;
    dif_z = pos_uoli.z - amigo.z;

    if (dif_x >= 0 && dif_z >= 0) return 4;
    if (dif_x < 0 && dif_z < 0) return 2;
    if (dif_x >= 0 && dif_z < 0) return 1;
    if (dif_x < 0 && dif_z >= 0) return 3;

    return 0;
}

void girar_direita(int valor) {
    Vector3 angulo_uoli;
    int atual, final;

    get_gyro_angles(&angulo_uoli);

    atual = angulo_uoli.y;
    final = atual + valor;

    if (final > 360) final -= 360;

    while (atual < final || atual > final) {
        set_torque(10, -10);
        get_gyro_angles(&angulo_uoli);
        atual = angulo_uoli.y;
    }

    set_torque(0,0);
}

void girar_esquerda(int valor) {
    Vector3 angulo_uoli;
    int atual,final;

    get_gyro_angles(&angulo_uoli);

    atual = angulo_uoli.y;
    final = atual - valor;

    if (final > 360) final -= 360;

    while (atual < final || atual > final) {
        set_torque(-10,10);
        get_gyro_angles(&angulo_uoli);
        atual = angulo_uoli.y;
    }

    set_torque(0,0);
}

void espera(int valor){
    int time, final;

    time = get_time();
    final = time + valor;

    while (time < final) {
        time = get_time();
    }
}

void rotaciona(int angulo){
    Vector3 uoli;

    get_gyro_angles(&uoli);

    if (angulo > 350 || angulo < 10) return;

    if (uoli.y > 180) {
        while (uoli.y < angulo-10 || uoli.y > angulo+10) {
            girar_esquerda(5);
            espera(300);
            get_gyro_angles(&uoli);
        }
    } else {
        while (uoli.y < angulo-10 || uoli.y > angulo+10) {
            girar_direita(5);
            espera(300);
            get_gyro_angles(&uoli);
        }
    }
}

int main() {
    int i;
    char c;
    int quadrante_anterior = 0;
    //char c;
    Vector3 amigo_i, uoli;

    for(i = 0; i < 5; i++){
        amigo_i = friends_locations[i];

        puts("Teste\n");

        while (!encontrar_amigo(amigo_i)) {
            //c = (char)quadrante_anterior;
            //puts(&c);
            c = (char)(48 + quadrante(amigo_i));
            puts(&c); 
            puts("\nproximo\n");    
            //aqui da erro //      
            if (quadrante(amigo_i) == quadrante_anterior) {
                // miss...
            } else if (quadrante(amigo_i) == 4) {
                rotaciona(225);
            } else if (quadrante(amigo_i) == 3) {
                rotaciona(135);
            } else if (quadrante(amigo_i) == 2) {
                rotaciona(45);
            } else {
                rotaciona(315);
            }

            set_torque(20,20);
            espera(2000);
            set_torque(0,0);
            espera(2000);
        }
    }

    while (1) {}

    return 0;
}