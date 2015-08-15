import PackagesSvc from './packages-svc';
import PublishSvc from './publish-svc';


export default {
  PackagesSvc: ['$http', PackagesSvc],
  PublishSvc: ['PackagesSvc', PublishSvc]
};
