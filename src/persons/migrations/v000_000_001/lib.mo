import MigrationTypes "../../types";
import D "mo:base/Debug";

module{

  public func upgrade(prevmigration_state: MigrationTypes.State): MigrationTypes.State {
    return prevmigration_state;
  };
};