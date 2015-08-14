import angular from 'angular';

import controllers from './features';
import factories from './services';

import {exposeControllers, exposeFactories} from './module-util';


const catalog = angular.module('catalog', [
  'ngMaterial'
]);

exposeControllers(catalog, controllers);
exposeFactories(catalog, factories);
