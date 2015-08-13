import {curry, toPairs, forEach, apply} from 'ramda';


const exposeAs = curry((type, module, name, def) => {
  module[type](name, def);
});


const exposeAllAs = curry((type, module, dict) => {
  const pairs = toPairs(dict);
  forEach(apply(exposeAs(type, module)), pairs);
});


const exposeFactories = exposeAllAs('factory');
const exposeControllers = exposeAllAs('controller');


export default {
  exposeFactories,
  exposeControllers
};
