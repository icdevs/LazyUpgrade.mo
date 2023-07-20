import Person "./person";
import Text "mo:base/Text";
import List "mo:base/List";
import Buffer "mo:base/Buffer";

actor Test {

  stable var some_stored = Person.Init({first_name= "Alice"; last_name= "Jones"; age = ?1});
  let update_some_stored = func(x : Person.RawState){
    some_stored := x;
  };
  let some = Person.Person(#state some_stored);

  public query func get() : async Person.SharedState {
    some.get();
  };

  public query func get_raw() : async Person.RawState {
    some.get_raw(false);
  };

  // local
  public query func getb() : async Person.SharedState {
    let another = Person.Person(#init {first_name= "Alice"; last_name= "Jones"; age = ?1});
    another.get();
  };

  public shared func set_fname(name : Text ) : async Person.SharedState{
    some.set({some.get() with first_name = name}, update_some_stored);
  };


  

};