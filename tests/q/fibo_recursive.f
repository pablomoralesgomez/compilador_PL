global{
  int x = 3;
}

header{
  int fibo(int n);
}


int main(){
  print("Fibo de: ");
  print(x);
  print(" es :\n");
  print(fibo(x));
}

int fibo(int n){
  if (n == 1){
    return 1;
  }elif(n == 0){
    return 0;
  }
  int a = fibo(n - 1);
  int b = fibo(n - 2);
  print("f:");
  print(n);
  print(" = ");
  print(a);
  print(" + ");
  print(b);
  print("\n");

  return a + b;
}