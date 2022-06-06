
enum category {funcion, local, global, param};
enum type {caracter, entero, comaFlotante, ristra, boolean, vacio};

unsigned long long z;

struct nodo {
    char *id;   
	int scope;
    enum type tipo;
	enum category categoria;
	struct nodo *param;
    struct nodo *sig;
    int address;
    struct array *array;
};

struct array {
    int length;
    int address;
};

struct nodo * search(char* id, enum category categoria);
int add(char* id, enum type tipo, enum category categoria, int scope, int address, struct array *array);
void deleteScope(int sc);
void removeTop();
int getAddress(enum type tipo, int length);
void show();

int countFunctionParameters(char* id); 
struct nodo * getParameterByNumber(char *id, int n);