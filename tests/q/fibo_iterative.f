global{
  int x = 8;
}

header{
  int fibo(int n);
}

int main(){
  int a = 0;
  int b = 1;
  int res = 0;
  for (int i = 2; i <= x; i += 1){
    res = a + b;
    a = b;
    b = res;
  }

  print("\nFibo de: ");
  print(x);
  print(" es :");
  print(res);
  print("\n");
}