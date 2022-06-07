global{
  int x = 8;
}

header{
  int fibo(int n);
}


int main(){
  int res = fibo(x);

  print("Fibo de: ");
  print(x);
  print(" es :");
  print(res);
  print("\n");
}

int fibo(int n){
  if (n == 1){
    return 1;
  }elif(n == 0){
    return 0;
  }
  int a = fibo(n - 1);
  int b = fibo(n - 2);
  print("f");
  print(n);
  print(" = ");
  print(a);
  print(" + ");
  print(b);
  print("\n");

  return a + b;
}