import {curry} from 'ramda';

export default curry((errorTypeString, e) => {
  const prefix = errorTypeString + ' error: ';
  console.log(prefix, e);
});
