// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Core__Option from "@rescript/core/src/Core__Option.mjs";

var Resolver = {};

function decode(str) {
  if (str === "AuctionSettled") {
    return "AuctionSettled";
  }
  
}

var ImplementedBy = {
  decode: decode
};

function make(typeMap, valueToString) {
  return {
          typeToValue: typeMap,
          valueToTypeAsString: Js_dict.fromArray(Js_dict.entries(typeMap).map(function (param) {
                    return [
                            valueToString(param[1]),
                            param[0]
                          ];
                  })),
          valueToString: valueToString
        };
}

function getStringifiedValueByType(t, typ) {
  return t.valueToString(Core__Option.getExn(t.typeToValue[typ]));
}

function getTypeByStringifiedValue(t, str) {
  return Core__Option.map(t.valueToTypeAsString[str], (function (prim) {
                return prim;
              }));
}

var TypeMap = {
  make: make,
  getTypeByStringifiedValue: getTypeByStringifiedValue,
  getStringifiedValueByType: getStringifiedValueByType
};

export {
  Resolver ,
  ImplementedBy ,
  TypeMap ,
}
/* No side effect */
