// Huge point of befuddlement - Racket symbols and Javascript symbols are
// two COMPLETELY different things. Therefore, Racket symbols are wrapped
// in an opaque object rather than being converted to Javascript symbols.
// However, the implementation of this opaque object uses Javascript
// symbols to encapsulate the properties. This is gonna get real confusing.

const symbolIsRacketSymbol = Symbol('isRacketSymbol');
const symbolRacketSymbolValue = Symbol('racketSymbolValue');

const makeRacketSymbol = (v) => {
  const obj = {};
  obj[symbolIsRacketSymbol] = true;
  obj[symbolRacketSymbolValue] = v;
  return obj;
};

const racketSymbolToString = (racketSymbol) => racketSymbol[symbolRacketSymbolValue];
const isRacketSymbol = (v) => v[symbolIsRacketSymbol] === true;

export default {
  makeRacketSymbol,
  isRacketSymbol,
  racketSymbolToString
};
