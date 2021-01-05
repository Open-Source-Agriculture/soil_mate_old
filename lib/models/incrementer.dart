class Incrementer{
  int value = 0;

  int getValue(){
    return this.value;
  }

  void increment(){
    this.value = this.value + 1;
  }

  void decrement(){
    this.value = this.value - 1;
  }

  void setValue(int value){
    this.value = value;
  }
}