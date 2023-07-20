import v0_0_1 "migrations/v000_000_001/types";
import v0_0_2 "migrations/v000_000_002/types";

module{

  public let Current = v0_0_2;

  public type State = {
    #v0_0_1: {#id; #data: v0_0_1.State};
    #v0_0_2: {#id; #data: v0_0_2.State};
  };

  

};