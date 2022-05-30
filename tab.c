#include <stdio.h>
#include <stdlib.h>
#include "string.h"
#include "tab.h"

#define true 1
#define false 0

struct nodo *primero = NULL;

void deleteScope(int sc) {
	
	struct nodo *puntero = primero;
	
	if(puntero != NULL) {
		while(puntero != NULL && sc < puntero->scope) {
			removeTop();
			puntero = primero;
		}
		
	}
}


void removeTop() {
	
	struct nodo *sig = primero->sig;
	
	free(primero);
	
	primero = sig;
}


struct nodo * search(char* id, enum category categoria) {
	
	struct nodo *puntero = primero;
	
	while (puntero != NULL) {
		
		if(puntero->categoria == categoria && strcmp(id, puntero->id) == 0) {
			return puntero;
		}
		
		puntero = puntero->sig;
	}
	return NULL;
}


int add(char* id, enum type tipo, enum category categoria, int scope, int array) {
	
	if(search(id, categoria) != NULL) return false;
	
	struct nodo *nuevo_simbolo = malloc(sizeof(struct nodo));
	nuevo_simbolo->id = id;
	nuevo_simbolo->tipo = tipo;
	nuevo_simbolo->categoria = categoria;
	nuevo_simbolo->scope = scope;
	nuevo_simbolo->array = array;
	
	if(primero != NULL && categoria == param) {
		
		nuevo_simbolo->param = primero->param;
		primero->param = nuevo_simbolo;
	} else {
		nuevo_simbolo->sig = primero;
		primero = nuevo_simbolo;
	}	
	
	return true;
}


void show() {
	
	printf("-- Inicio Tabla Simbolos --\n");
	
	struct nodo *puntero = primero;
	
	while (puntero != NULL) {
		printf("type = %d | categ = %d | scope = %d | id = %s | array = %s\n", puntero->tipo, puntero->categoria, puntero->scope, puntero->id, (puntero->array) ? "True" : "False");
		
		if(puntero->categoria == funcion) {
			struct nodo *punteroParam = puntero->param;
			printf("-- Inicio Parametros --\n");
			
			while (punteroParam != NULL) {
				printf("type = %d | categ = %d | scope = %d | id = %s | array = %s\n", punteroParam->tipo, punteroParam->categoria, punteroParam->scope, punteroParam->id, (punteroParam->array) ? "True" : "False");
				punteroParam = punteroParam->param;
			}
			printf("-- Fin Parametros --\n\n");
		}
		
		puntero = puntero->sig;
	}
	
	printf("-- Fin Tabla Simbolos --\n\n");
}
