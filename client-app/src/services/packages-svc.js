import R from 'ramda';
import readRacket from './read-racket';


const logPackageSvcError = (e) => {
  console.log('PackageSvc error: ',  e.stack || e);
};


export default ($http) => {
  const getPackages = () => {
    return $http.get('/api/pkgs-all')
      .then(R.prop('data'))
      .then(R.tap(v => console.log("Data: ", v)))
      .then(readRacket)
      .then(R.tap(v => console.log("Catalog: ", v)))
      .then(R.values)
      .catch(logPackageSvcError);
  };

  return {
    getPackages
  };
};
