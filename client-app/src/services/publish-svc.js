import {curry, contains, map, prop} from 'ramda';
import logError from './log-error';


const logPublishSvcError = logError('PublishSvc');
const getNames = map(prop('name'));

const assertNotMember = curry((message, v, vs) => {
  if (contains(v, vs)) {
    throw new Error(message);
  }
});

const assertUnpublished = (PackagesSvc, packageDetails) => {
  return PackagesSvc.getPackages()
    .then(getNames)
    .then(assertNotMember(
      `Expected package ${packageDetails.name} not to be published already`,
      packageDetails.name
    )).thenResolve(packageDetails);
};

export default (PackagesSvc) => {
  return {
    publishPackage: (packageDetails) => {
      return assertUnpublished(PackagesSvc, packageDetails)
        .then(PackagesSvc.putPackageDetails)
        .catch(logPublishSvcError);
    }
  };
};
