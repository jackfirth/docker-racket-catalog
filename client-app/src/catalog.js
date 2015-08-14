import angular from 'angular';

import {controllers, configs} from './features';
import factories from './services';

import {exposeControllers, exposeFactories} from './module-util';


const catalog = angular.module('catalog', [
  'ngMaterial',
  'ngMessages',
  'ui.router'
]);

exposeControllers(catalog, controllers);
exposeFactories(catalog, factories);

catalog.config(configs.ToolbarConfig);
