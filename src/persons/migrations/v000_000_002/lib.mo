import MigrationTypes "../../types";
import D "mo:base/Debug";

module{


  public func upgrade(prevmigration_state: MigrationTypes.State): MigrationTypes.State {
    let #v0_0_1(#data(data)) = prevmigration_state else D.trap("improper upgrade v0_0_1 to v0_0_2");

    return #v0_0_2(#data({
      data with
      age = null;
    }));
  };

};