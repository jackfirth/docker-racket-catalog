import racketDatum from './racket-datum';

export default (racketDatumString) => racketDatum.parse(racketDatumString).value;
