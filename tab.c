#include <stdio.h>
#include <stdlib.h>
#include "string.h"
#include "tab.h"

#define true 1
#define false 0

void deleteScope() {
	
	struct nodo *puntero = primero;
	
	if(puntero != NULL) {
		int scopeActual = puntero->scope;
		
		while(puntero != NULL || puntero->scope >= scopeActual) {
			removeTop();
			puntero = primero;
		}
		
	}
}


int search(char* id, enum category categoria) {
	
	struct nodo *puntero = primero;
	
	while (puntero != NULL) {
		
		if(puntero->categoria == categoria && strcmp(id, puntero->id) == 0) {
			printf("Ya hay uno con mismo id y categ.\n");					// printf que habra que quitar
			return true;
		}
		
		puntero = puntero->sig;
	}
	return false;
}


int add(char* id, enum type tipo, enum category categoria, int scope) {
	
	if(search(id, categoria)) return false;
	
	struct nodo *nuevo_simbolo = malloc(sizeof(struct nodo));
	nuevo_simbolo->id = id;
	nuevo_simbolo->tipo = tipo;
	nuevo_simbolo->categoria = categoria;
	nuevo_simbolo->sig = primero;
	nuevo_simbolo->scope = scope;
	
    primero = nuevo_simbolo;
	
	
	return true;
}


void removeTop() {
	
	struct nodo *sig = primero->sig;
	
	free(primero);
	
	primero = sig;
}


void show() {
	
	printf("-- Inicio Tabla Simbolos --\n");
	
	struct nodo *puntero = primero;
	
	while (puntero != NULL) {
		printf("type = %d | categ = %d | id = %s\n", puntero->tipo, puntero->categoria, puntero->id);
		puntero = puntero->sig;
	}
	
	printf("-- Fin Tabla Simbolos --\n\n");
}

int main() {
	add("x", entero, local, 0);
	add("x", coma_flotante, funcion, 0);
	add("x", coma_flotante, global, 0);
	show();
	
	add("x", coma_flotante, global, 1);
	show();
	
	removeTop();
	show();
	
	add("x", coma_flotante, funcion);
	add("x", coma_flotante, global);
	show();
}