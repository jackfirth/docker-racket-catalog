import {makeRacketSymbol} from '../../services/racket-symbol';

export default function PublishCtrl(PublishSvc) {
  const publishCtrl = this;
  publishCtrl.newPackage = {};
  publishCtrl.publishNewPackage = () => {
    const {name, author, source, description} = publishCtrl.newPackage;
    const symName = makeRacketSymbol('name');
    const symAuthor = makeRacketSymbol('author');
    const symSource = makeRacketSymbol('source');
    const symDescription = makeRacketSymbol('description');
    const newPackageDetails = new Map();
    newPackageDetails.set(symName, name);
    newPackageDetails.set(symAuthor, author);
    newPackageDetails.set(symSource, source);
    newPackageDetails.set(symDescription, description);
    PublishSvc.publishPackage(newPackageDetails)
      .then((response) => console.log('Success: ', response));
  };
}
