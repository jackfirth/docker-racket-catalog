import {compose, prop, values, concat} from 'ramda';
import readRacket from './read-racket';
import writeRacket from './write-racket';
import logError from './log-error';


const logPackageSvcError = logError('PackageSvc');
const readPackagesResponse = compose(values, readRacket, prop('data'));
const readPackageDetailsResponse = compose(readRacket, prop('data'));
const apiRoute = concat('/api/');
const packageRoute = compose(apiRoute, concat('pkg/'));
const API_ROUTE_ALL_PACKAGE_DETAILS = apiRoute('pkgs-all');

export default ($http) => {
  const getPackages = () => {
    return $http.get(API_ROUTE_ALL_PACKAGE_DETAILS)
      .then(readPackagesResponse)
      .catch(logPackageSvcError);
  };

  const putPackageDetails = (packageDetails) => {
    const name = packageDetails.name;
    const route = packageRoute(name);
    return $http.put(route, writeRacket(packageDetails))
      .then(readPackageDetailsResponse)
      .catch(logPackageSvcError);
  };

  return {
    getPackages,
    putPackageDetails
  };
};
