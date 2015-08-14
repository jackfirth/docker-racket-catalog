import readRacket from './read-racket';

console.log(readPair('(foo . bar)'));
console.log(readRacket('#hash((foo . bar))'));
console.log(readRacket('#hasheq((foo . bar))'));
console.log(readRacket('#hash((foo . bar) (bar . foo))'));
console.log(readRacket('(foo bar baz)'))
console.log(readRacket('(1 2 3)'))
console.log(readRacket('(foo (1 2 3) bar)'))
console.log(readRacket('("aaa" "bbb" "cdef")'))
console.log(readRacket('#hash((foo . ("a" "b" "c")) (bar . (1 2 3)))'))
