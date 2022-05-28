
enum category {funcion, local, global, param};
enum type {caracter, entero, coma_flotante, String, boolean};

struct nodo {
    char *id;   
	int scope;
    enum type tipo;
	enum category categoria;
	struct nodo *param;
    struct nodo *sig;
};

struct nodo *primero = NULL;

int search(char* id, enum category categoria);
int add(char* id, enum type tipo, enum category categoria, int scope);
void deleteScope();
void removeTop();
void show();