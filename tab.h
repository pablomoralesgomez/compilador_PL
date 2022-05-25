
enum 
enum type {caracter, entero, coma_flotante, String, boolean};

struct nodo {
    char *id;                               
    enum type tipo;
    struct nodo *sig;
};

struct nodo *primero = NULL;

int search(char* id);
int add(char* id);
void removeTop();
void show();