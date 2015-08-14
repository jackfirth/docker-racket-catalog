export default function PackagesCtrl(PackagesSvc) {
  const packagesCtrl = this;


  const setPackages = (packages) => {
    packagesCtrl.packages = packages;
  };


  PackagesSvc.getPackages()
    .then(setPackages);
}
