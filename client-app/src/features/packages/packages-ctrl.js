export default function PackagesCtrl(PackagesSvc) {
  const packagesCtrl = this;


  const setPackages = (packages) => {
    console.log("Packages: ", packages);
    packagesCtrl.packages = packages;
  };


  PackagesSvc.getPackages()
    .then(setPackages);
}
