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
		
		while(puntero != NULL && puntero->scope == scopeActual) {
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
	nuevo_simbolo->scope = scope;
	
	if(primero != NULL && categoria == param) {
		nuevo_simbolo->param = primero->param;
		primero->param = nuevo_simbolo;
	} else {
		nuevo_simbolo->sig = primero;
		primero = nuevo_simbolo;
	}	
	
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
		printf("type = %d | categ = %d | scope = %d | id = %s\n", puntero->tipo, puntero->categoria, puntero->scope, puntero->id);
		puntero = puntero->sig;
	}
	
	printf("-- Fin Tabla Simbolos --\n\n");
}

int main() {
	add("sdx", entero, local, 0);
	add("xf", coma_flotante, funcion, 0);
	add("sx", coma_flotante, global, 0);
	add("xd", coma_flotante, global, 1);
	add("xe", coma_flotante, funcion, 1);
	add("xq", coma_flotante, global, 2);
	show();
	deleteScope();
	show();
	
		deleteScope();
	show();
		deleteScope();
	show();
		deleteScope();
	show();
		deleteScope();
	show();
}