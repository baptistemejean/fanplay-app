class Account{
  String username;
  String email;
  String password;
  bool empty = false;

  Account(this.username, this.email, this.password);

  static Empty(){
    var ac = Account("", "", "");
    ac.empty = true;

    return ac;
  }

  bool isEmpty(){
    return (empty && username.isEmpty && email.isEmpty && password.isEmpty);
  }


}