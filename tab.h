
enum category {funcion, local, global};
enum type {caracter, entero, coma_flotante, String, boolean};

struct nodo {
    char *id;                               
    enum type tipo;
	enum category categoria;
	struct nodo *param;
    struct nodo *sig;
};

struct nodo *primero = NULL;

int search(char* id, enum category categoria);
int add(char* id, enum type tipo, enum category categoria);
void removeTop();
void show();