global{
  int count = 0;
}

header{
}

int main(){
  while(count < 3){
    print("Nested 1\n");
    while(true){
      print("\tNested 2\n");
      while(true){
        print("\t\tNested 3\n");
        count += 1;
        while (false){
          print("\t\t\tNested 4\n");
        }
        if (count == 3){
          break;
        }
        print("\t\tSe termina por: ");
        print(count);
        print(" vez\n");
      }
      break;
    }
  }
}