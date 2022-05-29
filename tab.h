
enum category {funcion, local, global, param};
enum type {caracter, entero, comaFlotante, ristra, boolean, vacio};

struct nodo {
    char *id;   
	int scope;
    enum type tipo;
	enum category categoria;
	struct nodo *param;
    struct nodo *sig;
};

struct nodo * search(char* id, enum category categoria);
int add(char* id, enum type tipo, enum category categoria, int scope);
void deleteScope(int sc);
void removeTop();
void show();