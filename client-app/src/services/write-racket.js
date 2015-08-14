import {curry, addIndex, cond, is, join, map, compose, concat, values, T} from 'ramda';
import {isRacketSymbol, racketSymbolToString} from './racket-symbol';

const writeRacket = (v) => {
  const dispatch = cond([
    [isRacketSymbol, racketSymbolToString],
    [is(Number), writeNumber],
    [is(String), writeString],
    [is(Array), writeList],
    [is(Object), writeHash],
    [T, (v) => { throw new Error(`No matching clause for ${v}`); }]
  ]);
  return dispatch(v);
};

const wrapInParens = (string) => `(${string})`;
const spaceSeperated = join(' ');
const hashPrefix = '#hash';
const hashOf = compose(concat(hashPrefix), wrapInParens);

const writeString = (string) => `"${string}"`;
const writeNumber = (number) => `${number}`;

const writeList = compose(wrapInParens, spaceSeperated, map(writeRacket));

const writePair = curry((v, k, obj) => {
  return wrapInParens(writeRacket(k) + ' . ' + writeRacket(v));
});

const mapMapIndexed = curry((f, oldMap) => {
  const newMap = new Map();
  for (const [key, value] of oldMap) {
    newMap.set(key, f(value, key, oldMap));
  }
  return newMap;
});

const mapValues = (aMap) => {
  const vals = Array.from(aMap.values());
  return vals;
};

const writePairs = compose(spaceSeperated, mapValues, mapMapIndexed(writePair));
const writeHash = compose(hashOf, writePairs);

export default {
  writeRacket,
  writePair,
  writeHash
};
