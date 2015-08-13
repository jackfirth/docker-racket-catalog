import R from 'ramda';
import {readRacketDataToJson} from './read-racket';


const logPackageSvcError = (e) => {
  console.log('PackageSvc error: ',  e.stack || e);
};


export default ($http) => {
  const getPackages = () => {
    return $http.get('/api/pkgs-all')
      .then(R.prop('data'))
      .then(readRacketDataToJson)
      .then(R.values)
      .catch(logPackageSvcError);
  };

  return {
    getPackages
  };
};
