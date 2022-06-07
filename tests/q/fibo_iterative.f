global{
  
}

header{
  int fibo(int n);
}

int main(){
  int a = 0;
  int b = 1;
  int res = 0;
  int x = 8;
  #print("\n");
  #print(x);
  #print("\n");
  #print("\nx : ");
  #print(x);
  for (int i = 0; i < x; i = i + 1){
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