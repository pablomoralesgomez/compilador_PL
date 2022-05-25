#include <stdio.h>
#include <stdlib.h>
#include "string.h"
#include "tab.h"

#define true 1
#define false 0

int search(char* id) {
	
	struct nodo *puntero = primero;
	
	while (puntero != NULL) {
		
		if(strcmp(id, puntero->id) == 0) {
			printf("Ya hay uno que se llama asi.\n");					// printf que habra que quitar
			return true;
		}
		
		puntero = primero->sig;
	}
	return false;
}


int add(char* id) {
	
	if(search(id)) return false;
	
	struct nodo *nuevo_simbolo = malloc(sizeof(struct nodo));
	nuevo_simbolo->id = id;
	nuevo_simbolo->sig = primero;
	
    primero = nuevo_simbolo;
	
	
	return true;
}


void removeTop() {
	
	if(primero != NULL) {
		struct nodo *sig = primero->sig;
		
		free(primero);
		
		primero = sig;
	}
}


void show() {
	
	printf("-- Inicio Tabla Simbolos --\n");
	
	struct nodo *puntero = primero;
	
	while (puntero != NULL) {
		printf("id = %s\n", puntero->id);
		puntero = puntero->sig;
	}
	
	printf("-- Fin Tabla Simbolos --\n\n");
}

int main() {

}