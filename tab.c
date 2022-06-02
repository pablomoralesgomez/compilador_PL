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
	
	if(primero->categoria == funcion) {
		
		while (primero->param != NULL) {
			struct nodo *aux = primero->param->param;
			
			free(primero->param);
			primero->param = aux;
		}
	}
	
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

int countFunctionParameters(char* id) {
	
	struct nodo *puntero = search(id, funcion);
	if(puntero == NULL) return -1;
	
	int count = 0;
	while(puntero->param != NULL) {
		count++;
		
		puntero = puntero->param;
	}
	
	return count;
}


struct nodo * getParameterByNumber(char *id, int n) {
	
	struct nodo *puntero = search(id, funcion);
	if(puntero == NULL) return NULL;
	
	int count = 0;
	
	while(puntero != NULL && count < n) {
		count++;
		puntero = puntero->param;
		
	}
	
	return puntero;
}


int add(char* id, enum type tipo, enum category categoria, int scope, int address, struct array *array) {
	
	if(search(id, categoria) != NULL) return false;
	
	struct nodo *nuevo_simbolo = malloc(sizeof(struct nodo));
	nuevo_simbolo->id = id;
	nuevo_simbolo->tipo = tipo;
	nuevo_simbolo->categoria = categoria;
	nuevo_simbolo->scope = scope;
	nuevo_simbolo->address = 0;
	nuevo_simbolo->array = array;

	
	if(primero != NULL && categoria == param) {
		struct nodo *puntero = primero;
		while(puntero->param != NULL) puntero = puntero->param;		

		puntero->param = nuevo_simbolo;
		
	} else {
		nuevo_simbolo->sig = primero;
		primero = nuevo_simbolo;
	}	
	
	return true;
}

int getAddress(enum type tipo, int length){
	return -2;
}

void show() {
	
	printf("-- Inicio Tabla Simbolos --\n");
	
	struct nodo *puntero = primero;
	
	while (puntero != NULL) {
		printf("type = %d | categ = %d | scope = %d | id = %s | address = %d\n", puntero->tipo, puntero->categoria, puntero->scope, puntero->id, puntero->address);
		
		if(puntero->categoria == funcion) {
			struct nodo *punteroParam = puntero->param;
			printf("-- Inicio Parametros --\n");
			
			while (punteroParam != NULL) {
				printf("type = %d | categ = %d | scope = %d | id = %s | address = %d\n", punteroParam->tipo, punteroParam->categoria, punteroParam->scope, punteroParam->id, puntero->address);
				punteroParam = punteroParam->param;
			}
			printf("-- Fin Parametros --\n\n");
		}
		
		puntero = puntero->sig;
	}
	
	printf("-- Fin Tabla Simbolos --\n\n");
}