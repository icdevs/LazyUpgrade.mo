import MigrationTypes "types";
import v0_0_1 "./migrations/v000_000_001";
import v0_0_2 "./migrations/v000_000_002";
import D "mo:base/Debug";
import List "mo:base/List";

module{

  let upgrades = [
    v0_0_1.upgrade,
    v0_0_2.upgrade,
  ];

  func getMigrationId(state: MigrationTypes.State): Nat {
    return switch (state) {
      case (#v0_0_1(_)) 0;
      case (#v0_0_2(_)) 1;
      // do not forget to add your new migration id here
      // should be increased by 1 as it will be later used as an index to get upgrade/downgrade methods
    };
  };

  public func migrate(
    prevState: MigrationTypes.State, 
    nextState: MigrationTypes.State
  ): MigrationTypes.State {

   // D.print("in migrate" # debug_show(prevState));
    var state = prevState;
    var migrationId = getMigrationId(prevState);
    D.print("getting migration id");
    let nextMigrationId = getMigrationId(nextState);
    D.print(debug_show(nextMigrationId));

    while (migrationId != nextMigrationId) {
      D.print("in nft while" # debug_show((nextMigrationId, migrationId)));
      let migrate = if (nextMigrationId > migrationId) upgrades[migrationId] else D.trap("improper upgrade sequence");
      D.print("upgrade should have run");
      migrationId := if (nextMigrationId > migrationId) migrationId + 1 else D.trap("improper upgrade sequence");

      state := migrate(state);
    };

    return state;
  };


  /* public func Init(item: MigrationTypes.Current.State) : MigrationTypes.State {
   #v0_0_2(#data(item));
  }; */


  public type Store<RAW_STATE> = List.List<RAW_STATE>;

  public type Init<RAW_STATE> = List.List<RAW_STATE>;

  public func Init<RAW_STATE>(p: Init<RAW_STATE>) : Store<RAW_STATE> {
    var result: List.List<RAW_STATE> = List.nil<RAW_STATE>();
    for(thisItem in List.toIter<RAW_STATE>(p)){
      result := List.push<RAW_STATE>(thisItem, result);
    };
    result;
  };

  public type SharedState = MigrationTypes.Current.State;
  public type RawState = MigrationTypes.State;

  public class Storage<RAW_STATE, SHARED_STATE>(from: {
    #state: Store<RAW_STATE>;
    #init: Init<RAW_STATE>;
  }){

    var mem : Store<RAW_STATE> = switch(from) {
      case (#state(x)) x;
      case (#init(p)) Init(p); 
    };

    public func get(index : Nat) : SHARED_STATE {
      let #v0_0_2(#data(state_current)) = get_raw(index, true) else D.trap("Improper upgrade");
      state_current;
    };

    //no ability to async upgrade
    public func get_raw(index: Nat, upgrade : Bool) : RAW_STATE {
      if(upgrade){
        switch(mem){
          case(#v0_0_2(val)){};
          case(_){
            //mem := migrate(mem, #v0_0_2(#id), { owner = deployer.caller; storage_space = 0;});
            mem := migrate(mem, #v0_0_2(#id));
          };
        };
      };
      mem;
    };

    public func set(item : MigrationTypes.Current.State,  store_updater : (MigrationTypes.State) -> ()) : MigrationTypes.Current.State{
      mem := #v0_0_2(#data(item));
      store_updater(mem);
      let #v0_0_2(#data(state_current)) = mem else D.trap("Improper upgrade");
      state_current;
    };

  };

};