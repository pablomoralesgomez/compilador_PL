global {
	int exp = 5;
	int base = 2;
}

int main() {
	int result = 1;
	
    while (exp != 0  and exp != 1) {
        result *= base;
        exp = exp - 1;
    }
    print("Respuesta = ");
	print(result);
	print("\n");
}