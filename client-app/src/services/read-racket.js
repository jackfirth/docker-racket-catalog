import {fromPairs, compose, init, tail} from 'ramda';
import {regex, string, lazy, optWhitespace, seq} from 'parsimmon';


const lexeme = (parser) => parser.skip(optWhitespace);

const leftParen = lexeme(string('('));
const rightParen = lexeme(string(')'));
const hashLeftParen = lexeme(string('#hash('));
const hashEqLeftParen = lexeme(string('#hasheq('));
const dot = lexeme(string('.'));

const trueLiteral = lexeme(string('#t'));
const falseLiteral = lexeme(string('#f'));

const expr = lazy('an s-expression', () => form.or(atom));

const dropQuotes = compose(tail, init);

const numberLiteral = lexeme(regex(/[0-9]+/).map(parseInt));
const stringLiteral = lexeme(regex(/"[^"]*"/)).map(dropQuotes);
const symbol = lexeme(regex(/[a-z_]\w*/i));

const atom = numberLiteral
  .or(stringLiteral)
  .or(symbol)
  .or(trueLiteral)
  .or(falseLiteral);

const listLiteral = leftParen.then(expr.many()).skip(rightParen);

const hashPair = leftParen
  .then(seq(
    atom.skip(dot),
    expr
  ))
  .skip(rightParen);

const hashLiteral = hashLeftParen
  .or(hashEqLeftParen)
  .then(hashPair.many())
  .skip(rightParen)
  .map(fromPairs);

const form = listLiteral.or(hashLiteral);


export default {
  readPair: (str) => hashPair.parse(str).value,
  readRacket: (racketDataString) => {
    return expr.parse(racketDataString).value;
  }
};
