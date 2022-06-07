global{
  int x = 10;
}

header{
  int fibo(int n);
}


int main(){
  print("Resultado: ");
  int res = fibo(x);
  print(res);
  print("\n");
}

int fibo(int n){
  if (n == 1){
    return 1;
  }elif(n == 0){
    return 0;
  }
  return fibo(n - 1) + fibo(n - 2);
}